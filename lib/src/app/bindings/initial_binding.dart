import 'package:get/get.dart';
import 'package:ecardo_etrip/src/common/services/locale_theme_service.dart';
import 'package:ecardo_etrip/src/common/services/settings_service.dart';
import 'package:ecardo_etrip/src/network/service/network_service.dart';
import 'package:ecardo_etrip/src/network/service/token_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TokenService>(TokenService());
    Get.put<SettingsService>(SettingsService());
    Get.put<NetworkService>(NetworkService());
    if (!Get.isRegistered<LocaleThemeService>()) {
      Get.putAsync(() => LocaleThemeService().init());
    }
  }
}
