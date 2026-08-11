import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecardo_etrip/l10n/app_localizations.dart';
import 'package:ecardo_etrip/src/app/constants/app_colors.dart';
import 'package:ecardo_etrip/src/app/constants/assets_path/png/png_assets.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/controller/home_controller.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/view/home_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/view/sub_sections/drawer/drawer_section.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/view/sub_sections/drawer/end_drawer_section.dart';
import 'package:ecardo_etrip/src/presentation/screens/settings/view/settings_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/home/travel_home_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HomeController homeController = Get.find<HomeController>();
  final String signUpBonus = Get.arguments?["bonus"] ?? "";

  final iconList = [
    PngAssets.bottomNavigationHomeSolidIcon,
    PngAssets.bottomNavigationTransferSolidIcon,
    PngAssets.bottomNavigationSettingsSolidIcon,
  ];

  @override
  void initState() {
    super.initState();
    homeController.setScaffoldKey(_scaffoldKey);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final localization = AppLocalizations.of(context)!;

      final labelList = [
        localization.bottomNavHome,
        localization.travelTitle,
        localization.bottomNavSettings,
      ];

      final pages = [
        HomeScreen(signUpBonus: signUpBonus),
        TravelHomeScreen(),
        SettingsScreen(),
      ];

      return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        drawer: DrawerSection(),
        endDrawer: EndDrawerSection(),
        body: pages[homeController.selectedIndex.value],
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          height: 80,
          backgroundColor: AppColors.white,
          itemCount: iconList.length,
          activeIndex: homeController.selectedIndex.value,
          notchSmoothness: NotchSmoothness.softEdge,
          gapLocation: GapLocation.none,
          tabBuilder: (int index, bool isActive) {
            final color = isActive
                ? AppColors.lightPrimary
                : AppColors.lightTextPrimary.withValues(alpha: 0.30);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconList[index],
                  color: color,
                  width: index == 0 ? 25 : index == 1 ? 26 : 24,
                ),
                const SizedBox(height: 2),
                Text(
                  labelList[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ],
            );
          },
          onTap: (index) => homeController.selectedIndex.value = index,
        ),
      );
    });
  }
}
