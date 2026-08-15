import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/controller/home_controller.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/view/sub_sections/drawer/drawer_section.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/view/sub_sections/drawer/end_drawer_section.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/home/travel_home_screen.dart';

/// NavigationScreen — پوستهٔ اصلی etrip
///
/// etrip همان eCardo Travel با نام نهایی etrip است. ناوبری اصلی اپ فقط
/// از TravelBottomNavigation مشترک در همهٔ صفحات انجام می‌شود؛ بنابراین
/// منوی دوگزینه‌ای قدیمی (etrip/settings) از صفحهٔ اول حذف شده است.
class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    homeController.setScaffoldKey(_scaffoldKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: DrawerSection(),
      endDrawer: EndDrawerSection(),
      body: const TravelHomeScreen(),
    );
  }
}
