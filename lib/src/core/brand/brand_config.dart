import 'package:flutter/material.dart';
import 'package:xontraining/src/app/theme/app_theme.dart';
import 'package:xontraining/src/core/brand/brand.dart';

class BrandConfig {
  const BrandConfig({
    required this.brand,
    required this.tenantId,
    required this.displayNameEn,
    required this.displayNameKo,
    required this.logoAssetPath,
    required this.appIconAssetPath,
    required this.lightTheme,
    required this.darkTheme,
  });

  final Brand brand;
  final String tenantId;
  final String displayNameEn;
  final String displayNameKo;
  final String logoAssetPath;
  final String appIconAssetPath;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  String displayNameFor(Locale locale) {
    return locale.languageCode == 'ko' ? displayNameKo : displayNameEn;
  }

  static final xon = BrandConfig(
    brand: Brand.xon,
    tenantId: 'f95921fa-315f-4957-8f12-16a3ce5b9ac3',
    displayNameEn: 'XON Training',
    displayNameKo: 'XON Training',
    logoAssetPath: 'assets/xon/logo.png',
    appIconAssetPath: 'assets/xon/app-icon.png',
    lightTheme: AppTheme.light,
    darkTheme: AppTheme.dark,
  );

  static final amor = BrandConfig(
    brand: Brand.amor,
    tenantId: '8e4f2364-ddd7-4e65-8238-6951d67b4c42',
    displayNameEn: 'AMOR Training',
    displayNameKo: 'AMOR Training',
    logoAssetPath: 'assets/xon/logo.png',
    appIconAssetPath: 'assets/xon/app-icon.png',
    lightTheme: AppTheme.light,
    darkTheme: AppTheme.dark,
  );

  static BrandConfig fromBrand(Brand brand) {
    return switch (brand) {
      Brand.xon => xon,
      Brand.amor => amor,
    };
  }
}
