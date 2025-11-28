import 'package:flutter/material.dart';

/// Animations et transitions avec durées et courbes spécifiques
class AppAnimations {
  // Durées d'animation
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 700);
  static const Duration slowest = Duration(milliseconds: 1000);

  // Courbes d'animation
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOutCubic = Curves.easeOutCubic;
  static const Curve easeInCubic = Curves.easeInCubic;
  static const Curve easeInOutCubic = Curves.easeInOutCubic;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticOut = Curves.elasticOut;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  // Animations spécifiques
  static const Duration fadeIn = normal;
  static const Duration fadeOut = fast;
  static const Duration slideIn = normal;
  static const Duration slideOut = fast;
  static const Duration scaleIn = normal;
  static const Duration scaleOut = fast;
  static const Duration rotateIn = normal;
  static const Duration rotateOut = fast;

  // Transitions de page
  static const Duration pageTransition = normal;
  static const Curve pageTransitionCurve = easeOutCubic;

  // Animations d'accordion
  static const Duration accordionExpand = Duration(milliseconds: 200);
  static const Duration accordionCollapse = Duration(milliseconds: 150);
  static const Curve accordionCurve = easeOut;

  // Animations de bouton
  static const Duration buttonPress = Duration(milliseconds: 100);
  static const Duration buttonRelease = Duration(milliseconds: 150);
  static const Curve buttonCurve = easeOut;

  // Animations de modal
  static const Duration modalOpen = Duration(milliseconds: 250);
  static const Duration modalClose = Duration(milliseconds: 200);
  static const Curve modalCurve = easeOutCubic;

  // Animations de toast/notification
  static const Duration toastShow = Duration(milliseconds: 200);
  static const Duration toastHide = Duration(milliseconds: 150);
  static const Duration toastDuration = Duration(seconds: 3);
  static const Curve toastCurve = easeOut;

  // Animations de skeleton/loading
  static const Duration skeletonShimmer = Duration(milliseconds: 1500);
  static const Duration skeletonPulse = Duration(milliseconds: 1000);
  static const Curve skeletonCurve = easeInOut;
}

/// Transitions de page personnalisées
class AppPageTransitions {
  // Transition slide depuis la droite
  static Widget slideFromRight(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: AppAnimations.pageTransitionCurve,
      )),
      child: child,
    );
  }

  // Transition slide depuis la gauche
  static Widget slideFromLeft(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: AppAnimations.pageTransitionCurve,
      )),
      child: child,
    );
  }

  // Transition slide depuis le bas
  static Widget slideFromBottom(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: AppAnimations.pageTransitionCurve,
      )),
      child: child,
    );
  }

  // Transition fade
  static Widget fade(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: AppAnimations.pageTransitionCurve,
      ),
      child: child,
    );
  }

  // Transition scale
  static Widget scale(Widget child, Animation<double> animation) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: AppAnimations.pageTransitionCurve,
      ),
      child: child,
    );
  }
}

/// Animations d'accordion spécifiques
class AppAccordionAnimations {
  static Widget expand(Widget child, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animation,
        curve: AppAnimations.accordionCurve,
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: AppAnimations.accordionCurve,
        ),
        child: child,
      ),
    );
  }
}

/// Animations de bouton
class AppButtonAnimations {
  static Widget press(Widget child, Animation<double> animation) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 1.0,
        end: 0.95,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: AppAnimations.buttonCurve,
      )),
      child: child,
    );
  }
}

/// Animations de skeleton/loading
class AppSkeletonAnimations {
  static Widget shimmer(Widget child, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: const [
                0.0,
                0.5,
                1.0,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: child,
    );
  }
}

/// Extension pour faciliter l'utilisation des animations
extension AppAnimationExtension on Widget {
  /// Applique une animation de fade in
  Widget fadeIn({Duration duration = AppAnimations.fadeIn}) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: this,
    );
  }

  /// Applique une animation de slide depuis la droite
  Widget slideInFromRight({Duration duration = AppAnimations.slideIn}) {
    return TweenAnimationBuilder<Offset>(
      duration: duration,
      tween: Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
      curve: AppAnimations.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value * MediaQuery.of(context).size.width,
          child: child,
        );
      },
      child: this,
    );
  }

  /// Applique une animation de scale
  Widget scaleIn({Duration duration = AppAnimations.scaleIn}) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      curve: AppAnimations.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: this,
    );
  }
}
