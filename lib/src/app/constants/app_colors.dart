import 'package:flutter/material.dart';

/// AppColors — central color palette for the eCardo app.
/// Based on NUVO Palette (Dark / Neutral / Soft Blue / Warm Metallic).
///
/// All screens should reference colors from this class only.
/// Never hardcode hex values in widgets.
class AppColors {
  const AppColors._();

  // ------------------ NUVO PALETTE SPEC ------------------
  static const Color deepBlack = Color(0xFF161614); /* Primary Background */
  static const Color darkGray = Color(0xFF262625); /* Secondary Background */
  static const Color softGray = Color(0xFF656262); /* Secondary Text / Icons */
  static const Color warmWhite = Color(0xFFE7E0DE); /* Primary Text / Light Surface */
  static const Color lightWarmGray = Color(0xFFD5CBC8); /* Borders / Dividers */
  static const Color mainSoftBlue = Color(0xFFABC3EA); /* Primary Accent / Main Surface */
  static const Color mutedBlue = Color(0xFF849ACD); /* Secondary Accent / Cards */
  static const Color warmBrown = Color(0xFF87624C); /* Financial / Card Elements */
  static const Color taupeBronze = Color(0xFFB3A9A5); /* Warm Neutral / Metallic */

  // ------------------ LIGHT THEME ------------------

  // Background Colors
  static const Color lightBackground = Color(0xFFF9F9FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF0EDEC);
  static const Color lightCard = Color(0xFFFFFFFF);

  // Primary Colors (etrip brand: deep navy / deep black)
  static const Color lightPrimary = Color(0xFF0A1628);
  static const Color lightPrimaryContainer = Color(0xFFE9E4D6);
  static const Color lightPrimaryDark = Color(0xFF132A4E);

  // Accent / Secondary (etrip brand: gold / soft blue)
  static const Color lightSecondary = Color(0xFFD4AF37);
  static const Color lightSecondaryContainer = Color(0xFFFBF6E9);
  static const Color lightAccent = Color(0xFFD4AF37);

  // Text Colors
  static const Color lightTextPrimary = Color(0xFF161614);
  static const Color lightTextSecondary = Color(0xFF656262);
  static const Color lightTextTertiary = Color(0x99161614);
  static const Color lightTextHint = Color(0xFF9E9E9E);
  static const Color lightTextOnPrimary = Color(0xFFFFFFFF);

  // Border / Divider
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightOutline = Color(0xFFD5CBC8);
  static const Color lightOutlineVariant = Color(0xFFE8E2E0);
  static const Color lightDivider = Color(0xFFEEEEEE);
  static const Color lightShadow = Color(0x1A000000);

  // ------------------ UTILITY ------------------

  // Error/Warning/Success
  static const Color error = Color(0xFFDC3C22);
  static const Color errorContainer = Color(0xFFFDECEA);
  static const Color warning = Color(0xFFFFAA00);
  static const Color warningContainer = Color(0xFFFFF8E1);
  static const Color success = Color(0xFF14AE6F);
  static const Color successContainer = Color(0xFFE8F8F0);
  static const Color info = Color(0xFF2196F3);
  static const Color infoContainer = Color(0xFFE3F2FD);

  // Neutral
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color grey = softGray;
  static const Color greyLight = lightWarmGray;
  static const Color greyDark = darkGray;

  // ------------------ DARK THEME ------------------
  static const Color darkBackground = deepBlack;
  static const Color darkSurface = darkGray;
  static const Color darkSurfaceVariant = Color(0xFF323230);
  static const Color darkCard = darkGray;
  static const Color darkPrimary = mainSoftBlue;
  static const Color darkPrimaryContainer = Color(0xFF1E2E42);
  static const Color darkPrimaryDark = deepBlack;
  static const Color darkSecondary = Color(0xFFD4AF37);
  static const Color darkSecondaryContainer = Color(0xFF3A321E);
  static const Color darkAccent = mainSoftBlue;
  static const Color darkTextPrimary = warmWhite;
  static const Color darkTextSecondary = softGray;
  static const Color darkTextTertiary = Color(0x8CE7E0DE);
  static const Color darkTextHint = softGray;
  static const Color darkTextOnPrimary = deepBlack;
  static const Color darkBorder = Color(0x33D5CBC8);
  static const Color darkOutline = Color(0x4DD5CBC8);
  static const Color darkOutlineVariant = Color(0x26D5CBC8);
  static const Color darkDivider = Color(0x33D5CBC8);
  static const Color darkShadow = Color(0x33000000);
}
