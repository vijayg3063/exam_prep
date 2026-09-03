import 'package:flutter/material.dart';

/// Centralized application-level scroll behavior.
/// Disables visual stretching / elastic bouncing overscroll indicators globally
/// across Android and iOS while using ClampingScrollPhysics.
class AppScrollBehavior extends ScrollBehavior {
  const AppScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    // Returning child directly removes both stretching and glow overscroll indicators
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }
}
