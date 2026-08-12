import 'package:flutter/material.dart';

import '../../core/design_system/travel_design_tokens.dart';

enum TravelButtonVariant { primary, secondary, outlined, text }

class TravelButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final TravelButtonVariant variant;
  final bool isLoading;
  final Widget? leading;
  final bool fullWidth;
  final double? height;
  final double? width;

  const TravelButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = TravelButtonVariant.primary,
    this.isLoading = false,
    this.leading,
    this.fullWidth = true,
    this.height = 48,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;
    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (leading != null) ...[
                leading!,
                const SizedBox(width: TravelSpacing.xs),
              ],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );

    final Widget button = switch (variant) {
      TravelButtonVariant.primary => FilledButton(
        onPressed: effectiveOnPressed,
        style: FilledButton.styleFrom(
          backgroundColor: TravelColors.primary,
          foregroundColor: Colors.white,
          minimumSize: Size(0, height ?? 48),
          padding: const EdgeInsets.symmetric(horizontal: TravelSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TravelRadii.md),
          ),
        ),
        child: child,
      ),
      TravelButtonVariant.secondary => FilledButton(
        onPressed: effectiveOnPressed,
        style: FilledButton.styleFrom(
          backgroundColor: TravelColors.accent,
          foregroundColor: TravelColors.ink,
          minimumSize: Size(0, height ?? 48),
          padding: const EdgeInsets.symmetric(horizontal: TravelSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TravelRadii.md),
          ),
        ),
        child: child,
      ),
      TravelButtonVariant.outlined => OutlinedButton(
        onPressed: effectiveOnPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: TravelColors.primary,
          minimumSize: Size(0, height ?? 48),
          padding: const EdgeInsets.symmetric(horizontal: TravelSpacing.lg),
          side: const BorderSide(color: TravelColors.borderStrong),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TravelRadii.md),
          ),
        ),
        child: child,
      ),
      TravelButtonVariant.text => TextButton(
        onPressed: effectiveOnPressed,
        style: TextButton.styleFrom(
          foregroundColor: TravelColors.primary,
          minimumSize: Size(0, height ?? 48),
          padding: const EdgeInsets.symmetric(horizontal: TravelSpacing.sm),
        ),
        child: child,
      ),
    };

    return SizedBox(
      width: width ?? (fullWidth ? double.infinity : null),
      height: height,
      child: button,
    );
  }
}
