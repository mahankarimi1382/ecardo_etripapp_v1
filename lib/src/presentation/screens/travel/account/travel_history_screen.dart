import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ecardo_etrip/l10n/app_localizations.dart';
import 'package:ecardo_etrip/src/app/constants/app_spacing.dart';

import '../core/models/travel_models.dart';
import '../shared/travel_theme.dart';
import '../shared/travel_widgets.dart';

class TravelHistoryScreen extends StatelessWidget {
  const TravelHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final controller = ensureTravelController();
    return TravelPage(
      title: localization.travelHistory,
      activeSection: TravelNavigationSection.history,
      child: RefreshIndicator(
        color: TravelTheme.blue,
        onRefresh: controller.loadDashboard,
        child: Obx(() {
          if (controller.isActivityLoading.value && controller.activity.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(AppSpacing.xl.r),
              children: const [
                TravelLoadingSkeleton(count: 5, height: 78),
              ],
            );
          }

          if (controller.activity.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(AppSpacing.xl.r),
              children: [
                SizedBox(height: 80.h),
                TravelEmptyView(
                  icon: Icons.history_rounded,
                  title: localization.travelNoActivity,
                  subtitle: localization.travelActivityWalletTopUp,
                ),
              ],
            );
          }

          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppSpacing.xl.r),
            itemCount: controller.activity.length,
            separatorBuilder: (_, _) => SizedBox(height: AppSpacing.md.h),
            itemBuilder: (context, index) {
              final item = controller.activity[index];
              final color = item.isCredit
                  ? TravelTheme.green
                  : travelProductColor(
                      item.type ?? TravelProductType.hotel,
                    );
              return TravelCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: color.withValues(alpha: .12),
                      child: Icon(
                        item.isCredit
                            ? Icons.account_balance_wallet_rounded
                            : travelProductIcon(
                                item.type ?? TravelProductType.hotel,
                              ),
                        color: color,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            travelLocalizedKey(localization, item.titleKey),
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: TravelTheme.textPrimaryFor(context),
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs.h),
                          Text(
                            travelLocalizedKey(
                              localization,
                              item.subtitleKey,
                            ),
                            style: TextStyle(
                              color: TravelTheme.textSecondaryFor(context),
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        '${item.isCredit ? '+' : '-'}${travelMoney(context, item.amount)}',
                        style: TextStyle(
                          color: item.isCredit
                              ? TravelTheme.green
                              : TravelTheme.red,
                          fontWeight: FontWeight.w900,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
