import 'package:flutter/material.dart';
import '../colors.dart';
import '../typography.dart';
import '../spacing.dart';
import '../animations.dart';

/// Cartes avec styles et hover effects
class AppCard extends StatefulWidget {
  final Widget child;
  final AppCardVariant variant;
  final AppCardSize size;
  final VoidCallback? onTap;
  final bool isHoverable;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final String? title;
  final String? subtitle;
  final Widget? header;
  final Widget? footer;
  final List<Widget>? actions;

  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.default_,
    this.size = AppCardSize.medium,
    this.onTap,
    this.isHoverable = false,
    this.padding,
    this.margin,
    this.title,
    this.subtitle,
    this.header,
    this.footer,
    this.actions,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
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

  void _handleHover(bool isHovered) {
    if (widget.isHoverable) {
      setState(() {
        _isHovered = isHovered;
      });
      if (isHovered) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardStyle = _getCardStyle();
    final padding = widget.padding ?? _getPadding();
    final margin = widget.margin ?? _getMargin();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _handleHover(true),
            onExit: (_) => _handleHover(false),
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                margin: margin,
                decoration: BoxDecoration(
                  color: cardStyle.backgroundColor,
                  borderRadius: _getBorderRadius(),
                  border: cardStyle.border,
                  boxShadow: _getBoxShadow(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.header != null || widget.title != null) ...[
                      _buildHeader(),
                      const Divider(height: 1),
                    ],
                    Padding(
                      padding: padding,
                      child: widget.child,
                    ),
                    if (widget.footer != null || widget.actions != null) ...[
                      const Divider(height: 1),
                      _buildFooter(),
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

  Widget _buildHeader() {
    return Padding(
      padding: _getPadding(),
      child: widget.header ?? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Text(
              widget.title!,
              style: AppTypography.h5,
            ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              widget.subtitle!,
              style: AppTypography.bodySmall.muted,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: _getPadding(),
      child: widget.footer ?? Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: widget.actions ?? [],
      ),
    );
  }

  AppCardStyle _getCardStyle() {
    switch (widget.variant) {
      case AppCardVariant.default_:
        return AppCardStyle(
          backgroundColor: AppColors.card,
          border: Border.all(color: AppColors.border),
        );
      case AppCardVariant.outlined:
        return AppCardStyle(
          backgroundColor: Colors.transparent,
          border: Border.all(color: AppColors.border, width: 2),
        );
      case AppCardVariant.elevated:
        return AppCardStyle(
          backgroundColor: AppColors.card,
          border: Border.all(color: AppColors.border),
        );
      case AppCardVariant.filled:
        return AppCardStyle(
          backgroundColor: AppColors.muted,
          border: Border.all(color: AppColors.border),
        );
    }
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case AppCardSize.small:
        return const EdgeInsets.all(AppSpacing.md);
      case AppCardSize.medium:
        return const EdgeInsets.all(AppSpacing.lg);
      case AppCardSize.large:
        return const EdgeInsets.all(AppSpacing.xl);
    }
  }

  EdgeInsets _getMargin() {
    switch (widget.size) {
      case AppCardSize.small:
        return const EdgeInsets.all(AppSpacing.sm);
      case AppCardSize.medium:
        return const EdgeInsets.all(AppSpacing.md);
      case AppCardSize.large:
        return const EdgeInsets.all(AppSpacing.lg);
    }
  }

  BorderRadius _getBorderRadius() {
    switch (widget.size) {
      case AppCardSize.small:
        return AppBorderRadius.mdRadius;
      case AppCardSize.medium:
        return AppBorderRadius.lgRadius;
      case AppCardSize.large:
        return AppBorderRadius.xlRadius;
    }
  }

  List<BoxShadow> _getBoxShadow() {
    if (widget.variant == AppCardVariant.elevated) {
      return [AppShadows.md];
    }
    if (_isHovered && widget.isHoverable) {
      return [AppShadows.lg];
    }
    return [AppShadows.sm];
  }
}

/// Style de carte
class AppCardStyle {
  final Color backgroundColor;
  final Border border;

  const AppCardStyle({
    required this.backgroundColor,
    required this.border,
  });
}

/// Variantes de cartes
enum AppCardVariant {
  default_,
  outlined,
  elevated,
  filled,
}

/// Tailles de cartes
enum AppCardSize {
  small,
  medium,
  large,
}

/// Carte de statistique
class AppStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? valueColor;
  final VoidCallback? onTap;

  const AppStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      isHoverable: onTap != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.bodySmall.muted,
              ),
              if (icon != null)
                Icon(
                  icon,
                  size: 20,
                  color: iconColor ?? AppColors.mutedForeground,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.h3.copyWith(
              color: valueColor ?? AppColors.foreground,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle!,
              style: AppTypography.caption,
            ),
          ],
        ],
      ),
    );
  }
}

/// Carte d'alerte
class AppAlertCard extends StatelessWidget {
  final String title;
  final String message;
  final AppAlertType type;
  final VoidCallback? onDismiss;
  final List<Widget>? actions;

  const AppAlertCard({
    super.key,
    required this.title,
    required this.message,
    this.type = AppAlertType.info,
    this.onDismiss,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final alertStyle = _getAlertStyle();

    return AppCard(
      variant: AppCardVariant.outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                alertStyle.icon,
                color: alertStyle.iconColor,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.h6.copyWith(
                    color: alertStyle.titleColor,
                  ),
                ),
              ),
              if (onDismiss != null)
                GestureDetector(
                  onTap: onDismiss,
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.mutedForeground,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: AppTypography.body.copyWith(
              color: alertStyle.messageColor,
            ),
          ),
          if (actions != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!,
            ),
          ],
        ],
      ),
    );
  }

  AppAlertStyle _getAlertStyle() {
    switch (type) {
      case AppAlertType.success:
        return AppAlertStyle(
          icon: Icons.check_circle,
          iconColor: AppColors.success,
          titleColor: AppColors.success,
          messageColor: AppColors.foreground,
        );
      case AppAlertType.warning:
        return AppAlertStyle(
          icon: Icons.warning,
          iconColor: AppColors.warning,
          titleColor: AppColors.warning,
          messageColor: AppColors.foreground,
        );
      case AppAlertType.error:
        return AppAlertStyle(
          icon: Icons.error,
          iconColor: AppColors.destructive,
          titleColor: AppColors.destructive,
          messageColor: AppColors.foreground,
        );
      case AppAlertType.info:
        return AppAlertStyle(
          icon: Icons.info,
          iconColor: AppColors.info,
          titleColor: AppColors.info,
          messageColor: AppColors.foreground,
        );
    }
  }
}

/// Style d'alerte
class AppAlertStyle {
  final IconData icon;
  final Color iconColor;
  final Color titleColor;
  final Color messageColor;

  const AppAlertStyle({
    required this.icon,
    required this.iconColor,
    required this.titleColor,
    required this.messageColor,
  });
}

/// Types d'alerte
enum AppAlertType {
  success,
  warning,
  error,
  info,
}
