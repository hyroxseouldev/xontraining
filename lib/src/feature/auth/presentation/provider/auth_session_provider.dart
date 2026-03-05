import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/supabase/supabase_provider.dart';

part 'auth_session_provider.g.dart';

@riverpod
Stream<User?> authSession(Ref ref) async* {
  final supabase = ref.read(supabaseClientProvider);

  yield supabase.auth.currentUser;
  await for (final authState in supabase.auth.onAuthStateChange) {
    yield authState.session?.user;
  }
}
