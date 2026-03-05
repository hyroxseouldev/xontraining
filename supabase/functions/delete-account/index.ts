import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

type DeleteAccountBody = {
  tenantId?: string;
};

function jsonResponse(status: number, body: Record<string, unknown>): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
    },
  });
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return jsonResponse(405, {
      code: "METHOD_NOT_ALLOWED",
      message: "Only POST is supported.",
    });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
    if (supabaseUrl.isEmpty || serviceRoleKey.isEmpty) {
      return jsonResponse(500, {
        code: "SERVER_CONFIG_ERROR",
        message: "Missing Supabase environment configuration.",
      });
    }

    const authHeader = req.headers.get("Authorization") ?? "";
    const bearerPrefix = "Bearer ";
    if (!authHeader.startsWith(bearerPrefix)) {
      return jsonResponse(401, {
        code: "UNAUTHORIZED",
        message: "Missing bearer token.",
      });
    }

    const accessToken = authHeader.substring(bearerPrefix.length).trim();
    if (accessToken.isEmpty) {
      return jsonResponse(401, {
        code: "UNAUTHORIZED",
        message: "Invalid bearer token.",
      });
    }

    const adminClient = createClient(supabaseUrl, serviceRoleKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });

    const { data: authData, error: authError } = await adminClient.auth.getUser(
      accessToken,
    );

    if (authError != null || authData.user == null) {
      return jsonResponse(401, {
        code: "UNAUTHORIZED",
        message: "Could not verify user token.",
      });
    }

    const body = (await req.json().catch(() => ({}))) as DeleteAccountBody;
    const tenantId = body.tenantId?.trim() ?? "";
    if (tenantId.isEmpty) {
      return jsonResponse(400, {
        code: "TENANT_REQUIRED",
        message: "tenantId is required.",
      });
    }

    const userId = authData.user.id;
    const { data: membership, error: membershipError } = await adminClient
      .from("tenant_memberships")
      .select("role")
      .eq("tenant_id", tenantId)
      .eq("user_id", userId)
      .maybeSingle();

    if (membershipError != null) {
      return jsonResponse(500, {
        code: "MEMBERSHIP_LOOKUP_FAILED",
        message: "Failed to verify membership role.",
      });
    }

    if (membership == null || membership.role !== "member") {
      return jsonResponse(403, {
        code: "FORBIDDEN_ROLE",
        message: "Only members can delete their account.",
      });
    }

    const { error: deleteClassesError } = await adminClient
      .from("offline_classes")
      .delete()
      .eq("tenant_id", tenantId)
      .eq("created_by", userId);

    if (deleteClassesError != null) {
      return jsonResponse(500, {
        code: "OFFLINE_CLASSES_DELETE_FAILED",
        message: "Failed to delete offline classes created by user.",
      });
    }

    const { error: deleteUserError } = await adminClient.auth.admin.deleteUser(
      userId,
    );
    if (deleteUserError != null) {
      return jsonResponse(500, {
        code: "DELETE_FAILED",
        message: "Failed to delete account.",
      });
    }

    return jsonResponse(200, {
      code: "OK",
      message: "Account deleted successfully.",
    });
  } catch (_) {
    return jsonResponse(500, {
      code: "UNEXPECTED_ERROR",
      message: "Unexpected error occurred while deleting account.",
    });
  }
});
