class AppUpdateCheckResult {
  const AppUpdateCheckResult._({
    required this.requiresForceUpdate,
    required this.currentVersion,
    this.minimumVersion,
    this.storeUrl,
  });

  const AppUpdateCheckResult.noUpdate({required String currentVersion})
    : this._(requiresForceUpdate: false, currentVersion: currentVersion);

  const AppUpdateCheckResult.forceUpdate({
    required String currentVersion,
    required String minimumVersion,
    required String storeUrl,
  }) : this._(
         requiresForceUpdate: true,
         currentVersion: currentVersion,
         minimumVersion: minimumVersion,
         storeUrl: storeUrl,
       );

  final bool requiresForceUpdate;
  final String currentVersion;
  final String? minimumVersion;
  final String? storeUrl;
}
