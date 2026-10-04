import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ecardo_etrip/l10n/app_localizations.dart';
import 'package:ecardo_etrip/src/app/constants/app_spacing.dart';
import 'package:ecardo_etrip/src/common/services/settings_service.dart';
import 'package:ecardo_etrip/src/common/widgets/bottom_sheet/common_alert_bottom_sheet.dart';
import 'package:ecardo_etrip/src/common/widgets/common_loading.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/controller/home_controller.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/view/sub_sections/home_skeleton_loader.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/view/sub_sections/my_wallet_section.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/view/sub_sections/other_services_section.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/view/sub_sections/recent_transactions_section.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/view/sub_sections/sign_up_bonus_pop_up.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/view/sub_sections/top_header_section.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/shared/travel_theme.dart';

class HomeScreen extends StatefulWidget {
  final String? signUpBonus;

  const HomeScreen({super.key, this.signUpBonus});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.signUpBonus?.isNotEmpty ?? false) {
        if (Get.find<SettingsService>().getSetting("referral_signup_bonus") ==
            "1") {
          await loadBonusPopUp();
        }
      }
    });
  }

  Future<void> loadBonusPopUp() async {
    final email = await SettingsService.getLoggedInUserEmail();
    if (email == null) return;

    final bool isBonusShown =
        await SettingsService.getBonusPopUpShow(email) ?? false;

    if (!isBonusShown) {
      Future.delayed(const Duration(seconds: 5), () async {
        showGiftDialog(signUpBonus: widget.signUpBonus.toString());
        await Get.find<SettingsService>().saveBonusPopUpShow(email, true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) {
        showExitApplicationAlertDialog();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
        child: Scaffold(
          backgroundColor: TravelTheme.backgroundFor(context),
          body: Stack(
            children: [
              Obx(
                () => homeController.isLoading.value
                    ? const HomeSkeletonLoader()
                    : RefreshIndicator(
                        color: TravelTheme.blue,
                        onRefresh: () => homeController.loadData(),
                        child: SingleChildScrollView(
                          child: Column(
                            children: const [
                              TopHeaderSection(),
                              SizedBox(height: AppSpacing.xxl),
                              MyWalletSection(),
                              SizedBox(height: AppSpacing.xxl),
                              OtherServicesSection(),
                              SizedBox(height: AppSpacing.xxl),
                              RecentTransactionsSection(),
                              SizedBox(height: AppSpacing.huge),
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
      ),
    );
  }

  void showExitApplicationAlertDialog() {
    final localization = AppLocalizations.of(context)!;
    Get.bottomSheet(
      CommonAlertBottomSheet(
        title: localization.exitApplicationTitle,
        message: localization.exitApplicationMessage,
        onConfirm: () => exit(0),
        onCancel: () => Get.back(),
      ),
    );
  }

  void showGiftDialog({required String signUpBonus}) {
    Get.dialog(SignUpBonusPopUp(signUpBonus: signUpBonus));
  }
}
