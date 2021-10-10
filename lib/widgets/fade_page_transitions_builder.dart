import 'package:flutter/material.dart';

class FadePageTransitionsBuilder extends PageTransitionsBuilder {
  const FadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _FadePageTransitionsBuilder(routeAnimation: animation, child: child);
  }
}

class _FadePageTransitionsBuilder extends StatelessWidget {
  _FadePageTransitionsBuilder({
    Key? key,
    required Animation<double> routeAnimation,
    required this.child,
  })  : _opacityAnimation = routeAnimation.drive(_easeInTween),
        super(key: key);

  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeInOutCubic);

  final Animation<double> _opacityAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: child,
    );
  }
}
