import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

// ─── CustomButton ─────────────────────────────────────────────────────────────
// Primary, outlined, and text variants in one widget.
// Large touch targets (min 52px height) for accessibility.

enum ButtonVariant { primary, outlined, text, danger }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final IconData? leadingIcon;
  final double? width;
  final double height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.leadingIcon,
    this.width,
    this.height = 52,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    final size = Size(width ?? double.infinity, height);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );

    switch (variant) {
      case ButtonVariant.primary:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: size,
              shape: shape,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
            ),
            child: child,
          ),
        );

      case ButtonVariant.outlined:
        return SizedBox(
          width: width,
          height: height,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              minimumSize: size,
              shape: shape,
              side: BorderSide(
                color: isLoading
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : AppColors.primary,
                width: 1.5,
              ),
            ),
            child: DefaultTextStyle.merge(
              style: const TextStyle(color: AppColors.primary),
              child: IconTheme.merge(
                data: const IconThemeData(color: AppColors.primary),
                child: child,
              ),
            ),
          ),
        );

      case ButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );

      case ButtonVariant.danger:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: size,
              shape: shape,
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: child,
          ),
        );
    }
  }
}
