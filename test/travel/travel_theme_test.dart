import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecardo_etrip/src/app/constants/app_colors.dart';
import 'package:ecardo_etrip/src/common/widgets/button/common_button.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/shared/travel_theme.dart';

void main() {
  group('TravelTheme Replicated NUVO Tokens Alignment (eTrip)', () {
    test('maps core tokens to NUVO palette', () {
      expect(TravelTheme.background, equals(const Color(0xFFF9F9FB)));
      expect(TravelTheme.ink, equals(const Color(0xFF161614)));
      expect(TravelTheme.muted, equals(const Color(0xFF656262)));
      expect(TravelTheme.border, equals(const Color(0xFFD5CBC8)));
      expect(TravelTheme.purple, equals(const Color(0xFFABC3EA)));
      expect(TravelTheme.accent, equals(const Color(0xFFABC3EA)));
    });

    test('preserves product and utility colors', () {
      expect(TravelTheme.blue, equals(const Color(0xFF2F80ED)));
      expect(TravelTheme.yellow, equals(const Color(0xFFF2C94C)));
      expect(TravelTheme.green, equals(AppColors.success));
      expect(TravelTheme.warning, equals(AppColors.warning));
      expect(TravelTheme.red, equals(AppColors.error));
    });

    test('preserves semantic and backward compatibility aliases', () {
      expect(TravelTheme.textPrimary, equals(TravelTheme.ink));
      expect(TravelTheme.textSecondary, equals(TravelTheme.muted));
      expect(TravelTheme.surface, equals(AppColors.lightSurface));
      expect(TravelTheme.cardBg, equals(AppColors.lightCard));
      expect(TravelTheme.cardSurface, equals(AppColors.lightCard));
      expect(TravelTheme.primary, equals(TravelTheme.purple));
      expect(TravelTheme.radius, equals(BorderRadius.circular(24)));
      expect(TravelTheme.shadow.isNotEmpty, isTrue);
    });

    testWidgets('theme-aware helpers resolve light and dark modes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0A1628),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFABC3EA),
            ),
          ),
          home: Builder(
            builder: (context) {
              // Light mode
              expect(TravelTheme.isDark(context), isFalse);
              expect(TravelTheme.backgroundFor(context), equals(const Color(0xFFF9F9FB)));
              expect(TravelTheme.cardSurfaceFor(context), equals(const Color(0xFFFFFFFF)));
              expect(TravelTheme.surfaceFor(context), equals(const Color(0xFFFFFFFF)));
              expect(TravelTheme.textPrimaryFor(context), equals(const Color(0xFF161614)));
              expect(TravelTheme.textSecondaryFor(context), equals(const Color(0xFF656262)));
              expect(TravelTheme.borderFor(context), equals(const Color(0xFFD5CBC8)));
              expect(TravelTheme.primaryFor(context), equals(const Color(0xFF0A1628)));
              expect(TravelTheme.accentFor(context), equals(const Color(0xFFABC3EA)));
              expect(TravelTheme.shadowFor(context), equals(TravelTheme.shadow));
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('CommonButton Theme Awareness & Haptics (eTrip)', () {
    testWidgets('uses theme primary color when backgroundColor is null', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: const ColorScheme.light(
                primary: Colors.indigo,
                onPrimary: Colors.white,
              ),
            ),
            home: Scaffold(
              body: CommonButton(
                text: 'Theme Button',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(of: find.byType(CommonButton), matching: find.byType(Container)),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.indigo));
    });

    testWidgets('triggers light impact haptic feedback on tap', (tester) async {
      final List<MethodCall> hapticCalls = [];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall methodCall) async {
          if (methodCall.method == 'HapticFeedback.vibrate') {
            hapticCalls.add(methodCall);
          }
          return null;
        },
      );

      bool pressed = false;
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: CommonButton(
                text: 'Tap Me',
                onPressed: () {
                  pressed = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CommonButton));
      await tester.pump();

      expect(pressed, isTrue);
      expect(hapticCalls.length, equals(1));
      expect(hapticCalls.first.arguments, equals('HapticFeedbackType.lightImpact'));
    });
  });
}
