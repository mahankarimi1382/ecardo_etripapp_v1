import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ecardo_etrip/l10n/app_localizations.dart';
import 'package:ecardo_etrip/src/app/routes/routes.dart';
import 'package:ecardo_etrip/src/common/widgets/common_loading.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/controller/home_controller.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/account/travel_account_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/bookings/travel_orders_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/core/models/travel_models.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/esim/esim_intro_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/flights/flight_screens.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/hotels/hotel_search_screen.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/shared/travel_theme.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/shared/travel_widgets.dart';
import 'package:ecardo_etrip/src/presentation/screens/wallets/model/wallets_model.dart';

/// EtripDashboardScreen — داشبورد اختصاصی etrip
///
/// این صفحه، صفحهٔ اول بعد از ورود است (نه صفحهٔ خانهٔ سوپر اپ اکاردو).
/// شامل: هیرو برند etrip + خلاصهٔ کیف پول (متصل به کیف پول eCardo) +
/// سه سرویس سفر (هتل/پرواز/eSIM) + آخرین رزروها.
class EtripDashboardScreen extends StatelessWidget {
  const EtripDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final travelController = ensureTravelController();
    final HomeController homeController = Get.find<HomeController>();

    return TravelPage(
      title: 'etrip',
      trailing: Padding(
        padding: EdgeInsetsDirectional.only(end: 12.w),
        child: IconButton(
          onPressed: () => Get.to(() => const TravelAccountScreen()),
          icon: const Icon(Icons.account_circle_outlined),
        ),
      ),
      child: RefreshIndicator(
        color: TravelTheme.blue,
        onRefresh: () async {
          await Future.wait([
            homeController.loadData(),
            travelController.refreshOrders(),
          ]);
        },
        child: ListView(
          padding: EdgeInsetsDirectional.fromSTEB(20.w, 12.h, 20.w, 36.h),
          children: [
            _BrandHero(),
            SizedBox(height: 16.h),
            _WalletSummaryCard(homeController: homeController),
            SizedBox(height: 24.h),
            TravelSectionHeader(
              title: localization.travelTitle,
              action: localization.travelViewAll,
              onAction: () => Get.to(() => const TravelOrdersScreen()),
            ),
            SizedBox(height: 8.h),
            _Services(
              isLoading: travelController.isBootstrapLoading.value,
              hasError:
                  travelController.bootstrap.value == null &&
                  travelController.bootstrapError.value != null,
              localization: localization,
              onRetry: travelController.reloadBootstrap,
            ),
            SizedBox(height: 28.h),
            TravelSectionHeader(
              title: localization.travelRecentActivity,
              action: localization.travelViewAll,
              onAction: () => Get.to(() => const TravelOrdersScreen()),
            ),
            SizedBox(height: 8.h),
            Obx(
              () =>
                  travelController.isActivityLoading.value &&
                  travelController.activity.isEmpty
                  ? const SizedBox(height: 120, child: CommonLoading())
                  : travelController.activity.isEmpty
                  ? TravelEmptyState(
                      message: localization.travelNoBookings,
                    )
                  : Column(
                      children: travelController.activity
                          .take(3)
                          .map(
                            (item) => Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: _ActivityTile(activity: item),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------- Brand hero ---------- */
class _BrandHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final homeController = Get.find<HomeController>();
    final fullName = homeController.dashboardModel.value.data?.user?.fullName;
    final email = homeController.dashboardModel.value.data?.user?.email;
    final greeting = (fullName != null && fullName.isNotEmpty)
        ? fullName
        : (email != null && email.isNotEmpty)
            ? email
            : '';

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        borderRadius: TravelTheme.radius,
        gradient: const LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [Color(0xFF0A1628), Color(0xFF132A4E), Color(0xFF1B3A66)],
        ),
        boxShadow: TravelTheme.shadow,
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            end: -18.w,
            top: -14.h,
            child: Icon(
              Icons.hotel_rounded,
              color: Colors.white.withValues(alpha: 0.10),
              size: 170.r,
            ),
          ),
          PositionedDirectional(
            end: 70.w,
            bottom: -30.h,
            child: Icon(
              Icons.flight_takeoff_rounded,
              color: Colors.white.withValues(alpha: 0.08),
              size: 130.r,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(40.r),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.45),
                      ),
                    ),
                    child: Text(
                      'etrip',
                      style: TextStyle(
                        color: const Color(0xFFE8C766),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (greeting.isNotEmpty)
                    Flexible(
                      child: Text(
                        greeting,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 18.h),
              Text(
                localization.travelHeroTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  height: 1.3,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                localization.travelHeroEyebrow,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ---------- Wallet summary ---------- */
class _WalletSummaryCard extends StatelessWidget {
  final HomeController homeController;

  const _WalletSummaryCard({required this.homeController});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Obx(() {
      final wallets = homeController.walletsList;
      Wallets? wallet;
      for (final w in wallets) {
        if (w.isDefault == true) {
          wallet = w;
          break;
        }
      }
      wallet ??= wallets.isNotEmpty ? wallets.first : null;

      return TravelCard(
        color: const Color(0xFFF5F1E4),
        child: Row(
          children: [
            Container(
              width: 52.r,
              height: 52.r,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: Color(0xFFB8952A),
                size: 26,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.travelMainWallet,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                      color: TravelTheme.ink,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  if (wallet != null)
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        '${wallet.symbol ?? ''} ${wallet.formattedBalance ?? '0'} ${wallet.code ?? ''}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0A1628),
                        ),
                      ),
                    )
                  else
                    Text(
                      '—',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: TravelTheme.muted,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              children: [
                _MiniAction(
                  icon: Icons.add_circle_rounded,
                  label: localization.otherServicesAddMoney,
                  onTap: () => Get.toNamed(
                    BaseRoute.addMoney,
                    arguments: {'returnRoute': BaseRoute.travel},
                  ),
                ),
                SizedBox(height: 6.h),
                _MiniAction(
                  icon: Icons.account_balance_wallet_rounded,
                  label: localization.drawerMyWallets,
                  onTap: () => Get.toNamed(BaseRoute.wallets),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _MiniAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MiniAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFFB8952A), size: 16),
              SizedBox(width: 4.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0A1628),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------- Services ---------- */
class _Services extends StatelessWidget {
  final bool isLoading;
  final bool hasError;
  final AppLocalizations localization;
  final Future<void> Function() onRetry;

  const _Services({
    required this.isLoading,
    required this.hasError,
    required this.localization,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final services = [
      (TravelProductType.hotel, localization.travelMyHotels, Icons.hotel_rounded),
      (TravelProductType.flight, localization.travelMyFlights, Icons.flight_takeoff_rounded),
      (TravelProductType.esim, localization.travelMyEsims, Icons.sim_card_rounded),
    ];

    if (isLoading) {
      return const SizedBox(height: 100, child: CommonLoading());
    }
    if (hasError) {
      return Column(
        children: [
          TravelEmptyState(message: localization.allControllerLoadError),
          SizedBox(height: 8.h),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(localization.noInternetConnectionRetryButton),
          ),
        ],
      );
    }

    return Row(
      children: [
        for (var index = 0; index < services.length; index++) ...[
          Expanded(
            child: _ServiceTile(
              color: travelProductColor(services[index].$1),
              icon: services[index].$3,
              label: services[index].$2,
              foreground: services[index].$1 == TravelProductType.esim
                  ? TravelTheme.ink
                  : Colors.white,
              onTap: () => _openService(services[index].$1),
            ),
          ),
          if (index < services.length - 1) SizedBox(width: 12.w),
        ],
      ],
    );
  }

  void _openService(TravelProductType type) {
    switch (type) {
      case TravelProductType.hotel:
        Get.to(() => const HotelSearchScreen());
        return;
      case TravelProductType.flight:
        Get.to(() => const FlightSearchScreen());
        return;
      case TravelProductType.esim:
        Get.to(() => const EsimIntroScreen());
        return;
    }
  }
}

class _ServiceTile extends StatelessWidget {
  final Color color;
  final Color foreground;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.color,
    required this.foreground,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(24.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 6.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50.r,
                  height: 50.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color),
                ),
                SizedBox(height: 12.h),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 11.sp,
                    height: 1.25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ---------- Activity ---------- */
class _ActivityTile extends StatelessWidget {
  final TravelActivity activity;

  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final color = activity.isCredit
        ? TravelTheme.green
        : travelProductColor(activity.type ?? TravelProductType.hotel);
    return TravelCard(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
      child: Row(
        children: [
          Container(
            width: 46.r,
            height: 46.r,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(
              activity.isCredit
                  ? Icons.account_balance_wallet_rounded
                  : travelProductIcon(activity.type ?? TravelProductType.hotel),
              color: color,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  travelLocalizedKey(localization, activity.titleKey),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  travelLocalizedKey(localization, activity.subtitleKey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: TravelTheme.muted,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              '${activity.isCredit ? '+' : '-'}${travelMoney(context, activity.amount)}',
              style: TextStyle(
                color: activity.isCredit ? TravelTheme.green : TravelTheme.red,
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
