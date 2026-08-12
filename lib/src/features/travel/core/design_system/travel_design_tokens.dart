import 'package:flutter/material.dart';

/// Shared visual tokens for the Travel feature.
///
/// These tokens intentionally live outside individual screens so future Travel
/// domains (hotel, flight, eSIM and tour) use the same visual language.
class TravelColors {
  const TravelColors._();

  static const Color ink = Color(0xFF0A1628);
  static const Color inkMuted = Color(0xFF5F6B7A);
  static const Color canvas = Color(0xFFF7F8FA);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE3E7ED);
  static const Color borderStrong = Color(0xFFC9D1DC);

  static const Color primary = Color(0xFF123C73);
  static const Color primaryDark = Color(0xFF0A1628);
  static const Color accent = Color(0xFFD4AF37);
  static const Color accentSoft = Color(0xFFF7EEC7);

  static const Color hotel = Color(0xFF7656D6);
  static const Color flight = Color(0xFF2F80ED);
  static const Color esim = Color(0xFFE0B62E);
  static const Color tour = Color(0xFF1B9A73);

  static const Color success = Color(0xFF16865B);
  static const Color successSurface = Color(0xFFE8F7F0);
  static const Color warning = Color(0xFFB66A00);
  static const Color warningSurface = Color(0xFFFFF4DF);
  static const Color error = Color(0xFFB3261E);
  static const Color errorSurface = Color(0xFFFFEBE9);
  static const Color info = Color(0xFF1769AA);
  static const Color infoSurface = Color(0xFFEAF4FF);
}

class TravelSpacing {
  const TravelSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
  static const double section = 48;
}

class TravelRadii {
  const TravelRadii._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 999;
}

class TravelBorders {
  const TravelBorders._();

  static const double hairline = 1;
  static const double emphasis = 1.5;
}

class TravelElevations {
  const TravelElevations._();

  static const double none = 0;
  static const double card = 1;
  static const double sheet = 8;
  static const double dialog = 16;
}

class TravelShadows {
  const TravelShadows._();

  static const List<BoxShadow> card = <BoxShadow>[
    BoxShadow(color: Color(0x120A1628), blurRadius: 18, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> floating = <BoxShadow>[
    BoxShadow(color: Color(0x1A0A1628), blurRadius: 24, offset: Offset(0, 12)),
  ];
}

class TravelTypography {
  const TravelTypography._();

  static const String primaryFont = 'Plus Jakarta Sans';
  static const List<String> fallbackFonts = <String>['Vazirmatn', 'NotoSansRU'];

  static const TextStyle display = TextStyle(
    fontFamily: primaryFont,
    fontSize: 30,
    height: 1.2,
    fontWeight: FontWeight.w800,
    color: TravelColors.ink,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    height: 1.25,
    fontWeight: FontWeight.w800,
    color: TravelColors.ink,
  );

  static const TextStyle title = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    height: 1.35,
    fontWeight: FontWeight.w700,
    color: TravelColors.ink,
  );

  static const TextStyle body = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: TravelColors.ink,
  );

  static const TextStyle label = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    height: 1.35,
    fontWeight: FontWeight.w600,
    color: TravelColors.inkMuted,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: primaryFont,
    fontSize: 11,
    height: 1.35,
    fontWeight: FontWeight.w500,
    color: TravelColors.inkMuted,
  );
}

class TravelThemeData {
  const TravelThemeData._();

  static ThemeData light() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: TravelColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: TravelColors.primary,
          onPrimary: Colors.white,
          secondary: TravelColors.accent,
          onSecondary: TravelColors.ink,
          surface: TravelColors.surface,
          error: TravelColors.error,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: TravelColors.canvas,
      fontFamily: TravelTypography.primaryFont,
      fontFamilyFallback: TravelTypography.fallbackFonts,
      textTheme: const TextTheme(
        displayLarge: TravelTypography.display,
        headlineMedium: TravelTypography.headline,
        titleLarge: TravelTypography.title,
        bodyMedium: TravelTypography.body,
        labelLarge: TravelTypography.label,
        bodySmall: TravelTypography.caption,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: TravelColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: TravelSpacing.md,
          vertical: TravelSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TravelRadii.md),
          borderSide: const BorderSide(color: TravelColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TravelRadii.md),
          borderSide: const BorderSide(color: TravelColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TravelRadii.md),
          borderSide: const BorderSide(
            color: TravelColors.primary,
            width: TravelBorders.emphasis,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TravelRadii.md),
          borderSide: const BorderSide(color: TravelColors.error),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: TravelColors.border,
        thickness: TravelBorders.hairline,
        space: TravelSpacing.md,
      ),
    );
  }
}
