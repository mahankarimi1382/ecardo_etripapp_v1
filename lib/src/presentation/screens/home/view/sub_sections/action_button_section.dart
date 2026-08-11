import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecardo_etrip/l10n/app_localizations.dart';
import 'package:ecardo_etrip/src/app/constants/app_colors.dart';
import 'package:ecardo_etrip/src/app/constants/assets_path/png/png_assets.dart';
import 'package:ecardo_etrip/src/app/routes/routes.dart';
import 'package:ecardo_etrip/src/common/services/settings_service.dart';
import 'package:ecardo_etrip/src/helper/toast_helper.dart';

class ActionButtonSection extends StatelessWidget {
  const ActionButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.10),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildButtons(
            context,
            icon: PngAssets.commonTransferIcon,
            name: localizations.otherServicesAddMoney,
            onPressed: () {
              if (Get.find<SettingsService>().getSetting("user_deposit") ==
                  "1") {
                Get.toNamed(BaseRoute.addMoney);
              } else {
                ToastHelper().showErrorToast(
                  localizations.actionButtonUserTransferNotEnabled,
                );
              }
            },
            backgroundColor: const Color(0xFFA869FF).withValues(alpha: 0.3),
          ),
          _buildButtons(
            context,
            icon: PngAssets.commonWithdrawIcon,
            name: localizations.otherServicesTransactions,
            onPressed: () => Get.toNamed(BaseRoute.transactions),
            backgroundColor: const Color(0xFFFF77BA).withValues(alpha: 0.3),
          ),
          _buildButtons(
            context,
            icon: PngAssets.commonPaymentIcon,
            name: localizations.drawerMyWallets,
            onPressed: () => Get.toNamed(BaseRoute.wallets),
            backgroundColor: const Color(0xFFFFBB8C).withValues(alpha: 0.3),
          ),
          _buildButtons(
            context,
            icon: PngAssets.commonExchangeIcon,
            name: localizations.travelTitle,
            onPressed: () => Get.toNamed(BaseRoute.travel),
            backgroundColor: const Color(0xFFA869FF).withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(
    BuildContext context, {
    required String icon,
    required String name,
    required GestureTapCallback onPressed,
    required Color backgroundColor,
  }) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onPressed,
        splashColor: AppColors.lightPrimary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Image(image: AssetImage(icon), width: 25),
              SizedBox(height: 6),
              Text(
                name,
                style: TextStyle(
                  letterSpacing: 0,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.lightTextPrimary.withValues(alpha: 0.80),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
