import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:ecardo_etrip/l10n/app_localizations.dart';
import 'package:ecardo_etrip/src/app/constants/app_colors.dart';
import 'package:ecardo_etrip/src/app/routes/routes.dart';
import 'package:ecardo_etrip/src/common/widgets/app_bar/common_app_bar.dart';
import 'package:ecardo_etrip/src/common/widgets/app_bar/common_default_app_bar.dart';

import '../core/controller/travel_controller.dart';
import '../core/models/travel_models.dart';
import 'travel_theme.dart';

void showTravelMessage(
  BuildContext context, {
  required String title,
  required String message,
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  final safeMessage = travelSafePresentationMessage(message);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('$title\n$safeMessage'),
        behavior: SnackBarBehavior.floating,
      ),
    );
}

enum TravelNavigationSection { account, history, dashboard, settings }

String travelSafePresentationMessage(String message) {
  final trimmed = message.trim();
  if (trimmed.isEmpty) return travelGenericErrorMessage;
  final reference = _travelReferenceFromText(trimmed);
  final looksUnsafe = RegExp(
    r'(DioException|Exception|Error|StackTrace|package:|dart:|<html|{|"message")',
    caseSensitive: false,
  ).hasMatch(trimmed);
  if (!looksUnsafe) return trimmed;
  if (reference == null) return travelGenericErrorMessage;
  return '$travelGenericErrorMessage Reference: $reference';
}

String? _travelReferenceFromText(String value) {
  final match = RegExp(
    r'(?:support[_ -]?reference|request[_ -]?reference|request[_ -]?id|correlation[_ -]?id|trace[_ -]?id|reference)["\s:=]+([A-Za-z0-9][A-Za-z0-9._:-]{0,79})',
    caseSensitive: false,
  ).firstMatch(value);
  return match?.group(1);
}

TravelController ensureTravelController() {
  if (Get.isRegistered<TravelController>()) {
    return Get.find<TravelController>();
  }
  return Get.put(TravelController());
}

class TravelPage extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? bottomNavigationBar;
  final Widget? trailing;
  final bool showBack;
  final bool showTravelNavigation;
  final TravelNavigationSection activeSection;

  const TravelPage({
    super.key,
    required this.title,
    required this.child,
    this.bottomNavigationBar,
    this.trailing,
    this.showBack = true,
    this.showTravelNavigation = true,
    this.activeSection = TravelNavigationSection.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TravelTheme.backgroundFor(context),
      appBar: const CommonDefaultAppBar(),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          CommonAppBar(
            title: title,
            isBackLogicApply: !showBack,
            backLogicFunction: showBack ? null : () {},
            rightSideWidget: trailing,
          ),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: _TravelPageFooter(
        actionBar: bottomNavigationBar,
        showNavigation: showTravelNavigation,
        activeSection: activeSection,
      ),
    );
  }
}

class _TravelPageFooter extends StatelessWidget {
  final Widget? actionBar;
  final bool showNavigation;
  final TravelNavigationSection activeSection;

  const _TravelPageFooter({
    required this.actionBar,
    required this.showNavigation,
    required this.activeSection,
  });

  @override
  Widget build(BuildContext context) {
    if (!showNavigation) return actionBar ?? const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ?actionBar,
        TravelBottomNavigation(activeSection: activeSection),
      ],
    );
  }
}

class TravelBottomNavigation extends StatelessWidget {
  final TravelNavigationSection activeSection;

  const TravelBottomNavigation({super.key, required this.activeSection});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 10.h),
        decoration: BoxDecoration(
          color: TravelTheme.cardSurfaceFor(context),
          border: Border(top: BorderSide(color: TravelTheme.borderFor(context))),
          boxShadow: TravelTheme.shadowFor(context),
        ),
        child: Row(
          children: [
            _TravelNavigationItem(
              label: localization.travelAccount,
              icon: Icons.person_rounded,
              selected: activeSection == TravelNavigationSection.account,
              onTap: () => _open(BaseRoute.travelAccount),
            ),
            _TravelNavigationItem(
              label: localization.travelHistory,
              icon: Icons.history_rounded,
              selected: activeSection == TravelNavigationSection.history,
              onTap: () => _open(BaseRoute.travelHistory),
            ),
            _TravelNavigationItem(
              label: localization.travelTitle,
              icon: Icons.explore_rounded,
              selected: activeSection == TravelNavigationSection.dashboard,
              onTap: () => _open(BaseRoute.travel),
            ),
            _TravelNavigationItem(
              label: localization.bottomNavSettings,
              icon: Icons.settings_rounded,
              selected: activeSection == TravelNavigationSection.settings,
              onTap: () => _open(BaseRoute.settings),
            ),
          ],
        ),
      ),
    );
  }

  void _open(String route) {
    if (Get.currentRoute == route) return;
    Get.offNamed(route);
  }
}

TextDirection travelTextDirection(
  BuildContext context,
  String value, {
  TextDirection? fallback,
}) {
  final firstStrong = RegExp(
    r'[\u0590-\u08FF]|[A-Za-z\u0400-\u04FF\u4E00-\u9FFF]',
  ).firstMatch(value)?.group(0);
  if (firstStrong == null) {
    return fallback ?? Directionality.of(context);
  }
  return RegExp(r'[\u0590-\u08FF]').hasMatch(firstStrong)
      ? TextDirection.rtl
      : TextDirection.ltr;
}

class TravelBidiText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TravelBidiText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: travelTextDirection(context, text),
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}

class TravelPosterHero extends StatelessWidget {
  final String assetPath;
  final String title;
  final String? eyebrow;
  final String? subtitle;
  final IconData? icon;
  final Color accentColor;
  final double height;
  final AlignmentDirectional contentAlignment;

  const TravelPosterHero({
    super.key,
    required this.assetPath,
    required this.title,
    this.eyebrow,
    this.subtitle,
    this.icon,
    this.accentColor = TravelTheme.yellow,
    this.height = 180,
    this.contentAlignment = AlignmentDirectional.bottomStart,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: TravelTheme.radius,
      child: Container(
        height: height.h,
        decoration: BoxDecoration(boxShadow: TravelTheme.shadow),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              assetPath,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: TravelTheme.blue),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.45),
                    Colors.black.withValues(alpha: 0.78),
                  ],
                ),
              ),
            ),
            if (icon != null)
              PositionedDirectional(
                end: 18.w,
                top: 18.h,
                child: Container(
                  width: 54.r,
                  height: 54.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.90),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accentColor, size: 28.r),
                ),
              ),
            PositionedDirectional(
              end: 14.w,
              bottom: 14.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Text(
                  'etrip',
                  style: TextStyle(
                    color: TravelTheme.ink,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .4,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(22.r),
              child: Align(
                alignment: contentAlignment,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (eyebrow?.isNotEmpty == true) ...[
                      Text(
                        eyebrow!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .9),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 7.h),
                    ],
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        height: 1.28,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: .38),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    if (subtitle?.isNotEmpty == true) ...[
                      SizedBox(height: 8.h),
                      Text(
                        subtitle!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .88),
                          fontSize: 12.sp,
                          height: 1.45,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TravelNavigationItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TravelNavigationItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? TravelTheme.blue : TravelTheme.muted;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 23.r),
              SizedBox(height: 3.h),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 8.5.sp,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TravelCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;

  const TravelCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = (color == null || color == Colors.white)
        ? TravelTheme.cardSurfaceFor(context)
        : color!;
    return Material(
      color: effectiveColor,
      borderRadius: TravelTheme.radius,
      child: InkWell(
        borderRadius: TravelTheme.radius,
        onTap: onTap == null
            ? null
            : () {
                HapticFeedback.lightImpact();
                onTap!();
              },
        child: Container(
          padding: padding ?? EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            borderRadius: TravelTheme.radius,
            border: Border.all(color: TravelTheme.borderFor(context)),
            boxShadow: onTap == null ? null : TravelTheme.shadowFor(context),
          ),
          child: child,
        ),
      ),
    );
  }
}

class TravelFieldTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  const TravelFieldTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = TravelTheme.isDark(context);
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              onTap!();
            },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF262625) : const Color(0xFFF1F2F4),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: TravelTheme.borderFor(context)),
        ),
        child: Row(
          children: [
            Icon(icon, color: TravelTheme.blue),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: TravelTheme.textSecondaryFor(context),
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      color: TravelTheme.textPrimaryFor(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: TravelTheme.textSecondaryFor(context),
            ),
          ],
        ),
      ),
    );
  }
}

class TravelSectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const TravelSectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: TravelTheme.textPrimaryFor(context),
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (action != null)
          InkWell(
            borderRadius: BorderRadius.circular(10.r),
            onTap: onAction,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              child: Text(
                action!,
                style: const TextStyle(
                  color: TravelTheme.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

String travelLocalizedKey(AppLocalizations localization, String key) {
  return switch (key) {
    'travelMockHotelEspinas' => localization.travelMockHotelEspinas,
    'travelMockHotelEspinasLocation' =>
      localization.travelMockHotelEspinasLocation,
    'travelMockHotelParsian' => localization.travelMockHotelParsian,
    'travelMockHotelParsianLocation' =>
      localization.travelMockHotelParsianLocation,
    'travelMockHotelVisteria' => localization.travelMockHotelVisteria,
    'travelMockHotelVisteriaLocation' =>
      localization.travelMockHotelVisteriaLocation,
    'travelMockFlightTehranIstanbul' =>
      localization.travelMockFlightTehranIstanbul,
    'travelMockAirlineOne' => localization.travelMockAirlineOne,
    'travelMockAirlineTwo' => localization.travelMockAirlineTwo,
    'travelRecommended' => localization.travelRecommended,
    'travelBestValue' => localization.travelBestValue,
    'travelLuxury' => localization.travelLuxury,
    'travelDirect' => localization.travelDirect,
    'travelLowestPrice' => localization.travelLowestPrice,
    'travelFeatureBreakfast' => localization.travelFeatureBreakfast,
    'travelFeaturePool' => localization.travelFeaturePool,
    'travelFeatureWifi' => localization.travelFeatureWifi,
    'travelFeatureParking' => localization.travelFeatureParking,
    'travelFeatureAirportTransfer' => localization.travelFeatureAirportTransfer,
    'travelFeatureCabinBag' => localization.travelFeatureCabinBag,
    'travelFeatureRefundable' => localization.travelFeatureRefundable,
    'travelEsimTurkey' => localization.travelEsimTurkey,
    'travelActivityFlightPurchase' => localization.travelActivityFlightPurchase,
    'travelActivityEsimPurchase' => localization.travelActivityEsimPurchase,
    'travelActivityWalletTopUp' => localization.travelActivityWalletTopUp,
    'travelMainWallet' => localization.travelMainWallet,
    'travelDemoOffer' => localization.travelDemoOffer,
    'travelRequiresConfirmation' => localization.travelRequiresConfirmation,
    'travelHotelBooking' => localization.travelHotelBooking,
    _ => key,
  };
}

String travelBackendText(BuildContext context, dynamic value) {
  if (value == null) return '';
  if (value is! Map) return value.toString().trim();
  final map = Map<String, dynamic>.from(value);
  final language = Localizations.localeOf(context).languageCode.toLowerCase();
  final selected =
      map[language] ??
      (language == 'zh' ? map['zh-cn'] ?? map['zh_cn'] : null) ??
      map['en'] ??
      map.values.firstOrNull;
  return selected?.toString().trim() ?? '';
}

String travelBackendFieldLabel(AppLocalizations localization, String key) {
  return switch (key.toLowerCase()) {
    'address' => localization.travelAddress,
    'amenities' => localization.travelIncluded,
    'airline' || 'airline_name' => localization.travelAirline,
    'arrival' || 'arrival_time' => localization.travelArrival,
    'aircraft' || 'aircraft_code' => localization.travelAircraft,
    'baggage' || 'baggage_allowance' => localization.travelBaggage,
    'board' || 'board_type' => localization.travelBoard,
    'booking_number' => localization.travelBookingNumber,
    'cabin' || 'cabin_class' => localization.travelCabin,
    'cancellation' ||
    'cancellation_policy' ||
    'cancellation_rules' => localization.travelCancellationPolicy,
    'check_in' || 'check_in_time' => localization.travelCheckIn,
    'check_out' || 'check_out_time' => localization.travelCheckOut,
    'child_count' || 'children' => localization.travelChildren,
    'departure' || 'departure_time' => localization.travelDeparture,
    'description' => localization.travelDescription,
    'destination' || 'destination_name' => localization.travelDestination,
    'duration' => localization.travelDuration,
    'flight' || 'flight_number' => localization.travelFlightNumber,
    'origin' || 'origin_name' => localization.travelOrigin,
    'price' || 'total' || 'total_amount' => localization.travelTotal,
    'rating' || 'stars' => localization.travelRating,
    'refund_policy' || 'refundability' => localization.travelRefundPolicy,
    'room' || 'room_name' => localization.travelRoom,
    'room_count' || 'rooms' => localization.travelRooms,
    'supplier_reference' => localization.travelSupplierReference,
    'voucher_number' => localization.travelVoucherNumber,
    _ =>
      key
          .replaceAll('_', ' ')
          .split(' ')
          .where((part) => part.isNotEmpty)
          .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
          .join(' '),
  };
}

String travelBackendValue(BuildContext context, dynamic value) {
  if (value == null) return '';
  if (value is bool) return value ? '✓' : '—';
  if (value is List) {
    return value
        .map((item) => travelBackendValue(context, item))
        .where((item) => item.isNotEmpty)
        .join(', ');
  }
  if (value is Map) {
    final localized = travelBackendText(context, value);
    if (localized.isNotEmpty && !localized.startsWith('{')) return localized;
    final localization = AppLocalizations.of(context)!;
    return value.entries
        .map(
          (entry) =>
              '${travelBackendFieldLabel(localization, entry.key.toString())}: '
              '${travelBackendValue(context, entry.value)}',
        )
        .where((item) => !item.endsWith(': '))
        .join(' • ');
  }
  return value.toString().trim();
}

class TravelJourneyGuide extends StatelessWidget {
  final int currentStep;
  final List<String> steps;
  final String? message;

  const TravelJourneyGuide({
    super.key,
    required this.currentStep,
    required this.steps,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return TravelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message?.isNotEmpty == true) ...[
            Text(
              message!,
              style: TextStyle(
                color: TravelTheme.muted,
                fontSize: 11.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 14.h),
          ],
          Row(
            children: [
              for (var index = 0; index < steps.length; index++) ...[
                Expanded(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 14.r,
                        backgroundColor: index <= currentStep
                            ? TravelTheme.blue
                            : (TravelTheme.isDark(context)
                                ? const Color(0xFF323230)
                                : TravelTheme.borderFor(context)),
                        child: index < currentStep
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 16,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: index == currentStep
                                      ? Colors.white
                                      : TravelTheme.textSecondaryFor(context),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 10.sp,
                                ),
                              ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        steps[index],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: index == currentStep
                              ? TravelTheme.textPrimaryFor(context)
                              : TravelTheme.textSecondaryFor(context),
                          fontSize: 9.sp,
                          fontWeight: index == currentStep
                              ? FontWeight.w900
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (index != steps.length - 1)
                  Container(
                    width: 18.w,
                    height: 2,
                    color: index < currentStep
                        ? TravelTheme.blue
                        : TravelTheme.borderFor(context),
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

String travelMoney(BuildContext context, TravelMoney money) {
  final lang = Localizations.localeOf(context).languageCode;
  final numFormat = NumberFormat('#,##0', 'en_US');
  final formattedAmount = numFormat.format(money.amount.round());

  final currUpper = money.currency.toUpperCase().trim();
  if (currUpper == 'IRR') {
    return lang == 'fa' ? '$formattedAmount ریال' : '$formattedAmount IRR';
  } else if (currUpper == 'TOMAN' || currUpper == 'IRT') {
    return lang == 'fa' ? '$formattedAmount تومان' : '$formattedAmount Toman';
  } else if (currUpper == 'USD') {
    return '\$$formattedAmount';
  } else if (currUpper == 'EUR') {
    return '€$formattedAmount';
  } else if (currUpper == 'AED') {
    return lang == 'fa' ? '$formattedAmount درهم' : '$formattedAmount AED';
  } else if (currUpper == 'TRY') {
    return '₺$formattedAmount';
  } else if (currUpper == 'GBP') {
    return '£$formattedAmount';
  }
  return '$formattedAmount ${money.currency}';
}

IconData travelProductIcon(TravelProductType type) => switch (type) {
  TravelProductType.hotel => Icons.hotel_rounded,
  TravelProductType.flight => Icons.flight_rounded,
  TravelProductType.esim => Icons.sim_card_rounded,
  TravelProductType.tour => Icons.tour_rounded,
  TravelProductType.visa => Icons.card_membership_rounded,
  TravelProductType.carRental => Icons.directions_car_rounded,
};

Color travelProductColor(TravelProductType type) => switch (type) {
  TravelProductType.hotel => TravelTheme.purple,
  TravelProductType.flight => TravelTheme.blue,
  TravelProductType.esim => TravelTheme.yellow,
  TravelProductType.tour => const Color(0xFF14AE6F),
  TravelProductType.visa => const Color(0xFF87624C),
  TravelProductType.carRental => const Color(0xFFF2994A),
};

class TravelEmptyState extends StatelessWidget {
  final String message;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;

  const TravelEmptyState({
    super.key,
    required this.message,
    this.icon,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(28.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: TravelTheme.blue.withValues(alpha: 0.12),
              child: Icon(
                icon ?? Icons.inbox_outlined,
                size: 30.r,
                color: TravelTheme.blue,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TravelTheme.textSecondaryFor(context),
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (actionText != null && onAction != null) ...[
              SizedBox(height: 16.h),
              TextButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Rich empty state for travel screens with title, subtitle, themed icon, and CTA.
class TravelEmptyView extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const TravelEmptyView({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.search_off_rounded,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36.r,
              backgroundColor: TravelTheme.blue.withValues(alpha: 0.12),
              child: Icon(icon, size: 36.r, color: TravelTheme.blue),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TravelTheme.textPrimaryFor(context),
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
              ),
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              SizedBox(height: 6.h),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TravelTheme.textSecondaryFor(context),
                  fontSize: 12.sp,
                  height: 1.4,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 18.h),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: TravelTheme.primaryFor(context),
                  foregroundColor: TravelTheme.isDark(context)
                      ? AppColors.deepBlack
                      : AppColors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                ),
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Rich error state with themed icon, human-readable message, and Retry CTA.
class TravelErrorView extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final String? retryLabel;

  const TravelErrorView({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
    this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(28.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 34.r,
              backgroundColor: AppColors.error.withValues(alpha: 0.12),
              child: Icon(
                Icons.error_outline_rounded,
                size: 34.r,
                color: AppColors.error,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              title ?? localization?.allControllerLoadError ?? 'Error',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TravelTheme.textPrimaryFor(context),
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              travelSafePresentationMessage(message),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TravelTheme.textSecondaryFor(context),
                fontSize: 12.sp,
                height: 1.4,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: 18.h),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: TravelTheme.primaryFor(context),
                  foregroundColor: TravelTheme.isDark(context)
                      ? AppColors.deepBlack
                      : AppColors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                ),
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(
                  retryLabel ??
                      localization?.noInternetConnectionRetryButton ??
                      'Retry',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Dark-mode safe skeleton loader for travel listings.
class TravelLoadingSkeleton extends StatelessWidget {
  final int count;
  final double height;

  const TravelLoadingSkeleton({
    super.key,
    this.count = 3,
    this.height = 110,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = TravelTheme.isDark(context);
    final baseColor = isDark ? const Color(0xFF262625) : const Color(0xFFE8E9EC);
    return Column(
      children: List.generate(
        count,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Container(
            height: height.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: TravelTheme.radius,
              border: Border.all(color: TravelTheme.borderFor(context)),
            ),
          ),
        ),
      ),
    );
  }
}

/// A non-intrusive, theme-aware inline banner that displays
/// network and offline errors gracefully with a retry CTA.
class TravelRetryBanner extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback onRetry;
  final VoidCallback? onDismiss;
  final bool isOffline;
  final EdgeInsetsGeometry? margin;
  final String? retryLabel;

  const TravelRetryBanner({
    super.key,
    required this.message,
    this.title,
    required this.onRetry,
    this.onDismiss,
    this.isOffline = false,
    this.margin,
    this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final isDark = TravelTheme.isDark(context);
    final safeMsg = travelSafePresentationMessage(message);

    final bgColor = isDark
        ? (isOffline ? const Color(0xFF2C2419) : const Color(0xFF2E1C1A))
        : (isOffline ? const Color(0xFFFFF8E7) : const Color(0xFFFEECEC));

    final accentColor = isOffline
        ? (isDark ? const Color(0xFFF2C94C) : const Color(0xFFB78103))
        : (isDark ? const Color(0xFFFF8B7B) : AppColors.error);

    final borderColor = isDark
        ? accentColor.withValues(alpha: 0.35)
        : accentColor.withValues(alpha: 0.25);

    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isOffline ? Icons.wifi_off_rounded : Icons.cloud_off_rounded,
              color: accentColor,
              size: 20.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null && title!.isNotEmpty)
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: TravelTheme.textPrimaryFor(context),
                    ),
                  ),
                Text(
                  safeMsg,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w500,
                    color: TravelTheme.textSecondaryFor(context),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: accentColor.withValues(alpha: 0.2),
              foregroundColor: accentColor,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              onRetry();
            },
            child: Text(
              retryLabel ??
                  localization?.noInternetConnectionRetryButton ??
                  'Retry',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (onDismiss != null) ...[
            SizedBox(width: 4.w),
            IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: 18.r,
                color: TravelTheme.textSecondaryFor(context),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onDismiss,
            ),
          ],
        ],
      ),
    );
  }
}

/// A world-class star rating pill badge (Booking.com & Airbnb style)
class TravelStarRatingBadge extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final bool compact;

  const TravelStarRatingBadge({
    super.key,
    required this.rating,
    this.reviewCount,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (rating <= 0) return const SizedBox.shrink();
    final isDark = TravelTheme.isDark(context);
    final formatted = rating.toStringAsFixed(rating.truncateToDouble() == rating ? 0 : 1);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6.w : 8.w,
        vertical: compact ? 2.h : 4.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF362C18) : const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFFF2C94C).withValues(alpha: isDark ? 0.45 : 0.65),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: const Color(0xFFF2C94C),
            size: compact ? 13.r : 15.r,
          ),
          SizedBox(width: 3.w),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              formatted,
              style: TextStyle(
                color: isDark ? const Color(0xFFFFE082) : const Color(0xFF7A4F01),
                fontSize: compact ? 10.sp : 11.5.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (reviewCount != null && reviewCount! > 0) ...[
            SizedBox(width: 3.w),
            Text(
              '($reviewCount)',
              style: TextStyle(
                color: TravelTheme.textSecondaryFor(context),
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A world-class flight route timeline and diagram (Hopper / Skyscanner style)
class TravelRouteTimeline extends StatelessWidget {
  final String originCode;
  final String originCity;
  final String departureTime;
  final String destinationCode;
  final String destinationCity;
  final String arrivalTime;
  final String duration;
  final String routeType;
  final bool compact;

  const TravelRouteTimeline({
    super.key,
    required this.originCode,
    required this.originCity,
    required this.departureTime,
    required this.destinationCode,
    required this.destinationCity,
    required this.arrivalTime,
    required this.duration,
    required this.routeType,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = TravelTheme.isDark(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Origin
          SizedBox(
            width: compact ? 70.w : 84.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  departureTime,
                  style: TextStyle(
                    fontSize: compact ? 15.sp : 18.sp,
                    fontWeight: FontWeight.w900,
                    color: TravelTheme.textPrimaryFor(context),
                  ),
                ),
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: TravelTheme.blue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    originCode,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: TravelTheme.blue,
                    ),
                  ),
                ),
                if (originCity.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  TravelBidiText(
                    originCity,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: TravelTheme.textSecondaryFor(context),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Timeline Diagram
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (duration.isNotEmpty)
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w700,
                        color: TravelTheme.textSecondaryFor(context),
                      ),
                    ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      // Origin Node
                      Container(
                        width: 7.r,
                        height: 7.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: TravelTheme.blue, width: 1.5),
                          color: TravelTheme.cardSurfaceFor(context),
                        ),
                      ),
                      // Flight Path Line
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 1.5.h,
                              color: TravelTheme.blue.withValues(alpha: isDark ? 0.5 : 0.35),
                            ),
                            Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: TravelTheme.cardSurfaceFor(context),
                                border: Border.all(
                                  color: TravelTheme.blue.withValues(alpha: 0.4),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.flight_takeoff_rounded,
                                size: 12.r,
                                color: TravelTheme.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Destination Node
                      Container(
                        width: 7.r,
                        height: 7.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: TravelTheme.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: TravelTheme.blue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      routeType,
                      style: TextStyle(
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w700,
                        color: TravelTheme.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Destination
          SizedBox(
            width: compact ? 70.w : 84.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  arrivalTime,
                  style: TextStyle(
                    fontSize: compact ? 15.sp : 18.sp,
                    fontWeight: FontWeight.w900,
                    color: TravelTheme.textPrimaryFor(context),
                  ),
                ),
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: TravelTheme.blue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    destinationCode,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: TravelTheme.blue,
                    ),
                  ),
                ),
                if (destinationCity.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  TravelBidiText(
                    destinationCity,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: TravelTheme.textSecondaryFor(context),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A theme-aware cancellation policy badge
class TravelCancellationBadge extends StatelessWidget {
  final String policyText;
  final bool isRefundable;
  final bool compact;

  const TravelCancellationBadge({
    super.key,
    required this.policyText,
    this.isRefundable = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (policyText.isEmpty) return const SizedBox.shrink();
    final isDark = TravelTheme.isDark(context);
    final accentColor = isRefundable ? AppColors.success : AppColors.error;
    final bgColor = isDark
        ? (isRefundable ? const Color(0xFF1E382A) : const Color(0xFF3B1E1E))
        : (isRefundable ? const Color(0xFFEAF8F0) : const Color(0xFFFFEBEE));

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8.w : 10.w,
        vertical: compact ? 4.h : 6.h,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: accentColor.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isRefundable ? Icons.verified_user_rounded : Icons.shield_outlined,
            color: accentColor,
            size: compact ? 13.r : 15.r,
          ),
          SizedBox(width: 5.w),
          Flexible(
            child: Text(
              policyText,
              style: TextStyle(
                color: accentColor,
                fontSize: compact ? 10.sp : 11.sp,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Converts ISO 3166-1 alpha-2 country code (e.g. "TR", "US", "FR") into flag emoji unicode
String travelCountryCodeToEmoji(String countryCode) {
  final clean = countryCode.trim().toUpperCase();
  if (clean.length != 2) return '';
  final first = clean.codeUnitAt(0);
  final second = clean.codeUnitAt(1);
  if (first < 0x41 || first > 0x5A || second < 0x41 || second > 0x5A) return '';
  return String.fromCharCode(first - 0x41 + 0x1F1E6) +
      String.fromCharCode(second - 0x41 + 0x1F1E6);
}

/// Returns localized country name if known, else falls back to code
String travelCountryName(String code) {
  return switch (code.toUpperCase().trim()) {
    'TR' => 'Turkey',
    'AE' => 'UAE',
    'GE' => 'Georgia',
    'TH' => 'Thailand',
    'FR' => 'France',
    'US' => 'USA',
    'DE' => 'Germany',
    'IT' => 'Italy',
    'ES' => 'Spain',
    'GB' || 'UK' => 'United Kingdom',
    'CA' => 'Canada',
    'QA' => 'Qatar',
    'OM' => 'Oman',
    'AM' => 'Armenia',
    'AZ' => 'Azerbaijan',
    _ => code,
  };
}

