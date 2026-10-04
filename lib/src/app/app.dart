import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ecardo_etrip/l10n/app_localizations.dart';
import 'package:ecardo_etrip/src/app/config/theme/light_theme.dart';
import 'package:ecardo_etrip/src/app/config/theme/dark_theme.dart';
import 'package:ecardo_etrip/src/app/constants/app_strings.dart';
import 'package:ecardo_etrip/src/app/bindings/app_bindings.dart';
import 'package:ecardo_etrip/src/app/routes/routes.dart';
import 'package:ecardo_etrip/src/app/routes/routes_config.dart';
import 'package:ecardo_etrip/src/app/routes/routes_handler.dart';
import 'package:ecardo_etrip/src/common/services/locale_theme_service.dart';
import 'package:ecardo_etrip/src/common/services/settings_service.dart';

class EcardoEtrip extends StatefulWidget {
  const EcardoEtrip({super.key});

  @override
  State<EcardoEtrip> createState() => _EcardoEtripState();
}

class _EcardoEtripState extends State<EcardoEtrip> {
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  // Load saved language from SettingsService
  Future<void> _loadSavedLanguage() async {
    final savedLocale = await SettingsService.getLanguageLocaleCurrentState();

    if (savedLocale != null && mounted) {
      setState(() {
        _locale = Locale(savedLocale);
      });
      Get.updateLocale(Locale(savedLocale));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(376, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(() {
          final lts = Get.isRegistered<LocaleThemeService>()
              ? Get.find<LocaleThemeService>()
              : null;
          final appLocale = lts?.locale.value ?? _locale;
          final appTheme = lts?.themeMode.value ?? ThemeMode.system;

          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appName,
            themeMode: appTheme,
            theme: LightTheme().lightTheme(context),
            darkTheme: DarkTheme().darkTheme(context),
            getPages: routesHandler,
            initialRoute: BaseRoute.root,
            unknownRoute: GetPage(
              name: '/not-found',
              page: () => RoutesConfig.splash,
              binding: SplashBinding(),
            ),
            locale: appLocale,
            fallbackLocale: const Locale('en'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale("ar"),
              Locale('fa'),
              Locale('zh'),
              Locale('ru'),
            ],
            builder: (context, widget) {
              Widget body = widget ?? const SizedBox.shrink();
              final mediaQuery = MediaQuery.of(context);
              final clampedTextScaler = mediaQuery.textScaler.clamp(
                minScaleFactor: 0.85,
                maxScaleFactor: 1.3,
              );
              return MediaQuery(
                data: mediaQuery.copyWith(textScaler: clampedTextScaler),
                child: body,
              );
            },
          );
        });
      },
    );
  }
}
