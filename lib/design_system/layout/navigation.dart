import 'package:flutter/material.dart';
import '../colors.dart';
import '../typography.dart';
import '../spacing.dart';
import '../animations.dart';

/// Navigation : TopNav (64px) et BottomNav (64px)
class AppTopNavigation extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool centerTitle;
  final double elevation;

  const AppTopNavigation({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle = true,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTypography.h6.copyWith(
          color: foregroundColor ?? Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: elevation,
      leading: leading ?? (showBackButton ? _buildBackButton(context) : null),
      actions: actions,
      toolbarHeight: 64.0, // Hauteur fixe de 64px
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back),
      tooltip: 'Retour',
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64.0);
}

/// Navigation du bas avec icônes et labels
class AppBottomNavigation extends StatefulWidget {
  final List<AppBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final AppBottomNavStyle style;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? iconSize;
  final double? fontSize;

  const AppBottomNavigation({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.onTap,
    this.style = AppBottomNavStyle.default_,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.iconSize,
    this.fontSize,
  });

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    if (widget.onTap != null) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      widget.onTap!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.0, // Hauteur fixe de 64px
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == widget.currentIndex;

          return Expanded(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: isSelected ? _scaleAnimation.value : 1.0,
                  child: GestureDetector(
                    onTap: () => _handleTap(index),
                    child: Container(
                      height: 64.0,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                        horizontal: AppSpacing.xs,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Icon(
                                isSelected ? item.selectedIcon : item.icon,
                                size: widget.iconSize ?? 24.0,
                                color: isSelected
                                    ? (widget.selectedItemColor ?? AppColors.primary)
                                    : (widget.unselectedItemColor ?? AppColors.mutedForeground),
                              ),
                              if (item.badge != null)
                                Positioned(
                                  right: -2,
                                  top: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: AppColors.destructive,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      item.badge.toString(),
                                      style: AppTypography.caption.copyWith(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            item.label,
                            style: AppTypography.caption.copyWith(
                              color: isSelected
                                  ? (widget.selectedItemColor ?? AppColors.primary)
                                  : (widget.unselectedItemColor ?? AppColors.mutedForeground),
                              fontSize: widget.fontSize ?? 12.0,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Élément de navigation du bas
class AppBottomNavItem {
  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final int? badge;

  const AppBottomNavItem({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.badge,
  });
}

/// Styles de navigation du bas
enum AppBottomNavStyle {
  default_,
  compact,
  extended,
}

/// Navigation latérale (drawer)
class AppDrawer extends StatelessWidget {
  final List<AppDrawerItem> items;
  final Widget? header;
  final Widget? footer;
  final String? userName;
  final String? userEmail;
  final Widget? userAvatar;
  final VoidCallback? onUserTap;

  const AppDrawer({
    super.key,
    required this.items,
    this.header,
    this.footer,
    this.userName,
    this.userEmail,
    this.userAvatar,
    this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          if (header != null) header!,
          if (userName != null) _buildUserSection(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: items.map((item) => _buildDrawerItem(context, item)).toList(),
            ),
          ),
          if (footer != null) footer!,
        ],
      ),
    );
  }

  Widget _buildUserSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppBorderRadius.lg),
          bottomRight: Radius.circular(AppBorderRadius.lg),
        ),
      ),
      child: GestureDetector(
        onTap: onUserTap,
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: userAvatar ?? const Icon(
                Icons.person,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName!,
                    style: AppTypography.h6.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  if (userEmail != null)
                    Text(
                      userEmail!,
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
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

  Widget _buildDrawerItem(BuildContext context, AppDrawerItem item) {
    return ListTile(
      leading: Icon(
        item.icon,
        color: item.isSelected ? AppColors.primary : AppColors.mutedForeground,
      ),
      title: Text(
        item.title,
        style: AppTypography.body.copyWith(
          color: item.isSelected ? AppColors.primary : AppColors.foreground,
          fontWeight: item.isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: item.subtitle != null
          ? Text(
              item.subtitle!,
              style: AppTypography.caption.copyWith(
                color: AppColors.mutedForeground,
              ),
            )
          : null,
      trailing: item.badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppBorderRadius.full),
              ),
              child: Text(
                item.badge.toString(),
                style: AppTypography.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : item.trailing,
      selected: item.isSelected,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
      onTap: item.onTap,
    );
  }
}

/// Élément de drawer
class AppDrawerItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isSelected;
  final int? badge;
  final Widget? trailing;

  const AppDrawerItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isSelected = false,
    this.badge,
    this.trailing,
  });
}

