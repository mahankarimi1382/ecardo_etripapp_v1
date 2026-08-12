import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecardo_etrip/l10n/app_localizations.dart';
import 'package:ecardo_etrip/src/app/routes/routes.dart';
import 'package:ecardo_etrip/src/common/model/user_model.dart';
import 'package:ecardo_etrip/src/common/services/settings_service.dart';
import 'package:ecardo_etrip/src/helper/toast_helper.dart';
import 'package:ecardo_etrip/src/network/api/api_path.dart';
import 'package:ecardo_etrip/src/network/response/status.dart';
import 'package:ecardo_etrip/src/network/service/network_service.dart';
import 'package:ecardo_etrip/src/network/service/token_service.dart';

class SignInController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isBiometricEnable = false.obs;
  final RxBool isPressed = false.obs;
  final Rx<UserModel> userModel = UserModel().obs;
  final SettingsService settingsService = Get.find<SettingsService>();
  late final Future<void> _initialization;

  // Email
  final RxBool isEmailFocused = false.obs;
  final FocusNode emailFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();

  // Password
  final RxBool isPasswordFocused = false.obs;
  final RxBool isPasswordVisible = true.obs;
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();

  // Biometric
  final RxString biometricEmail = "".obs;
  final RxString biometricPassword = "".obs;

  @override
  void onInit() {
    super.onInit();
    _initialization = _initialize();

    emailFocusNode.addListener(_handleEmailFocusChange);
    passwordFocusNode.addListener(_handlePasswordFocusChange);
  }

  Future<void> _initialize() async {
    await clearSignUpStatus();
    await Future.wait<void>([
      loadSavedEmail(),
      loadBiometricStatus(),
    ]);
  }

  @override
  void onClose() {
    emailFocusNode.removeListener(_handleEmailFocusChange);
    passwordFocusNode.removeListener(_handlePasswordFocusChange);
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  Future<void> clearSignUpStatus() async {
    await Get.find<SettingsService>().saveEmailVerified(false);
    await Get.find<SettingsService>().saveSetUpPassword(false);
    await Get.find<TokenService>().clearToken();
  }

  Future<void> setLogInState() async {
    await settingsService.saveLoginCurrentState("logged_in");
  }

  Future<void> loadBiometricStatus() async {
    final saved = await SettingsService.getBiometricEnableOrDisable();
    isBiometricEnable.value = saved ?? false;
  }

  Future<void> loadSavedEmail() async {
    final savedEmail = await SettingsService.getLoggedInUserEmail();
    if (savedEmail != null && savedEmail.isNotEmpty) {
      emailController.text = savedEmail;
    }
  }

  void _handleEmailFocusChange() {
    isEmailFocused.value = emailFocusNode.hasFocus;
  }

  void _handlePasswordFocusChange() {
    isPasswordFocused.value = passwordFocusNode.hasFocus;
  }

  Future<void> submitSignIn({bool useBiometric = false}) async {
    isLoading.value = true;

    try {
      // Sign-in screen initialization clears the previous token. Waiting here
      // prevents that asynchronous cleanup from racing with a new login and
      // deleting the freshly saved token before fetchUser() runs.
      await _initialization;

      final String email = useBiometric
          ? biometricEmail.value.trim()
          : emailController.text.trim();

      final String password = useBiometric
          ? biometricPassword.value.trim()
          : passwordController.text.trim();

      final response = await Get.find<NetworkService>().login(
        email: email,
        password: password,
      );

      if (response.status == Status.completed) {
        await postFcmNotification(
          email: email,
          password: password,
          useBiometric: useBiometric,
        );
      }
    } catch (e, s) {
      debugPrint('❌ submitSignIn() error: $e');
      debugPrint('📍 StackTrace: $s');
      ToastHelper().showErrorToast(
        AppLocalizations.of(Get.context!)!.allControllerLoadError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUser({bool useBiometric = false}) async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.userEndpoint,
      );

      if (response.status == Status.completed) {
        userModel.value = UserModel.fromJson(response.data!);
        await setLogInState();

        if (userModel.value.data!.twoFa == true &&
            Get.find<SettingsService>().getSetting("fa_verification") == "1") {
          Get.toNamed(BaseRoute.twoFactorAuth);
        } else {
          await Get.find<SettingsService>().saveLoggedInUserEmail(
            useBiometric ? biometricEmail.value : emailController.text,
          );
          await Get.find<SettingsService>().saveLoggedInUserPassword(
            useBiometric ? biometricPassword.value : passwordController.text,
          );

          if (userModel.value.data!.boardingSteps?.completed == true) {
            Get.offAllNamed(BaseRoute.navigation);
            resetFields();
          } else {
            Get.toNamed(
              BaseRoute.signUpStatus,
              arguments: {"is_login_state": true},
            );
          }
        }
      }
    } catch (e, s) {
      debugPrint('❌ fetchUser() error: $e');
      debugPrint('📍 StackTrace: $s');
      ToastHelper().showErrorToast(
        AppLocalizations.of(Get.context!)!.allControllerLoadError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> postFcmNotification({
    required String email,
    required String password,
    required bool useBiometric,
  }) async {
    try {
      // Firebase/device APIs are not part of the Web build. More importantly,
      // attempting Platform.isAndroid/isIOS on Web can throw before the user
      // profile request is reached. Native behavior remains unchanged.
      if (!kIsWeb) {
        final deviceInfoPlugin = DeviceInfoPlugin();
        final savedFcmToken = await SettingsService.getFcmToken();

        String deviceId = '';
        String deviceType = '';

        if (Platform.isAndroid) {
          final androidInfo = await deviceInfoPlugin.androidInfo;
          deviceId = androidInfo.id;
          deviceType = 'android';
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfoPlugin.iosInfo;
          deviceId = iosInfo.identifierForVendor ?? '';
          deviceType = 'ios';
        } else {
          deviceId = 'unknown';
          deviceType = 'unknown';
        }

        await Get.find<NetworkService>().post(
          endpoint: ApiPath.getSetupFcm,
          data: {
            'device_id': deviceId,
            'device_type': deviceType,
            'fcm_token': savedFcmToken,
          },
        );
      }
    } catch (e, s) {
      debugPrint('❌ postFcmNotification() error: $e');
      debugPrint('📍 StackTrace: $s');
    } finally {
      await fetchUser(useBiometric: useBiometric);
    }
  }

  void resetFields() {
    emailController.clear();
    passwordController.clear();
    isEmailFocused.value = false;
    isPasswordFocused.value = false;
  }
}
