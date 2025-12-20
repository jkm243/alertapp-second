import 'package:flutter/material.dart';
import '../colors.dart';
import '../typography.dart';
import '../spacing.dart';
import '../animations.dart';

/// Boutons avec 5 variantes : primary, secondary, outline, ghost, destructive
class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? child;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.child,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.buttonPress,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.buttonCurve,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePress() {
    if (widget.onPressed != null && !widget.isLoading) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final textStyle = _getTextStyle();
    final padding = _getPadding();

    Widget buttonChild = widget.child ?? Row(
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: _getIconSize(),
            height: _getIconSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                buttonStyle.foregroundColor,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (widget.icon != null) ...[
          Icon(
            widget.icon,
            size: _getIconSize(),
            color: buttonStyle.foregroundColor,
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          widget.text,
          style: textStyle,
        ),
      ],
    );

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _handlePress,
            child: Container(
              width: widget.isFullWidth ? double.infinity : null,
              padding: padding,
              decoration: BoxDecoration(
                color: buttonStyle.backgroundColor,
                borderRadius: _getBorderRadius(),
                border: buttonStyle.border,
                boxShadow: _getBoxShadow(),
              ),
              child: buttonChild,
            ),
          ),
        );
      },
    );
  }

  AppButtonStyle _getButtonStyle() {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return AppButtonStyle(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          border: Border.all(color: AppColors.primary),
        );
      case AppButtonVariant.secondary:
        return AppButtonStyle(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.secondaryForeground,
          border: Border.all(color: AppColors.secondary),
        );
      case AppButtonVariant.outline:
        return AppButtonStyle(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          border: Border.all(color: AppColors.primary, width: 1),
        );
      case AppButtonVariant.ghost:
        return AppButtonStyle(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          border: Border.all(color: Colors.transparent),
        );
      case AppButtonVariant.destructive:
        return AppButtonStyle(
          backgroundColor: AppColors.destructive,
          foregroundColor: AppColors.destructiveForeground,
          border: Border.all(color: AppColors.destructive),
        );
    }
  }

  TextStyle _getTextStyle() {
    final buttonStyle = _getButtonStyle();
    switch (widget.size) {
      case AppButtonSize.small:
        return AppTypography.buttonSmall.copyWith(
          color: buttonStyle.foregroundColor,
        );
      case AppButtonSize.medium:
        return AppTypography.button.copyWith(
          color: buttonStyle.foregroundColor,
        );
      case AppButtonSize.large:
        return AppTypography.buttonLarge.copyWith(
          color: buttonStyle.foregroundColor,
        );
    }
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        );
    }
  }

  BorderRadius _getBorderRadius() {
    switch (widget.size) {
      case AppButtonSize.small:
        return AppBorderRadius.smRadius;
      case AppButtonSize.medium:
        return AppBorderRadius.mdRadius;
      case AppButtonSize.large:
        return AppBorderRadius.lgRadius;
    }
  }

  List<BoxShadow> _getBoxShadow() {
    if (widget.variant == AppButtonVariant.primary) {
      return [AppShadows.primary];
    }
    return [];
  }

  double _getIconSize() {
    switch (widget.size) {
      case AppButtonSize.small:
        return 16.0;
      case AppButtonSize.medium:
        return 20.0;
      case AppButtonSize.large:
        return 24.0;
    }
  }
}

/// Variantes de boutons
enum AppButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
}

/// Tailles de boutons
enum AppButtonSize {
  small,
  medium,
  large,
}

/// Style de bouton
class AppButtonStyle {
  final Color backgroundColor;
  final Color foregroundColor;
  final Border border;

  const AppButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.border,
  });
}

/// Bouton avec icône
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final String? tooltip;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final iconSize = _getIconSize();
    final padding = _getPadding();

    Widget button = GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: buttonStyle.backgroundColor,
          borderRadius: _getBorderRadius(),
          border: buttonStyle.border,
          boxShadow: _getBoxShadow(),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: buttonStyle.foregroundColor,
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }

  AppButtonStyle _getButtonStyle() {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppButtonStyle(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          border: Border.all(color: AppColors.primary),
        );
      case AppButtonVariant.secondary:
        return AppButtonStyle(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.secondaryForeground,
          border: Border.all(color: AppColors.secondary),
        );
      case AppButtonVariant.outline:
        return AppButtonStyle(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          border: Border.all(color: AppColors.primary, width: 1),
        );
      case AppButtonVariant.ghost:
        return AppButtonStyle(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          border: Border.all(color: Colors.transparent),
        );
      case AppButtonVariant.destructive:
        return AppButtonStyle(
          backgroundColor: AppColors.destructive,
          foregroundColor: AppColors.destructiveForeground,
          border: Border.all(color: AppColors.destructive),
        );
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16.0;
      case AppButtonSize.medium:
        return 20.0;
      case AppButtonSize.large:
        return 24.0;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.all(AppSpacing.sm);
      case AppButtonSize.medium:
        return const EdgeInsets.all(AppSpacing.md);
      case AppButtonSize.large:
        return const EdgeInsets.all(AppSpacing.lg);
    }
  }

  BorderRadius _getBorderRadius() {
    switch (size) {
      case AppButtonSize.small:
        return AppBorderRadius.smRadius;
      case AppButtonSize.medium:
        return AppBorderRadius.mdRadius;
      case AppButtonSize.large:
        return AppBorderRadius.lgRadius;
    }
  }

  List<BoxShadow> _getBoxShadow() {
    if (variant == AppButtonVariant.primary) {
      return [AppShadows.primary];
    }
    return [];
  }
}
