import 'package:flutter/material.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/home/travel_home_screen.dart';

/// NavigationScreen — shell for etrip.
///
/// Navigation in etrip is handled through TravelBottomNavigation
/// shared across travel screens. Legacy Drawer sections have been cleaned up.
class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: TravelHomeScreen(),
    );
  }
}
