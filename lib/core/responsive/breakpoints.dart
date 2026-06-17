/// HumiView — Device Breakpoints
///
/// Responsive breakpoints for mobile, tablet, and desktop layouts.
class Breakpoints {
  Breakpoints._();

  /// Mobile: < 600px
  static const double mobile = 600;

  /// Tablet: 600–1024px
  static const double tablet = 1024;

  /// Desktop: > 1024px
  static const double desktop = 1440;

  /// Compact mobile: < 360px
  static const double compactMobile = 360;

  /// Dashboard grid columns by width
  static int gridColumns(double width) {
    if (width < mobile) return 1;
    if (width < 840) return 2;
    if (width < tablet) return 3;
    return 4;
  }
}
