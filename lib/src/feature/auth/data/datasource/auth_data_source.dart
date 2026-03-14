import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/supabase/supabase_provider.dart';

part 'auth_data_source.g.dart';

const _googleScopes = <String>['email', 'profile', 'openid'];

abstract interface class AuthDataSource {
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
  Future<void> signOut();
  Future<bool> isOnboardingCompleted();
  Future<void> completeOnboarding({required String gender});
  Future<Map<String, dynamic>> getMyProfile();
  Future<void> updateMyProfile({
    String? fullName,
    String? gender,
    String? avatarUrl,
  });
  Future<String?> getMyTenantRole({required String tenantId});
  Future<void> deleteMyAccount({required String tenantId});
}

class SupabaseAuthDataSource implements AuthDataSource {
  SupabaseAuthDataSource({required this.supabase, required this.googleSignIn});

  final SupabaseClient supabase;
  final GoogleSignIn googleSignIn;

  @override
  Future<void> signInWithGoogle() async {
    final googleUser = await googleSignIn.authenticate(
      scopeHint: _googleScopes,
    );

    final idToken = googleUser.authentication.idToken;
    final authzClient = googleUser.authorizationClient;
    final authz =
        await authzClient.authorizationForScopes(_googleScopes) ??
        await authzClient.authorizeScopes(_googleScopes);
    final accessToken = authz.accessToken;

    if (idToken == null || accessToken.isEmpty) {
      throw Exception('Missing Google token. idToken/accessToken not found.');
    }

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Future<void> signInWithApple() async {
    final rawNonce = supabase.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null || idToken.isEmpty) {
      throw AuthException('Missing Apple identity token.');
    }

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }

  @override
  Future<void> signOut() async {
    await googleSignIn.signOut();
    await supabase.auth.signOut();
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      return false;
    }

    final profile = await supabase
        .from('profiles')
        .select('onboarding_completed,is_deleted')
        .eq('id', userId)
        .maybeSingle();

    final isDeleted = profile?['is_deleted'];
    if (isDeleted is bool && isDeleted) {
      throw AuthException('Account has been deactivated.');
    }

    final onboardingCompleted = profile?['onboarding_completed'];
    if (onboardingCompleted is bool) {
      return onboardingCompleted;
    }

    return false;
  }

  @override
  Future<void> completeOnboarding({required String gender}) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    await supabase
        .from('profiles')
        .update({'gender': gender.trim(), 'onboarding_completed': true})
        .eq('id', userId);
  }

  @override
  Future<Map<String, dynamic>> getMyProfile() async {
    final userId = supabase.auth.currentUser?.id;
    final userMetadata = supabase.auth.currentUser?.userMetadata;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    final profile = await supabase
        .from('profiles')
        .select('full_name,avatar_url,gender,onboarding_completed,is_deleted')
        .eq('id', userId)
        .maybeSingle();

    final isDeleted = profile?['is_deleted'];
    if (isDeleted is bool && isDeleted) {
      throw AuthException('Account has been deactivated.');
    }

    return <String, dynamic>{
      ...?profile,
      'fallback_full_name': userMetadata?['full_name'],
      'fallback_avatar_url':
          userMetadata?['avatar_url'] ?? userMetadata?['picture'],
    };
  }

  @override
  Future<void> updateMyProfile({
    String? fullName,
    String? gender,
    String? avatarUrl,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    final updatePayload = <String, dynamic>{};
    if (fullName != null) {
      updatePayload['full_name'] = fullName.trim();
    }
    if (gender != null) {
      updatePayload['gender'] = gender.trim();
    }
    if (avatarUrl != null) {
      updatePayload['avatar_url'] = avatarUrl.trim();
    }

    if (updatePayload.isEmpty) {
      return;
    }

    await supabase.from('profiles').update(updatePayload).eq('id', userId);
  }

  @override
  Future<String?> getMyTenantRole({required String tenantId}) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    final membership = await supabase
        .from('tenant_memberships')
        .select('role')
        .eq('tenant_id', tenantId)
        .eq('user_id', userId)
        .maybeSingle();

    final role = membership?['role'];
    if (role is String && role.trim().isNotEmpty) {
      return role.trim();
    }

    return null;
  }

  @override
  Future<void> deleteMyAccount({required String tenantId}) async {
    try {
      await supabase.rpc(
        'soft_delete_my_account',
        params: {'p_tenant_id': tenantId},
      );
    } on PostgrestException catch (error) {
      final message = error.message.trim();
      throw AuthException(
        message.isEmpty ? 'Failed to deactivate account.' : message,
      );
    }
  }
}

@riverpod
GoogleSignIn googleSignIn(Ref ref) {
  return GoogleSignIn.instance;
}

@riverpod
AuthDataSource authDataSource(Ref ref) {
  return SupabaseAuthDataSource(
    supabase: ref.read(supabaseClientProvider),
    googleSignIn: ref.read(googleSignInProvider),
  );
}
