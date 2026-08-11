import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ecardo_etrip/l10n/app_localizations.dart';
import 'package:ecardo_etrip/src/common/model/register_fields_model.dart';
import 'package:ecardo_etrip/src/helper/toast_helper.dart';
import 'package:ecardo_etrip/src/network/api/api_path.dart';
import 'package:ecardo_etrip/src/network/response/status.dart';
import 'package:ecardo_etrip/src/network/service/network_service.dart';

class RegisterFieldsController extends GetxController {
  final localization = AppLocalizations.of(Get.context!);
  final RxBool isLoading = false.obs;
  final RxMap<String, String> registerFields = <String, String>{}.obs;

  Future<void> loadRegisterFields() async {
    isLoading.value = true;
    await fetchRegisterFields();
    isLoading.value = false;
  }

  Future<void> fetchRegisterFields() async {
    try {
      final response = await Get.find<NetworkService>().globalGet(
        endpoint: ApiPath.getRegisterFieldsEndpoint,
      );
      if (response.status == Status.completed) {
        final RegisterFieldsModel jsonResponse = RegisterFieldsModel.fromJson(
          response.data!,
        );
        registerFields.clear();
        for (var field in jsonResponse.data!) {
          registerFields[field.key!] = field.value!;
        }
      }
    } catch (e, stackTrace) {
      debugPrint('❌ fetchRegisterFields() error: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      ToastHelper().showErrorToast(localization!.allControllerLoadError);
    } finally {}
  }
}
