import 'package:flutter/material.dart';

import '../../core/design_system/travel_design_tokens.dart';
import 'travel_button.dart';

class TravelSkeleton extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius borderRadius;

  const TravelSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = const BorderRadius.all(Radius.circular(TravelRadii.sm)),
  });

  const TravelSkeleton.line({
    super.key,
    this.width,
    this.height = 14,
    this.borderRadius = const BorderRadius.all(Radius.circular(TravelRadii.sm)),
  });

  const TravelSkeleton.card({
    super.key,
    this.width,
    this.height = 160,
    this.borderRadius = const BorderRadius.all(Radius.circular(TravelRadii.lg)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: TravelColors.border,
        borderRadius: borderRadius,
      ),
    );
  }
}

class TravelEmptyState extends StatelessWidget {
  final String? title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const TravelEmptyState({
    super.key,
    required this.message,
    this.title,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return _TravelFeedbackLayout(
      icon: icon,
      iconColor: TravelColors.inkMuted,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
      actionVariant: TravelButtonVariant.outlined,
    );
  }
}

class TravelErrorState extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  const TravelErrorState({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
    this.retryLabel = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    return _TravelFeedbackLayout(
      icon: Icons.error_outline_rounded,
      iconColor: TravelColors.error,
      title: title,
      message: message,
      actionLabel: onRetry == null ? null : retryLabel,
      onAction: onRetry,
      actionVariant: TravelButtonVariant.primary,
    );
  }
}

class _TravelFeedbackLayout extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String? title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final TravelButtonVariant actionVariant;

  const _TravelFeedbackLayout({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.actionVariant,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TravelSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, color: iconColor, size: 48),
            if (title != null) ...[
              const SizedBox(height: TravelSpacing.md),
              Text(
                title!,
                textAlign: TextAlign.center,
                style: TravelTypography.title,
              ),
            ],
            const SizedBox(height: TravelSpacing.xs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TravelTypography.body.copyWith(
                color: TravelColors.inkMuted,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: TravelSpacing.lg),
              TravelButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: actionVariant,
                fullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
