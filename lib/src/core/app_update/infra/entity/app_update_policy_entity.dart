enum AppUpdatePlatform {
  ios,
  android;

  String get value {
    return switch (this) {
      AppUpdatePlatform.ios => 'ios',
      AppUpdatePlatform.android => 'android',
    };
  }

  static AppUpdatePlatform? fromValue(String value) {
    return switch (value.trim().toLowerCase()) {
      'ios' => AppUpdatePlatform.ios,
      'android' => AppUpdatePlatform.android,
      _ => null,
    };
  }
}

class AppUpdatePolicyEntity {
  const AppUpdatePolicyEntity({
    required this.platform,
    required this.minimumVersion,
    required this.storeUrl,
    required this.isActive,
  });

  final AppUpdatePlatform platform;
  final String minimumVersion;
  final String storeUrl;
  final bool isActive;
}
