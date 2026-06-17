import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// Responsive layout builder that provides mobile, tablet, and desktop builders.
///
/// Wraps [LayoutBuilder] and [OrientationBuilder] to simplify responsive design.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget Function(BuildContext context, BoxConstraints constraints)
      mobile;
  final Widget Function(BuildContext context, BoxConstraints constraints)?
      tablet;
  final Widget Function(BuildContext context, BoxConstraints constraints)?
      desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= Breakpoints.tablet && desktop != null) {
          return desktop!(context, constraints);
        }

        if (width >= Breakpoints.mobile && tablet != null) {
          return tablet!(context, constraints);
        }

        return mobile(context, constraints);
      },
    );
  }
}

/// Simplified responsive builder with orientation awareness.
class OrientationResponsiveLayout extends StatelessWidget {
  const OrientationResponsiveLayout({
    super.key,
    required this.portrait,
    required this.landscape,
  });

  final Widget portrait;
  final Widget landscape;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return landscape;
        }
        return portrait;
      },
    );
  }
}
