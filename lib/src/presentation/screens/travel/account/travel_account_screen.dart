import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ecardo_etrip/l10n/app_localizations.dart';
import 'package:ecardo_etrip/src/app/constants/app_spacing.dart';
import 'package:ecardo_etrip/src/app/routes/routes.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/controller/home_controller.dart';

import '../bookings/travel_orders_screen.dart';
import '../core/models/travel_models.dart';
import '../shared/travel_theme.dart';
import '../shared/travel_widgets.dart';

class TravelAccountScreen extends StatelessWidget {
  const TravelAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final user = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>().userModel.value.data
        : null;
    return TravelPage(
      title: localization.travelAccount,
      activeSection: TravelNavigationSection.account,
      child: ListView(
        padding: EdgeInsets.all(AppSpacing.xl.r),
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.xl.r),
            decoration: BoxDecoration(
              borderRadius: TravelTheme.radius,
              gradient: const LinearGradient(
                colors: [Color(0xFF005AB6), TravelTheme.blue],
              ),
              boxShadow: TravelTheme.shadowFor(context),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 34.r,
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.person_rounded,
                    size: 34,
                    color: TravelTheme.blue,
                  ),
                ),
                SizedBox(width: AppSpacing.lg.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.fullName?.isNotEmpty == true
                            ? user!.fullName!
                            : localization.travelAccountHolder,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs.h),
                      Text(
                        localization.travelMemberDescription,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .8),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xxl.h),
          _AccountTile(
            icon: Icons.hotel_rounded,
            title: localization.travelMyHotels,
            subtitle: localization.travelMyHotelsDescription,
            onTap: () {
              HapticFeedback.lightImpact();
              Get.to(
                () => const TravelOrdersScreen(
                  initialType: TravelProductType.hotel,
                ),
              );
            },
          ),
          _AccountTile(
            icon: Icons.flight_rounded,
            title: localization.travelMyFlights,
            subtitle: localization.travelMyFlightsDescription,
            onTap: () {
              HapticFeedback.lightImpact();
              Get.to(
                () => const TravelOrdersScreen(
                  initialType: TravelProductType.flight,
                ),
              );
            },
          ),
          _AccountTile(
            icon: Icons.sim_card_rounded,
            title: localization.travelMyEsims,
            subtitle: localization.travelMyEsimsDescription,
            onTap: () {
              HapticFeedback.lightImpact();
              Get.to(
                () => const TravelOrdersScreen(
                  initialType: TravelProductType.esim,
                ),
              );
            },
          ),
          _AccountTile(
            icon: Icons.luggage_rounded,
            title: localization.travelAllBookings,
            subtitle: localization.travelMyBookingsDescription,
            onTap: () {
              HapticFeedback.lightImpact();
              Get.toNamed(BaseRoute.travelOrders);
            },
          ),
          _AccountTile(
            icon: Icons.badge_outlined,
            title: localization.travelPersonalInformation,
            subtitle: localization.travelPersonalInformationDescription,
            onTap: () {
              HapticFeedback.lightImpact();
              Get.toNamed(BaseRoute.profileSettings);
            },
          ),
          _AccountTile(
            icon: Icons.history_rounded,
            title: localization.travelHistory,
            subtitle: localization.travelHistoryDescription,
            onTap: () {
              HapticFeedback.lightImpact();
              Get.toNamed(BaseRoute.travelHistory);
            },
          ),
          _AccountTile(
            icon: Icons.account_balance_wallet_outlined,
            title: localization.travelMainWallet,
            subtitle: localization.travelWalletSharedDescription,
            onTap: () {
              HapticFeedback.lightImpact();
              Get.toNamed(
                BaseRoute.wallets,
                arguments: {'returnRoute': BaseRoute.travelAccount},
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AccountTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md.h),
      child: TravelCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.md.r),
              decoration: BoxDecoration(
                color: TravelTheme.isDark(context)
                    ? const Color(0xFF1E2E42)
                    : const Color(0xFFEAF3FF),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(icon, color: TravelTheme.blue),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: TravelTheme.textPrimaryFor(context),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: TravelTheme.textSecondaryFor(context),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: TravelTheme.textSecondaryFor(context),
            ),
          ],
        ),
      ),
    );
  }
}
