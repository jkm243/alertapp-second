import 'package:flutter/material.dart';
import '../colors.dart';
import '../typography.dart';
import '../spacing.dart';
import '../animations.dart';

/// Badges avec 4 variantes et couleurs
class AppBadge extends StatefulWidget {
  final String text;
  final AppBadgeVariant variant;
  final AppBadgeSize size;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isDismissible;
  final VoidCallback? onDismiss;

  const AppBadge({
    super.key,
    required this.text,
    this.variant = AppBadgeVariant.default_,
    this.size = AppBadgeSize.medium,
    this.color,
    this.textColor,
    this.icon,
    this.onTap,
    this.isDismissible = false,
    this.onDismiss,
  });

  @override
  State<AppBadge> createState() => _AppBadgeState();
}

class _AppBadgeState extends State<AppBadge> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.easeOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onTap != null) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      widget.onTap!();
    }
  }

  void _handleDismiss() {
    _animationController.forward().then((_) {
      widget.onDismiss?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final badgeStyle = _getBadgeStyle();
    final textStyle = _getTextStyle();
    final padding = _getPadding();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: GestureDetector(
              onTap: _handleTap,
              child: Container(
                padding: padding,
                decoration: BoxDecoration(
                  color: badgeStyle.backgroundColor,
                  borderRadius: _getBorderRadius(),
                  border: badgeStyle.border,
                  boxShadow: _getBoxShadow(),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        size: _getIconSize(),
                        color: badgeStyle.textColor,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                    ],
                    Text(
                      widget.text,
                      style: textStyle.copyWith(
                        color: badgeStyle.textColor,
                      ),
                    ),
                    if (widget.isDismissible) ...[
                      const SizedBox(width: AppSpacing.xs),
                      GestureDetector(
                        onTap: _handleDismiss,
                        child: Icon(
                          Icons.close,
                          size: _getIconSize(),
                          color: badgeStyle.textColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  AppBadgeStyle _getBadgeStyle() {
    if (widget.color != null) {
      return AppBadgeStyle(
        backgroundColor: widget.color!,
        textColor: widget.textColor ?? Colors.white,
        border: Border.all(color: widget.color!, width: 1),
      );
    }

    switch (widget.variant) {
      case AppBadgeVariant.default_:
        return AppBadgeStyle(
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          border: Border.all(color: AppColors.primary, width: 1),
        );
      case AppBadgeVariant.secondary:
        return AppBadgeStyle(
          backgroundColor: AppColors.secondary,
          textColor: AppColors.secondaryForeground,
          border: Border.all(color: AppColors.secondary, width: 1),
        );
      case AppBadgeVariant.outline:
        return AppBadgeStyle(
          backgroundColor: Colors.transparent,
          textColor: AppColors.primary,
          border: Border.all(color: AppColors.primary, width: 1),
        );
      case AppBadgeVariant.destructive:
        return AppBadgeStyle(
          backgroundColor: AppColors.destructive,
          textColor: AppColors.destructiveForeground,
          border: Border.all(color: AppColors.destructive, width: 1),
        );
      case AppBadgeVariant.success:
        return AppBadgeStyle(
          backgroundColor: AppColors.success,
          textColor: AppColors.successForeground,
          border: Border.all(color: AppColors.success, width: 1),
        );
      case AppBadgeVariant.warning:
        return AppBadgeStyle(
          backgroundColor: AppColors.warning,
          textColor: AppColors.warningForeground,
          border: Border.all(color: AppColors.warning, width: 1),
        );
      case AppBadgeVariant.info:
        return AppBadgeStyle(
          backgroundColor: AppColors.info,
          textColor: AppColors.infoForeground,
          border: Border.all(color: AppColors.info, width: 1),
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (widget.size) {
      case AppBadgeSize.small:
        return AppTypography.caption.copyWith(
          fontWeight: FontWeight.w500,
        );
      case AppBadgeSize.medium:
        return AppTypography.bodySmall.copyWith(
          fontWeight: FontWeight.w500,
        );
      case AppBadgeSize.large:
        return AppTypography.body.copyWith(
          fontWeight: FontWeight.w500,
        );
    }
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case AppBadgeSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        );
      case AppBadgeSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case AppBadgeSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
    }
  }

  BorderRadius _getBorderRadius() {
    switch (widget.size) {
      case AppBadgeSize.small:
        return AppBorderRadius.smRadius;
      case AppBadgeSize.medium:
        return AppBorderRadius.mdRadius;
      case AppBadgeSize.large:
        return AppBorderRadius.lgRadius;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case AppBadgeSize.small:
        return 12.0;
      case AppBadgeSize.medium:
        return 14.0;
      case AppBadgeSize.large:
        return 16.0;
    }
  }

  List<BoxShadow> _getBoxShadow() {
    if (widget.variant == AppBadgeVariant.default_) {
      return [AppShadows.sm];
    }
    return [];
  }
}

/// Style de badge
class AppBadgeStyle {
  final Color backgroundColor;
  final Color textColor;
  final Border border;

  const AppBadgeStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.border,
  });
}

/// Variantes de badges
enum AppBadgeVariant {
  default_,
  secondary,
  outline,
  destructive,
  success,
  warning,
  info,
}

/// Tailles de badges
enum AppBadgeSize {
  small,
  medium,
  large,
}

/// Badge de statut
class AppStatusBadge extends StatelessWidget {
  final AppStatus status;
  final AppBadgeSize size;

  const AppStatusBadge({
    super.key,
    required this.status,
    this.size = AppBadgeSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfig();

    return AppBadge(
      text: statusConfig.text,
      variant: statusConfig.variant,
      size: size,
      icon: statusConfig.icon,
    );
  }

  AppStatusConfig _getStatusConfig() {
    switch (status) {
      case AppStatus.active:
        return AppStatusConfig(
          text: 'Actif',
          variant: AppBadgeVariant.success,
          icon: Icons.check_circle,
        );
      case AppStatus.inactive:
        return AppStatusConfig(
          text: 'Inactif',
          variant: AppBadgeVariant.secondary,
          icon: Icons.pause_circle,
        );
      case AppStatus.pending:
        return AppStatusConfig(
          text: 'En attente',
          variant: AppBadgeVariant.warning,
          icon: Icons.schedule,
        );
      case AppStatus.error:
        return AppStatusConfig(
          text: 'Erreur',
          variant: AppBadgeVariant.destructive,
          icon: Icons.error,
        );
      case AppStatus.completed:
        return AppStatusConfig(
          text: 'Terminé',
          variant: AppBadgeVariant.success,
          icon: Icons.check,
        );
      case AppStatus.cancelled:
        return AppStatusConfig(
          text: 'Annulé',
          variant: AppBadgeVariant.destructive,
          icon: Icons.cancel,
        );
    }
  }
}

/// Configuration de statut
class AppStatusConfig {
  final String text;
  final AppBadgeVariant variant;
  final IconData icon;

  const AppStatusConfig({
    required this.text,
    required this.variant,
    required this.icon,
  });
}

/// Statuts disponibles
enum AppStatus {
  active,
  inactive,
  pending,
  error,
  completed,
  cancelled,
}

/// Badge de notification
class AppNotificationBadge extends StatelessWidget {
  final int count;
  final AppBadgeSize size;
  final Color? color;
  final Color? textColor;
  final double? maxCount;

  const AppNotificationBadge({
    super.key,
    required this.count,
    this.size = AppBadgeSize.medium,
    this.color,
    this.textColor,
    this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    final displayCount = maxCount != null && count > maxCount!
        ? '${maxCount!.toInt()}+'
        : count.toString();

    return AppBadge(
      text: displayCount,
      variant: AppBadgeVariant.destructive,
      size: size,
      color: color,
      textColor: textColor,
    );
  }
}

/// Badge de priorité
class AppPriorityBadge extends StatelessWidget {
  final AppPriority priority;
  final AppBadgeSize size;

  const AppPriorityBadge({
    super.key,
    required this.priority,
    this.size = AppBadgeSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final priorityConfig = _getPriorityConfig();

    return AppBadge(
      text: priorityConfig.text,
      variant: priorityConfig.variant,
      size: size,
      icon: priorityConfig.icon,
    );
  }

  AppPriorityConfig _getPriorityConfig() {
    switch (priority) {
      case AppPriority.low:
        return AppPriorityConfig(
          text: 'Faible',
          variant: AppBadgeVariant.info,
          icon: Icons.keyboard_arrow_down,
        );
      case AppPriority.medium:
        return AppPriorityConfig(
          text: 'Moyenne',
          variant: AppBadgeVariant.warning,
          icon: Icons.remove,
        );
      case AppPriority.high:
        return AppPriorityConfig(
          text: 'Élevée',
          variant: AppBadgeVariant.destructive,
          icon: Icons.keyboard_arrow_up,
        );
      case AppPriority.critical:
        return AppPriorityConfig(
          text: 'Critique',
          variant: AppBadgeVariant.destructive,
          icon: Icons.priority_high,
        );
    }
  }
}

/// Configuration de priorité
class AppPriorityConfig {
  final String text;
  final AppBadgeVariant variant;
  final IconData icon;

  const AppPriorityConfig({
    required this.text,
    required this.variant,
    required this.icon,
  });
}

/// Priorités disponibles
enum AppPriority {
  low,
  medium,
  high,
  critical,
}

