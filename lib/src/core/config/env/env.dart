import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract final class Env {
  @EnviedField(varName: 'SUPABASE_URL')
  static final String supabaseUrl = _Env.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static final String supabaseAnonKey = _Env.supabaseAnonKey;

  @EnviedField(varName: 'GOOGLE_WEB_CLIENT_ID', defaultValue: '')
  static final String googleWebClientId = _Env.googleWebClientId;

  @EnviedField(varName: 'GOOGLE_IOS_CLIENT_ID')
  static final String googleIosClientId = _Env.googleIosClientId;

  @EnviedField(varName: 'TENANT_ID')
  static final String tenantId = _Env.tenantId;
}
