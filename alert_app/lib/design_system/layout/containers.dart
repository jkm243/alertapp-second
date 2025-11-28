import 'package:flutter/material.dart';
import '../colors.dart';
import '../spacing.dart';
import '../typography.dart';

/// Conteneurs avec max-width et padding
class AppContainer extends StatelessWidget {
  final Widget child;
  final AppContainerSize size;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final bool isCentered;
  final bool isScrollable;

  const AppContainer({
    super.key,
    required this.child,
    this.size = AppContainerSize.medium,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.isCentered = true,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    final containerWidth = _getContainerWidth(context);
    final containerPadding = padding ?? _getPadding();
    final containerMargin = margin ?? _getMargin();

    Widget content = Container(
      width: containerWidth,
      padding: containerPadding,
      margin: containerMargin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.background,
        borderRadius: borderRadius ?? _getBorderRadius(),
        boxShadow: boxShadow ?? _getBoxShadow(),
        border: border,
      ),
      child: child,
    );

    if (isScrollable) {
      content = SingleChildScrollView(
        child: content,
      );
    }

    if (isCentered) {
      content = Center(
        child: content,
      );
    }

    return content;
  }

  double _getContainerWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    switch (size) {
      case AppContainerSize.small:
        return screenWidth > 640 ? 640 : screenWidth;
      case AppContainerSize.medium:
        return screenWidth > 768 ? 768 : screenWidth;
      case AppContainerSize.large:
        return screenWidth > 1024 ? 1024 : screenWidth;
      case AppContainerSize.xlarge:
        return screenWidth > 1280 ? 1280 : screenWidth;
      case AppContainerSize.full:
        return screenWidth;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppContainerSize.small:
        return const EdgeInsets.all(AppSpacing.md);
      case AppContainerSize.medium:
        return const EdgeInsets.all(AppSpacing.lg);
      case AppContainerSize.large:
        return const EdgeInsets.all(AppSpacing.xl);
      case AppContainerSize.xlarge:
        return const EdgeInsets.all(AppSpacing.xxl);
      case AppContainerSize.full:
        return const EdgeInsets.all(AppSpacing.md);
    }
  }

  EdgeInsets _getMargin() {
    switch (size) {
      case AppContainerSize.small:
        return const EdgeInsets.all(AppSpacing.sm);
      case AppContainerSize.medium:
        return const EdgeInsets.all(AppSpacing.md);
      case AppContainerSize.large:
        return const EdgeInsets.all(AppSpacing.lg);
      case AppContainerSize.xlarge:
        return const EdgeInsets.all(AppSpacing.xl);
      case AppContainerSize.full:
        return EdgeInsets.zero;
    }
  }

  BorderRadius _getBorderRadius() {
    switch (size) {
      case AppContainerSize.small:
        return AppBorderRadius.mdRadius;
      case AppContainerSize.medium:
        return AppBorderRadius.lgRadius;
      case AppContainerSize.large:
        return AppBorderRadius.xlRadius;
      case AppContainerSize.xlarge:
        return AppBorderRadius.xxlRadius;
      case AppContainerSize.full:
        return BorderRadius.zero;
    }
  }

  List<BoxShadow> _getBoxShadow() {
    switch (size) {
      case AppContainerSize.small:
        return [AppShadows.sm];
      case AppContainerSize.medium:
        return [AppShadows.md];
      case AppContainerSize.large:
        return [AppShadows.lg];
      case AppContainerSize.xlarge:
        return [AppShadows.xl];
      case AppContainerSize.full:
        return [];
    }
  }
}

/// Tailles de conteneurs
enum AppContainerSize {
  small,
  medium,
  large,
  xlarge,
  full,
}

/// Grid responsive : 1/2/3 colonnes selon l'écran
class AppGrid extends StatelessWidget {
  final List<Widget> children;
  final int? columns;
  final double spacing;
  final double runSpacing;
  final AppGridBreakpoint breakpoint;
  final bool isScrollable;

  const AppGrid({
    super.key,
    required this.children,
    this.columns,
    this.spacing = AppSpacing.md,
    this.runSpacing = AppSpacing.md,
    this.breakpoint = AppGridBreakpoint.auto,
    this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final gridColumns = _getGridColumns(context);
    final gridSpacing = spacing;
    final gridRunSpacing = runSpacing;

    Widget grid = Wrap(
      spacing: gridSpacing,
      runSpacing: gridRunSpacing,
      children: children.map((child) {
        return SizedBox(
          width: _getItemWidth(context, gridColumns),
          child: child,
        );
      }).toList(),
    );

    if (isScrollable) {
      grid = SingleChildScrollView(
        child: grid,
      );
    }

    return grid;
  }

  int _getGridColumns(BuildContext context) {
    if (columns != null) return columns!;

    final screenWidth = MediaQuery.of(context).size.width;
    
    switch (breakpoint) {
      case AppGridBreakpoint.auto:
        if (screenWidth < 640) return 1;
        if (screenWidth < 1024) return 2;
        return 3;
      case AppGridBreakpoint.sm:
        return 1;
      case AppGridBreakpoint.md:
        return 2;
      case AppGridBreakpoint.lg:
        return 3;
      case AppGridBreakpoint.xl:
        return 4;
    }
  }

  double _getItemWidth(BuildContext context, int columns) {
    final screenWidth = MediaQuery.of(context).size.width;
    final totalSpacing = (columns - 1) * spacing;
    return (screenWidth - totalSpacing) / columns;
  }
}

/// Breakpoints de grille
enum AppGridBreakpoint {
  auto,
  sm,
  md,
  lg,
  xl,
}

/// Section avec titre et contenu
class AppSection extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final AppSectionSize size;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final bool isCentered;

  const AppSection({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.size = AppSectionSize.medium,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.isCentered = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      size: _getContainerSize(),
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      isCentered: isCentered,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || subtitle != null) ...[
            _buildHeader(),
            const SizedBox(height: AppSpacing.lg),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: _getTitleStyle(),
          ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle!,
            style: _getSubtitleStyle(),
          ),
        ],
      ],
    );
  }

  AppContainerSize _getContainerSize() {
    switch (size) {
      case AppSectionSize.small:
        return AppContainerSize.small;
      case AppSectionSize.medium:
        return AppContainerSize.medium;
      case AppSectionSize.large:
        return AppContainerSize.large;
    }
  }

  TextStyle _getTitleStyle() {
    switch (size) {
      case AppSectionSize.small:
        return AppTypography.h5;
      case AppSectionSize.medium:
        return AppTypography.h4;
      case AppSectionSize.large:
        return AppTypography.h3;
    }
  }

  TextStyle _getSubtitleStyle() {
    switch (size) {
      case AppSectionSize.small:
        return AppTypography.bodySmall.muted;
      case AppSectionSize.medium:
        return AppTypography.body.muted;
      case AppSectionSize.large:
        return AppTypography.bodyLarge.muted;
    }
  }
}

/// Tailles de section
enum AppSectionSize {
  small,
  medium,
  large,
}

/// Layout responsive avec breakpoints
class AppResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final AppBreakpoint breakpoint;

  const AppResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.breakpoint = AppBreakpoint.auto,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (breakpoint == AppBreakpoint.auto) {
      if (screenWidth < 768) {
        return mobile;
      } else if (screenWidth < 1024) {
        return tablet ?? mobile;
      } else {
        return desktop ?? tablet ?? mobile;
      }
    }

    switch (breakpoint) {
      case AppBreakpoint.mobile:
        return mobile;
      case AppBreakpoint.tablet:
        return tablet ?? mobile;
      case AppBreakpoint.desktop:
        return desktop ?? tablet ?? mobile;
      case AppBreakpoint.auto:
        return mobile;
    }
  }
}

/// Breakpoints responsive
enum AppBreakpoint {
  auto,
  mobile,
  tablet,
  desktop,
}
