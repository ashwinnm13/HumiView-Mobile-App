import 'package:flutter/material.dart';
import 'breakpoints.dart';
import '../theme/app_spacing.dart';

/// Responsive utility extension methods on [BuildContext].
extension ResponsiveUtils on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < Breakpoints.mobile;
  bool get isTablet =>
      screenWidth >= Breakpoints.mobile && screenWidth < Breakpoints.tablet;
  bool get isDesktop => screenWidth >= Breakpoints.tablet;
  bool get isCompactMobile => screenWidth < Breakpoints.compactMobile;

  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;
  bool get isPortrait =>
      MediaQuery.orientationOf(this) == Orientation.portrait;

  /// Horizontal screen padding adaptive to device
  double get screenPaddingH =>
      isMobile ? AppSpacing.screenPaddingH : AppSpacing.screenPaddingHTablet;

  /// Number of dashboard grid columns based on width
  int get gridColumns => Breakpoints.gridColumns(screenWidth);

  /// Choose a value based on current breakpoint
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Scaled value based on width (relative to 375 base)
  double scaledWidth(double value) {
    return value * (screenWidth / 375).clamp(0.8, 1.5);
  }

  /// Safe area padding
  EdgeInsets get safeAreaPadding => MediaQuery.paddingOf(this);
}
