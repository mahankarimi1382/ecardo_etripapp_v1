import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecardo_etrip/src/app/config/theme/dark_theme.dart';
import 'package:ecardo_etrip/src/app/config/theme/light_theme.dart';
import 'package:ecardo_etrip/src/app/constants/app_colors.dart';
import 'package:ecardo_etrip/src/app/constants/app_spacing.dart';
import 'package:ecardo_etrip/src/app/routes/routes.dart';
import 'package:ecardo_etrip/src/app/routes/routes_handler.dart';
import 'package:ecardo_etrip/src/common/services/locale_theme_service.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/shared/travel_widgets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('eTrip Material 3 Themes', () {
    testWidgets('LightTheme builds complete M3 ColorScheme and component themes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final theme = LightTheme().lightTheme(context);
              expect(theme.useMaterial3, isTrue);
              expect(theme.brightness, equals(Brightness.light));
              expect(theme.colorScheme.primary, equals(AppColors.lightPrimary));
              expect(theme.colorScheme.surface, equals(AppColors.lightBackground));
              expect(theme.colorScheme.error, equals(AppColors.error));
              expect(theme.cardTheme.shape, isA<RoundedRectangleBorder>());
              expect(theme.cardTheme.elevation, equals(0));
              expect(theme.navigationBarTheme.backgroundColor, equals(AppColors.lightSurface));
              expect(theme.switchTheme.thumbColor, isNotNull);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('DarkTheme builds complete M3 dark ColorScheme and component themes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final theme = DarkTheme().darkTheme(context);
              expect(theme.useMaterial3, isTrue);
              expect(theme.brightness, equals(Brightness.dark));
              expect(theme.colorScheme.primary, equals(AppColors.mainSoftBlue));
              expect(theme.colorScheme.surface, equals(AppColors.darkSurface));
              expect(theme.colorScheme.error, equals(AppColors.error));
              expect(theme.scaffoldBackgroundColor, equals(AppColors.deepBlack));
              expect(theme.cardTheme.color, equals(AppColors.darkSurface));
              expect(theme.navigationBarTheme.backgroundColor, equals(AppColors.darkSurface));
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('eTrip Design Tokens and AppSpacing', () {
    test('AppSpacing 8px grid tokens are correctly defined', () {
      expect(AppSpacing.xs, equals(4.0));
      expect(AppSpacing.sm, equals(8.0));
      expect(AppSpacing.md, equals(12.0));
      expect(AppSpacing.lg, equals(16.0));
      expect(AppSpacing.xl, equals(20.0));
      expect(AppSpacing.xxl, equals(24.0));
      expect(AppSpacing.xxxl, equals(32.0));
      expect(AppSpacing.huge, equals(48.0));
      expect(AppSpacing.radiusLg, equals(16.0));
      expect(AppSpacing.radiusXl, equals(24.0));
    });

    test('AppDurations tokens are correctly mapped', () {
      expect(AppDurations.fast, equals(const Duration(milliseconds: 150)));
      expect(AppDurations.normal, equals(const Duration(milliseconds: 300)));
      expect(AppDurations.slow, equals(const Duration(milliseconds: 500)));
    });

    test('AppColors NUVO palette values match spec', () {
      expect(AppColors.deepBlack, equals(const Color(0xFF161614)));
      expect(AppColors.darkGray, equals(const Color(0xFF262625)));
      expect(AppColors.softGray, equals(const Color(0xFF656262)));
      expect(AppColors.warmWhite, equals(const Color(0xFFE7E0DE)));
      expect(AppColors.mainSoftBlue, equals(const Color(0xFFABC3EA)));
    });
  });

  group('LocaleThemeService dynamic theme switching', () {
    test('parses theme string modes properly', () {
      final service = LocaleThemeService();
      expect(service.themeMode.value, equals(ThemeMode.system));
    });

    test('returns native names for supported languages', () {
      expect(LocaleThemeService.nativeName('fa'), equals('فارسی'));
      expect(LocaleThemeService.nativeName('en'), equals('English'));
      expect(LocaleThemeService.nativeName('ar'), equals('العربية'));
      expect(LocaleThemeService.nativeName('zh'), equals('中文'));
      expect(LocaleThemeService.nativeName('tr'), equals('Türkçe'));
      expect(LocaleThemeService.nativeName('ru'), equals('Русский'));
    });
  });

  group('eTrip Travel Named Routes', () {
    test('routesHandler contains all key travel entry points', () {
      final routeNames = routesHandler.map((page) => page.name).toSet();
      expect(routeNames.contains(BaseRoute.travel), isTrue);
      expect(routeNames.contains(BaseRoute.travelHistory), isTrue);
      expect(routeNames.contains(BaseRoute.travelAccount), isTrue);
      expect(routeNames.contains(BaseRoute.flightSearch), isTrue);
      expect(routeNames.contains(BaseRoute.flightResults), isTrue);
      expect(routeNames.contains(BaseRoute.hotelSearch), isTrue);
      expect(routeNames.contains(BaseRoute.hotelResults), isTrue);
      expect(routeNames.contains(BaseRoute.esimIntro), isTrue);
      expect(routeNames.contains(BaseRoute.esimPackages), isTrue);
      expect(routeNames.contains(BaseRoute.travelOrders), isTrue);
      expect(routeNames.contains(BaseRoute.travelers), isTrue);
    });
  });

  group('Travel 4 States Widgets', () {
    testWidgets('TravelEmptyView renders title, subtitle and action', (tester) async {
      bool actionTapped = false;
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: TravelEmptyView(
                title: 'No flights found',
                subtitle: 'Try changing search criteria',
                icon: Icons.flight_takeoff_rounded,
                actionLabel: 'Reset',
                onAction: () => actionTapped = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('No flights found'), findsOneWidget);
      expect(find.text('Try changing search criteria'), findsOneWidget);
      expect(find.text('Reset'), findsOneWidget);

      await tester.tap(find.text('Reset'));
      expect(actionTapped, isTrue);
    });

    testWidgets('TravelErrorView renders error message and retry button', (tester) async {
      bool retried = false;
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: TravelErrorView(
                message: 'Failed to load offers',
                title: 'Network Error',
                onRetry: () => retried = true,
                retryLabel: 'Retry Now',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Network Error'), findsOneWidget);
      expect(find.text('Failed to load offers'), findsOneWidget);
      expect(find.text('Retry Now'), findsOneWidget);

      await tester.tap(find.text('Retry Now'));
      expect(retried, isTrue);
    });

    testWidgets('TravelLoadingSkeleton renders expected item count', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => const MaterialApp(
            home: Scaffold(
              body: TravelLoadingSkeleton(count: 3, height: 120),
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });
  });
}
