import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ecardo_etrip/l10n/app_localizations.dart';
import 'package:ecardo_etrip/src/app/constants/app_colors.dart';
import 'package:ecardo_etrip/src/app/constants/app_spacing.dart';
import 'package:ecardo_etrip/src/app/constants/assets_path/png/png_assets.dart';
import 'package:ecardo_etrip/src/app/routes/routes.dart';
import 'package:ecardo_etrip/src/common/services/app_update_helper.dart';
import 'package:ecardo_etrip/src/common/services/locale_theme_service.dart';
import 'package:ecardo_etrip/src/common/services/settings_service.dart';
import 'package:ecardo_etrip/src/common/widgets/app_bar/common_app_bar.dart';
import 'package:ecardo_etrip/src/common/widgets/app_bar/common_default_app_bar.dart';
import 'package:ecardo_etrip/src/common/widgets/common_loading.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/controller/home_controller.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/shared/travel_theme.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/shared/travel_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final HomeController homeController = Get.find();
  String _themePref = 'system';

  @override
  void initState() {
    super.initState();
    if (!homeController.isSettingsInitialized.value) {
      homeController.loadUser();
      homeController.isSettingsInitialized.value = true;
    }
    _loadThemePref();
  }

  Future<void> _loadThemePref() async {
    if (Get.isRegistered<LocaleThemeService>()) {
      final mode = Get.find<LocaleThemeService>().themeMode.value;
      setState(() {
        _themePref = switch (mode) {
          ThemeMode.dark => 'dark',
          ThemeMode.light => 'light',
          ThemeMode.system => 'system',
        };
      });
    } else if (Get.isRegistered<SettingsService>()) {
      final pref = await Get.find<SettingsService>().getThemeModePref();
      if (mounted) setState(() => _themePref = pref);
    }
  }

  void _applyTheme(String mode) {
    HapticFeedback.lightImpact();
    setState(() => _themePref = mode);
    if (Get.isRegistered<LocaleThemeService>()) {
      Get.find<LocaleThemeService>().setThemeModePref(mode);
    } else if (Get.isRegistered<SettingsService>()) {
      Get.find<SettingsService>().setThemeModePref(mode);
      Get.changeThemeMode(switch (mode) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      });
    }
  }

  String _themeTitle(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return switch (lang) {
      'fa' => 'تم و ظاهر',
      'ar' => 'المظهر والسمة',
      'ru' => 'Тема оформления',
      'zh' => '外观主题',
      'tr' => 'Görünüm Teması',
      _ => 'Theme & Appearance',
    };
  }

  String _themeLabel(String mode, BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return switch (mode) {
      'dark' => switch (lang) {
        'fa' => 'تیره',
        'ar' => 'داكن',
        'ru' => 'Тёмная',
        'zh' => '深色',
        'tr' => 'Koyu',
        _ => 'Dark',
      },
      'light' => switch (lang) {
        'fa' => 'روشن',
        'ar' => 'فاتح',
        'ru' => 'Светлая',
        'zh' => '浅色',
        'tr' => 'Açık',
        _ => 'Light',
      },
      _ => switch (lang) {
        'fa' => 'سیستم',
        'ar' => 'النظام',
        'ru' => 'Системная',
        'zh' => '跟随系统',
        'tr' => 'Sistem',
        _ => 'System',
      },
    };
  }

  Future<void> _showThemeBottomSheet(BuildContext context) async {
    final isDark = TravelTheme.isDark(context);
    final cardBg = TravelTheme.cardSurfaceFor(context);
    final primaryText = TravelTheme.textPrimaryFor(context);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusXl),
            ),
            border: Border.all(color: TravelTheme.borderFor(context)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.xl,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: TravelTheme.borderFor(context),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                  ),
                ),
                Text(
                  _themeTitle(context),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _themeOptionTile(
                  context: context,
                  title: _themeLabel('system', context),
                  subtitle: isDark ? 'System Default' : 'System Default',
                  icon: Icons.brightness_auto_rounded,
                  mode: 'system',
                  selected: _themePref == 'system',
                ),
                const SizedBox(height: AppSpacing.sm),
                _themeOptionTile(
                  context: context,
                  title: _themeLabel('light', context),
                  subtitle: 'Clean & Bright',
                  icon: Icons.light_mode_rounded,
                  mode: 'light',
                  selected: _themePref == 'light',
                ),
                const SizedBox(height: AppSpacing.sm),
                _themeOptionTile(
                  context: context,
                  title: _themeLabel('dark', context),
                  subtitle: 'Easy on the eyes',
                  icon: Icons.dark_mode_rounded,
                  mode: 'dark',
                  selected: _themePref == 'dark',
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _themeOptionTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String mode,
    required bool selected,
  }) {
    final primaryColor = TravelTheme.primaryFor(context);
    final isDark = TravelTheme.isDark(context);

    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      onTap: () {
        _applyTheme(mode);
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: selected
              ? primaryColor.withValues(alpha: isDark ? 0.18 : 0.10)
              : TravelTheme.surfaceFor(context),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: selected ? primaryColor : TravelTheme.borderFor(context),
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: selected
                  ? primaryColor.withValues(alpha: 0.2)
                  : TravelTheme.borderFor(context),
              child: Icon(
                icon,
                size: 20,
                color: selected ? primaryColor : TravelTheme.textSecondaryFor(context),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 15,
                      color: TravelTheme.textPrimaryFor(context),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: TravelTheme.textSecondaryFor(context),
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle_rounded,
                color: primaryColor,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final List<Map<String, dynamic>> settingsList = [
      {
        "icon": PngAssets.profileSettingsEndDrawerIcon,
        "title": localization.settingsProfileSettings,
        "is_status": false,
        "navigate": BaseRoute.profileSettings,
      },
      {
        "icon_data": Icons.palette_outlined,
        "title": _themeTitle(context),
        "is_status": true,
        "status_text": _themeLabel(_themePref, context),
        "status_color": TravelTheme.blue,
        "navigate": "theme",
      },
      {
        "icon": PngAssets.changePasswordEndDrawerIcon,
        "title": localization.settingsChangePassword,
        "is_status": false,
        "navigate": BaseRoute.changePassword,
      },
      {
        "icon": PngAssets.biometricCommonIcon,
        "title": localization.endDrawerBiometric,
        "is_status": false,
        "is_switch": true,
        "navigate": "biometric",
      },
      {
        "icon": PngAssets.allNotificationEndDrawerIcon,
        "title": localization.settingsAllNotification,
        "is_status": false,
        "navigate": BaseRoute.notifications,
      },
      {
        "icon": PngAssets.signOutEndDrawerIcon,
        "title": localization.settingsSignOut,
        "is_status": false,
        "navigate": "",
      },
    ];

    if (Get.find<SettingsService>().getSetting("fa_verification") == "1") {
      settingsList.insert(3, {
        "icon": PngAssets.twoFaAuthenticationEndDrawerIcon,
        "title": localization.settingsTwoFactorAuthentication,
        "is_status": false,
        "navigate": BaseRoute.twoFactorAuthentication,
      });
    }
    if (Get.find<SettingsService>().getSetting("kyc_verification") == "1") {
      final userKyc = homeController.userModel.value.data?.kyc ?? 0;
      String kycStatusText;
      Color kycStatusColor;
      switch (userKyc) {
        case 1:
          kycStatusText = localization.kycStatusVerified;
          kycStatusColor = AppColors.success;
          break;
        case 2:
          kycStatusText = localization.kycStatusPending;
          kycStatusColor = AppColors.warning;
          break;
        case 3:
          kycStatusText = localization.kycStatusRejected;
          kycStatusColor = AppColors.error;
          break;
        default:
          kycStatusText = localization.kycStatusNotSubmitted;
          kycStatusColor = AppColors.warning;
      }
      settingsList.insert(4, {
        "icon": PngAssets.idVerificationEndDrawerIcon,
        "title": localization.settingsIdVerification,
        "is_status": true,
        "status_text": kycStatusText,
        "status_color": kycStatusColor,
        "navigate": BaseRoute.kycHistory,
      });
    }
    if (Get.find<SettingsService>().getSetting("user_ticket") == "1") {
      settingsList.insert(5, {
        "icon": PngAssets.supportEndDrawerIcon,
        "title": localization.settingsSupport,
        "is_status": false,
        "navigate": BaseRoute.supportTickets,
      });
    }
    settingsList.add({
      "icon": PngAssets.arrowRightCommonIcon,
      "title": localization.settingsCheckForUpdates,
      "is_status": false,
      "navigate": "update",
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) async {
        if (!Navigator.canPop(context)) {
          Get.offNamed(BaseRoute.travel);
        }
      },
      child: Scaffold(
        backgroundColor: TravelTheme.backgroundFor(context),
        appBar: const CommonDefaultAppBar(),
        bottomNavigationBar: const TravelBottomNavigation(
          activeSection: TravelNavigationSection.settings,
        ),
        body: Stack(
          children: [
            RefreshIndicator(
              color: TravelTheme.blue,
              onRefresh: () => homeController.loadUser(),
              child: Obx(
                () => homeController.isUserLoading.value
                    ? const CommonLoading()
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: AppSpacing.lg),
                            CommonAppBar(
                              title: localization.settingsScreenTitle,
                              backLogicFunction: () =>
                                  Get.offNamed(BaseRoute.travel),
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                            Container(
                              margin: const EdgeInsetsDirectional.symmetric(
                                horizontal: AppSpacing.lg,
                              ),
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              decoration: BoxDecoration(
                                color: TravelTheme.cardSurfaceFor(context),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                                border: Border.all(
                                  color: TravelTheme.borderFor(context),
                                ),
                                boxShadow: TravelTheme.shadowFor(context),
                              ),
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final item = settingsList[index];

                                  return InkWell(
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                    onTap: () async {
                                      HapticFeedback.lightImpact();
                                      if (item["navigate"] == "theme") {
                                        await _showThemeBottomSheet(context);
                                        return;
                                      }
                                      if (item["navigate"] == "biometric") {
                                        await homeController.toggleBiometric();
                                        return;
                                      }
                                      if (item["title"] ==
                                          localization.settingsSignOut) {
                                        await homeController.submitLogout();
                                      } else {
                                        if (item["navigate"] == "update") {
                                          AppUpdateHelper.checkForUpdate(
                                            context,
                                            showMessageIfNoUpdate: true,
                                          );
                                        } else {
                                          Get.toNamed(item["navigate"]);
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                            horizontal: AppSpacing.lg,
                                            vertical: AppSpacing.md,
                                          ),
                                      decoration: BoxDecoration(
                                        color: TravelTheme.surfaceFor(context),
                                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                        border: Border.all(
                                          color: TravelTheme.borderFor(context),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                if (item["icon_data"] != null)
                                                  Icon(
                                                    item["icon_data"] as IconData,
                                                    size: AppSpacing.iconMd,
                                                    color: TravelTheme.blue,
                                                  )
                                                else
                                                  Image.asset(
                                                    item["icon"],
                                                    width: AppSpacing.iconMd,
                                                    color: item["title"] ==
                                                            localization
                                                                .settingsSignOut
                                                        ? AppColors.error
                                                        : (TravelTheme.isDark(context)
                                                            ? AppColors.warmWhite
                                                            : null),
                                                  ),
                                                const SizedBox(width: AppSpacing.sm),
                                                Expanded(
                                                  child: Text(
                                                    item["title"],
                                                    style: TextStyle(
                                                      letterSpacing: 0,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 15,
                                                      color: item["title"] ==
                                                              localization
                                                                  .settingsSignOut
                                                          ? AppColors.error
                                                          : TravelTheme
                                                                .textPrimaryFor(
                                                              context,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              if (item["is_status"] == true)
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      AppSpacing.radiusFull,
                                                    ),
                                                    color: item["status_color"] ??
                                                        AppColors.success,
                                                  ),
                                                  alignment: Alignment.center,
                                                  padding:
                                                      const EdgeInsetsDirectional.symmetric(
                                                    horizontal: AppSpacing.sm,
                                                    vertical: AppSpacing.xs,
                                                  ),
                                                  child: Text(
                                                    item["status_text"] ?? '',
                                                    style: const TextStyle(
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 12,
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                ),
                                              if (item["is_status"] == true)
                                                const SizedBox(width: AppSpacing.sm),
                                              if (item["is_switch"] == true)
                                                Obx(
                                                  () => Switch.adaptive(
                                                    value: homeController
                                                        .isBiometricEnable
                                                        .value,
                                                    activeThumbColor:
                                                        TravelTheme.primaryFor(context),
                                                    onChanged: (_) async =>
                                                        homeController
                                                            .toggleBiometric(),
                                                  ),
                                                )
                                              else
                                                Image.asset(
                                                  PngAssets
                                                      .arrowRightCommonIcon,
                                                  width: AppSpacing.iconSm,
                                                  color: item["title"] ==
                                                          localization
                                                              .settingsSignOut
                                                      ? AppColors.error
                                                      : TravelTheme
                                                            .textSecondaryFor(
                                                          context,
                                                        ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: AppSpacing.sm);
                                },
                                itemCount: settingsList.length,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.huge),
                          ],
                        ),
                      ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: homeController.isSignOutLoading.value,
                child: const CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
