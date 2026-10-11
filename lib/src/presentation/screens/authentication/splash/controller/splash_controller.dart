import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecardo_etrip/src/app/routes/routes.dart';
import 'package:ecardo_etrip/src/common/services/settings_service.dart';
import 'package:ecardo_etrip/src/network/service/token_service.dart';

class SplashController extends GetxController {
  Future<void> navigateBasedOnAuth() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) ||
        connectivityResult.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.currentRoute != BaseRoute.noInternetConnection) {
          Get.offAllNamed(BaseRoute.noInternetConnection);
        }
      });
      return;
    }

    final loginState = await SettingsService.getLoginCurrentState();
    final tokenService = Get.find<TokenService>();
    await tokenService.loadAccessToken();
    final token = tokenService.accessToken.value;
    final hasToken = token != null && token.isNotEmpty;

    if (loginState != null && loginState.isNotEmpty && hasToken) {
      Get.offAllNamed(BaseRoute.navigation);
    } else {
      Get.offNamed(BaseRoute.welcome);
    }
  }
}
