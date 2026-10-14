import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ecardo_etrip/src/common/services/settings_service.dart';
import 'package:ecardo_etrip/src/app/constants/app_colors.dart';

class AppUpdateHelper {
  static Future<void> checkForUpdate(
    BuildContext context, {
    bool showMessageIfNoUpdate = false,
  }) async {
    try {
      final settings = Get.find<SettingsService>();
      String serverVersion = settings.getSetting('app_version') ?? '';
      String updateLink = settings.getSetting('app_update_link') ?? '';
      bool forceUpdate = settings.getSetting('app_force_update') == '1';

      if (serverVersion.isEmpty || updateLink.isEmpty) {
        if (showMessageIfNoUpdate) {
          Get.snackbar('System', 'You are on the latest version.');
        }
        return;
      }

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      if (!context.mounted) {
        return;
      }

      if (serverVersion != currentVersion && serverVersion.isNotEmpty) {
        _showUpdateDialog(context, serverVersion, updateLink, forceUpdate);
      } else {
        if (showMessageIfNoUpdate) {
          Get.snackbar('System', 'App is up to date ($currentVersion)');
        }
      }
    } catch (e) {
      debugPrint('Update Check Error: $e');
    }
  }

  static void _showUpdateDialog(
    BuildContext context,
    String version,
    String url,
    bool forceUpdate,
  ) {
    showDialog(
      context: context,
      barrierDismissible: !forceUpdate,
      builder: (ctx) {
        return PopScope(
          canPop: !forceUpdate,
          child: AlertDialog(
            title: Text('New Update Available ($version)'),
            content: const Text(
              'A new version of the application is available. Please update to continue.',
            ),
            actions: [
              if (!forceUpdate)
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Later'),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightPrimary,
                ),
                onPressed: () {
                  if (!forceUpdate) Navigator.pop(ctx);
                  if (Platform.isIOS) {
                    _openIosUpdate(url);
                  } else {
                    _downloadAndInstall(url);
                  }
                },
                child: Text(
                  Platform.isIOS ? 'Update' : 'Download & Update',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> _openIosUpdate(String url) async {
    try {
      final targetUri = Uri.parse(url.isNotEmpty ? url : 'https://ecardo.ir/download');
      if (await canLaunchUrl(targetUri)) {
        await launchUrl(targetUri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar('Update', 'Please visit https://ecardo.ir/download to update.');
      }
    } catch (e) {
      debugPrint('iOS update launch error: $e');
      Get.snackbar('Update', 'Could not open update link: $e');
    }
  }

  static Future<void> _downloadAndInstall(String url) async {
    try {
      if (Platform.isAndroid) {
        var installStatus = await Permission.requestInstallPackages.status;
        if (!installStatus.isGranted) {
          installStatus = await Permission.requestInstallPackages.request();
        }
        if (installStatus.isPermanentlyDenied) {
          await openAppSettings();
          return;
        }
      }

      Get.dialog(
        const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Downloading Update...'),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      Directory dir = await getApplicationDocumentsDirectory();
      String filePath = '${dir.path}/app_update.apk';

      Dio dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(minutes: 10),
          followRedirects: true,
        ),
      );
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (rec, total) {
          // Progress tracked
        },
      );

      if (Get.isDialogOpen == true) {
        Get.back(); // close progress dialog
      }

      final result = await OpenFilex.open(
        filePath,
        type: 'application/vnd.android.package-archive',
      );
      if (result.type != ResultType.done) {
        Get.snackbar('Error', 'Failed to open APK: ${result.message}');
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back(); // close progress dialog
      }
      Get.snackbar('Download Error', 'Could not download the update.');
      debugPrint('Download error: $e');
    }
  }
}
