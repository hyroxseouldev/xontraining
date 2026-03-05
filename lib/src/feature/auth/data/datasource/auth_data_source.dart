import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/supabase/supabase_provider.dart';

part 'auth_data_source.g.dart';

const _googleScopes = <String>['email', 'profile', 'openid'];

abstract interface class AuthDataSource {
  Future<void> signInWithGoogle();
  Future<void> signOut();
  Future<bool> isOnboardingCompleted();
  Future<void> completeOnboarding({required String fullName});
  Future<String?> getMyFullName();
  Future<String?> getMyAvatarUrl();
  Future<void> updateMyFullName({required String fullName});
  Future<void> updateMyAvatarUrl({required String avatarUrl});
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
        .select('onboarding_completed')
        .eq('id', userId)
        .maybeSingle();

    final onboardingCompleted = profile?['onboarding_completed'];
    if (onboardingCompleted is bool) {
      return onboardingCompleted;
    }

    return false;
  }

  @override
  Future<void> completeOnboarding({required String fullName}) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    await supabase
        .from('profiles')
        .update({'full_name': fullName.trim(), 'onboarding_completed': true})
        .eq('id', userId);
  }

  @override
  Future<String?> getMyFullName() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    final profile = await supabase
        .from('profiles')
        .select('full_name')
        .eq('id', userId)
        .maybeSingle();

    final fullName = profile?['full_name'];
    if (fullName is String && fullName.trim().isNotEmpty) {
      return fullName;
    }

    return null;
  }

  @override
  Future<String?> getMyAvatarUrl() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    final profile = await supabase
        .from('profiles')
        .select('avatar_url')
        .eq('id', userId)
        .maybeSingle();

    final avatarUrl = profile?['avatar_url'];
    if (avatarUrl is String && avatarUrl.trim().isNotEmpty) {
      return avatarUrl;
    }

    return null;
  }

  @override
  Future<void> updateMyFullName({required String fullName}) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    await supabase
        .from('profiles')
        .update({'full_name': fullName.trim()})
        .eq('id', userId);
  }

  @override
  Future<void> updateMyAvatarUrl({required String avatarUrl}) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    await supabase
        .from('profiles')
        .update({'avatar_url': avatarUrl.trim()})
        .eq('id', userId);
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
