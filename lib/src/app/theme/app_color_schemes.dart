import 'package:flutter/material.dart';

class AppColorSchemes {
  const AppColorSchemes._();

  static final ColorScheme light =
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF111111),
        brightness: Brightness.light,
      ).copyWith(
        primary: const Color(0xFF111111),
        onPrimary: Colors.white,
        surface: Colors.white,
        primaryContainer: const Color(0xFFE7E7E7),
        onPrimaryContainer: const Color(0xFF111111),
        secondary: const Color(0xFF2F2F2F),
        onSecondary: Colors.white,
        secondaryContainer: const Color(0xFFE1E1E1),
        onSecondaryContainer: const Color(0xFF1A1A1A),
        tertiary: const Color(0xFF3A3A3A),
        onTertiary: Colors.white,
        tertiaryContainer: const Color(0xFFEBEBEB),
        onTertiaryContainer: const Color(0xFF1A1A1A),
      );

  static final ColorScheme dark =
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF111111),
        brightness: Brightness.dark,
      ).copyWith(
        primary: const Color(0xFFECECEC),
        onPrimary: const Color(0xFF111111),
        primaryContainer: const Color(0xFF2D2D2D),
        onPrimaryContainer: const Color(0xFFECECEC),
        secondary: const Color(0xFFCDCDCD),
        onSecondary: const Color(0xFF1A1A1A),
        secondaryContainer: const Color(0xFF383838),
        onSecondaryContainer: const Color(0xFFEAEAEA),
        tertiary: const Color(0xFFCFCFCF),
        onTertiary: const Color(0xFF1A1A1A),
        tertiaryContainer: const Color(0xFF3D3D3D),
        onTertiaryContainer: const Color(0xFFEAEAEA),
      );
}
