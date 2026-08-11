import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ecardo_etrip/src/app/app.dart';
import 'package:ecardo_etrip/src/common/services/settings_service.dart';
import 'package:ecardo_etrip/src/network/service/network_service.dart';
import 'package:ecardo_etrip/src/network/service/token_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeServices();
  _configureUI();
  runApp(const EcardoEtrip());
}

Future<void> _initializeServices() async {
  Get.put(SettingsService());
  Get.put<TokenService>(TokenService());
  Get.put(NetworkService());
}

void _configureUI() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
