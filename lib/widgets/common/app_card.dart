import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';

/// A premium, medical-grade card with soft shadows and flexible layout.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
    this.margin = const EdgeInsets.all(AppSpacing.cardMargin),
    this.onTap,
    this.color,
    this.shadows,
    this.borderRadius = AppSpacing.cardRadius,
    this.border,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final Color? color;
  final List<BoxShadow>? shadows;
  final double borderRadius;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadows ?? AppShadows.card,
        border: border,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          hoverColor: AppColors.primary.withValues(alpha: 0.02),
          highlightColor: AppColors.primary.withValues(alpha: 0.05),
          splashColor: AppColors.primary.withValues(alpha: 0.05),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );

    if (margin != EdgeInsets.zero) {
      card = Padding(
        padding: margin,
        child: card,
      );
    }

    return card;
  }
}
