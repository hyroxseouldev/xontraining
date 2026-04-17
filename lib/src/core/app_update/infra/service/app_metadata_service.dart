import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract interface class AppMetadataService {
  bool get isIos;

  Future<String> getAppVersion();
}

class DeviceAppMetadataService implements AppMetadataService {
  @override
  bool get isIos => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version.trim();
  }
}

final appMetadataServiceProvider = Provider<AppMetadataService>((ref) {
  return DeviceAppMetadataService();
});
