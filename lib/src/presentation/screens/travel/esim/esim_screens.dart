import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ecardo_etrip/l10n/app_localizations.dart';
import 'package:ecardo_etrip/src/app/constants/app_spacing.dart';
import 'package:ecardo_etrip/src/common/widgets/button/common_button.dart';
import 'package:ecardo_etrip/src/common/widgets/input_field/common_text_input_filed.dart';

import '../bookings/travel_checkout_screen.dart';
import '../core/models/travel_models.dart';
import '../shared/travel_theme.dart';
import '../shared/travel_widgets.dart';

class EsimIntroScreen extends StatelessWidget {
  const EsimIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final heroTitle = localization.travelEsimIntroTitle;
    final heroSubtitle = localization.travelEsimIntroDescription;
    return TravelPage(
      title: localization.travelEsim,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg.r),
          child: CommonButton(
            width: double.infinity,
            text: localization.travelBrowseEsimPackages,
            textColor: TravelTheme.ink,
            backgroundColor: TravelTheme.yellow,
            onPressed: () {
              HapticFeedback.lightImpact();
              Get.to(() => const EsimPackagesScreen());
            },
          ),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.all(AppSpacing.xl.r),
        children: [
          TravelPosterHero(
            assetPath: 'assets/images/etrip/hero-esim.jpg',
            eyebrow: localization.travelEsim,
            title: heroTitle,
            subtitle: heroSubtitle,
            icon: Icons.sim_card_download_rounded,
            accentColor: TravelTheme.yellow,
            height: 230,
          ),
          SizedBox(height: AppSpacing.xxl.h),
          _Benefit(
            icon: Icons.phonelink_setup_rounded,
            title: localization.travelEsimDeviceReadinessTitle,
            subtitle: localization.travelEsimDeviceReadinessDescription,
          ),
          _Benefit(
            icon: Icons.public_rounded,
            title: localization.travelEsimCoverageTitle,
            subtitle: localization.travelEsimCoverageDescription,
          ),
          _Benefit(
            icon: Icons.payments_outlined,
            title: localization.travelEsimTransparentTitle,
            subtitle: localization.travelEsimTransparentDescription,
          ),
        ],
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _Benefit({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md.h),
      child: TravelCard(
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: TravelTheme.yellow.withValues(alpha: .25),
              child: Icon(icon, color: TravelTheme.ink),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: TravelTheme.textPrimaryFor(context),
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
          ],
        ),
      ),
    );
  }
}

class EsimPackagesScreen extends StatefulWidget {
  const EsimPackagesScreen({super.key});

  @override
  State<EsimPackagesScreen> createState() => _EsimPackagesScreenState();
}

class _EsimPackagesScreenState extends State<EsimPackagesScreen> {
  final destinationController = TextEditingController();
  String searchedDestination = '';

  static const List<String> popularDestinations = ['TR', 'AE', 'GE', 'TH', 'FR', 'US'];

  @override
  void dispose() {
    destinationController.dispose();
    super.dispose();
  }

  Future<void> _searchPackages(String destination) async {
    final localization = AppLocalizations.of(context)!;
    final code = destination.trim().toUpperCase();
    if (code.isEmpty) {
      showTravelMessage(
        context,
        title: localization.travelEsimPackages,
        message: localization.travelDestination,
      );
      return;
    }
    destinationController.text = code;
    HapticFeedback.lightImpact();
    final controller = ensureTravelController();
    final succeeded = await controller.loadEsimPackages(code);
    if (!mounted) return;
    if (succeeded) {
      setState(() => searchedDestination = code);
    } else {
      showTravelMessage(
        context,
        title: localization.travelEsimPackages,
        message: localization.allControllerLoadError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final controller = ensureTravelController();
    final service = controller.serviceFor(TravelProductType.esim);
    final destinationField = service?.searchFields.firstWhereOrNull(
      (field) => field.key == 'country_code',
    );

    return TravelPage(
      title: localization.travelEsimPackages,
      child: RefreshIndicator(
        color: TravelTheme.yellow,
        onRefresh: () async {
          if (searchedDestination.isNotEmpty) {
            await controller.loadEsimPackages(searchedDestination);
          }
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(AppSpacing.xl.r),
          children: [
            TravelCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextInputField(
                    controller: destinationController,
                    hintText:
                        destinationField?.hint ??
                        destinationField?.label ??
                        localization.travelDestination,
                    prefixIcon: const Icon(
                      Icons.public_rounded,
                      color: TravelTheme.yellow,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  Wrap(
                    spacing: AppSpacing.sm.w,
                    runSpacing: AppSpacing.xs.h,
                    children: [
                      for (final dest in popularDestinations)
                        ActionChip(
                          label: Text(
                            dest,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: dest == searchedDestination
                                  ? FontWeight.w900
                                  : FontWeight.w600,
                            ),
                          ),
                          backgroundColor: dest == searchedDestination
                              ? TravelTheme.yellow.withValues(alpha: 0.3)
                              : TravelTheme.surfaceFor(context),
                          side: BorderSide(
                            color: dest == searchedDestination
                                ? TravelTheme.yellow
                                : TravelTheme.borderFor(context),
                          ),
                          onPressed: () => _searchPackages(dest),
                        ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  Container(
                    padding: EdgeInsets.all(AppSpacing.md.r),
                    decoration: BoxDecoration(
                      color: TravelTheme.yellow.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: TravelTheme.yellow.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: TravelTheme.ink,
                          size: 20,
                        ),
                        SizedBox(width: AppSpacing.sm.w),
                        Expanded(
                          child: Text(
                            localization.travelEsimCompatibilityNotice,
                            style: TextStyle(
                              color: TravelTheme.textSecondaryFor(context),
                              fontSize: 11.sp,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  Obx(
                    () => CommonButton(
                      width: double.infinity,
                      text: localization.travelBrowseEsimPackages,
                      textColor: TravelTheme.ink,
                      backgroundColor: TravelTheme.yellow,
                      isLoading: controller.isLoading.value,
                      onPressed: () =>
                          _searchPackages(destinationController.text),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),
            TravelSectionHeader(
              title: localization.travelChoosePackage,
              action: searchedDestination.isEmpty
                  ? null
                  : '$searchedDestination · ${controller.esimPackages.length}',
            ),
            SizedBox(height: AppSpacing.md.h),

            // 4 States
            Obx(() {
              if (controller.isLoading.value && controller.esimPackages.isEmpty) {
                return const TravelLoadingSkeleton(count: 3, height: 160);
              }
              if (controller.searchError.value != null && controller.esimPackages.isEmpty) {
                return TravelErrorView(
                  message: controller.searchError.value!,
                  onRetry: () => _searchPackages(
                    searchedDestination.isEmpty
                        ? destinationController.text
                        : searchedDestination,
                  ),
                );
              }
              if (controller.esimPackages.isEmpty) {
                return TravelEmptyView(
                  title: searchedDestination.isNotEmpty
                      ? localization.travelNoEsimPackages
                      : localization.travelChoosePackage,
                  subtitle: searchedDestination.isNotEmpty
                      ? localization.travelEsimCoverageDescription
                      : localization.travelEsimIntroDescription,
                  icon: Icons.sim_card_outlined,
                  actionLabel: searchedDestination.isNotEmpty
                      ? localization.reset
                      : null,
                  onAction: searchedDestination.isNotEmpty
                      ? () {
                          destinationController.clear();
                          setState(() => searchedDestination = '');
                        }
                      : null,
                );
              }
              return Column(
                children: [
                  for (final package in controller.esimPackages)
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                      child: _PackageCard(package: package),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final TravelEsimPackage package;

  const _PackageCard({required this.package});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final controller = ensureTravelController();
    final canPurchase = controller.canPurchase(TravelProductType.esim);
    return TravelCard(
      onTap: canPurchase
          ? () {
              HapticFeedback.lightImpact();
              controller.selectedEsim.value = package;
              Get.to(
                () => TravelCheckoutScreen(
                  type: TravelProductType.esim,
                  productId: package.id,
                  title: package.destinationCode,
                  total: package.total,
                ),
              );
            }
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54.r,
                height: 54.r,
                decoration: BoxDecoration(
                  color: TravelTheme.yellow.withValues(alpha: .25),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Icon(
                  Icons.sim_card_rounded,
                  color: TravelTheme.ink,
                  size: 26,
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        package.dataLabel,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w900,
                          color: TravelTheme.textPrimaryFor(context),
                        ),
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        package.destinationCode,
                        style: TextStyle(
                          color: TravelTheme.textSecondaryFor(context),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (package.isPopular)
                Chip(
                  backgroundColor: TravelTheme.yellow,
                  label: Text(
                    localization.travelMostPopular,
                    style: const TextStyle(
                      color: TravelTheme.ink,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
          Divider(height: 28.h, color: TravelTheme.borderFor(context)),
          Row(
            children: [
              Expanded(
                child: _PackageFact(
                  icon: Icons.public_rounded,
                  label: localization.travelDestinationCountry,
                  value: package.destinationCode,
                  forceLtr: true,
                ),
              ),
              SizedBox(width: AppSpacing.sm.w),
              Expanded(
                child: _PackageFact(
                  icon: Icons.calendar_today_rounded,
                  label: localization.travelEsimValidity,
                  value: localization.travelValidityDays(package.validityDays),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.travelTotal,
                      style: TextStyle(
                        color: TravelTheme.textSecondaryFor(context),
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        travelMoney(context, package.total),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: TravelTheme.textPrimaryFor(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 120.w,
                child: CommonButton(
                  height: 42,
                  text: canPurchase
                      ? localization.travelSelect
                      : localization.travelOfferUnavailable,
                  fontSize: 11,
                  textColor: canPurchase ? TravelTheme.ink : Colors.white,
                  backgroundColor: canPurchase
                      ? TravelTheme.yellow
                      : TravelTheme.muted,
                  onPressed: canPurchase
                      ? () {
                          HapticFeedback.lightImpact();
                          controller.selectedEsim.value = package;
                          Get.to(
                            () => TravelCheckoutScreen(
                              type: TravelProductType.esim,
                              productId: package.id,
                              title: package.destinationCode,
                              total: package.total,
                            ),
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PackageFact extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool forceLtr;

  const _PackageFact({
    required this.icon,
    required this.label,
    required this.value,
    this.forceLtr = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm.r),
      decoration: BoxDecoration(
        color: TravelTheme.surfaceFor(context),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: TravelTheme.borderFor(context)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18.r, color: TravelTheme.textSecondaryFor(context)),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: TravelTheme.textSecondaryFor(context),
                    fontSize: 9.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Directionality(
                  textDirection: forceLtr
                      ? TextDirection.ltr
                      : Directionality.of(context),
                  child: Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: TravelTheme.textPrimaryFor(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
