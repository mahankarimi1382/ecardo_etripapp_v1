import 'package:flutter/material.dart';

import '../../core/design_system/travel_design_tokens.dart';

class TravelCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final bool showBorder;
  final List<BoxShadow>? boxShadow;
  final Clip clipBehavior;

  const TravelCard({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(TravelSpacing.md),
    this.borderRadius,
    this.showBorder = true,
    this.boxShadow,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(TravelRadii.lg);
    final surface = Material(
      color: backgroundColor ?? TravelColors.surface,
      elevation: TravelElevations.none,
      borderRadius: radius,
      clipBehavior: clipBehavior,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(padding: padding, child: child),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        border: showBorder ? Border.all(color: TravelColors.border) : null,
        boxShadow: boxShadow ?? TravelShadows.card,
      ),
      child: surface,
    );
  }
}
