import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ecardo_etrip/l10n/app_localizations.dart';
import 'package:ecardo_etrip/src/app/constants/app_colors.dart';
import 'package:ecardo_etrip/src/app/constants/assets_path/png/png_assets.dart';
import 'package:ecardo_etrip/src/app/constants/assets_path/svg/svg_assets.dart';
import 'package:ecardo_etrip/src/app/routes/routes.dart';
import 'package:ecardo_etrip/src/common/services/settings_service.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/controller/home_controller.dart';

class DrawerSection extends StatelessWidget {
  const DrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final HomeController homeController = Get.find<HomeController>();
    final SettingsService settingsService = Get.find();

    final List<Map<String, dynamic>> navigationItemList = [
      {
        "icon": SvgAssets.dashboardDrawerIcon,
        "navigation": localization.drawerDashboard,
        "navigate": "",
      },
      {
        "icon": SvgAssets.myWalletsDrawerIcon,
        "navigation": localization.drawerMyWallets,
        "navigate": BaseRoute.wallets,
      },
      {
        "icon": SvgAssets.addMoneyDrawerIcon,
        "navigation": localization.drawerAddMoney,
        "navigate": BaseRoute.addMoney,
        "setting": "user_deposit",
      },
      {
        "icon": SvgAssets.invitingDrawerIcon,
        "navigation": localization.drawerTravel,
        "navigate": BaseRoute.travel,
        "setting": "always",
      },
      {
        "icon": SvgAssets.transactionDrawerIcon,
        "navigation": localization.drawerTransactions,
        "navigate": BaseRoute.transactions,
        "setting": "always",
      },
      {
        "icon": SvgAssets.invoiceDrawerIcon,
        "navigation": localization.drawerSupport,
        "navigate": BaseRoute.supportTickets,
        "setting": "always",
      },
    ];

    // apply settings-based enablement (keep same logic as before)
    final List<Map<String, dynamic>> enabledItems = [];
    for (var item in navigationItemList) {
      final settingKey = item["setting"] as String?;
      bool isEnabled = true;
      if (settingKey != null && settingKey != "always") {
        isEnabled = settingsService.getSetting(settingKey) == "1";
      }
      item["isEnabled"] = isEnabled;
      enabledItems.add(item);
    }

    return SafeArea(
      bottom: false,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
            ),
            child: Drawer(
              width: 310,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              backgroundColor: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28),
                    child: Image.asset(PngAssets.appLogo, height: 30),
                  ),
                  SizedBox(height: 20),
                  Divider(
                    endIndent: 28,
                    color: AppColors.lightTextPrimary.withValues(alpha: 0.10),
                    height: 0,
                    indent: 28,
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.only(top: 20),
                      itemBuilder: (context, index) {
                        final item = enabledItems[index];
                        final isLastItem = index == enabledItems.length - 1;
                        return _DrawerItem(
                          item: item,
                          index: index,
                          isLastItem: isLastItem,
                          homeController: homeController,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemCount: enabledItems.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
          PositionedDirectional(
            top: 79,
            end: -20,
            child: Material(
              color: AppColors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.10),
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: Offset(-1, 1),
                      ),
                    ],
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Image.asset(
                    PngAssets.closeCommonIcon,
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final int index;
  final bool isLastItem;
  final HomeController homeController;

  const _DrawerItem({
    required this.item,
    required this.index,
    required this.isLastItem,
    required this.homeController,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = item["isEnabled"] as bool? ?? true;
    final navigate = item["navigate"] as String? ?? "";
    final isDashboard = navigate.isEmpty;

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 28),
      child: Column(
        children: [
          InkWell(
            onTap: isEnabled
                ? () {
                    if (isDashboard) {
                      homeController.selectedIndex.value = 0;
                      Get.back();
                    } else {
                      Get.back();
                      Get.toNamed(navigate);
                    }
                  }
                : null,
            borderRadius: BorderRadius.circular(10),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    item["icon"] as String,
                    color: isEnabled
                        ? AppColors.lightPrimaryDark
                        : AppColors.lightTextPrimary,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    item["navigation"] as String,
                    style: TextStyle(
                      fontSize: 13,
                      color: isEnabled
                          ? AppColors.lightPrimaryDark
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 13,
                  color: AppColors.lightTextPrimary,
                ),
              ],
            ),
          ),
          if (!isLastItem)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                height: 0,
                color: AppColors.lightTextPrimary.withValues(alpha: 0.10),
              ),
            ),
        ],
      ),
    );
  }
}
