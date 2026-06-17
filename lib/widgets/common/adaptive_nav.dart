import 'package:flutter/material.dart';
import '../../core/responsive/responsive_utils.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_strings.dart';

class AdaptiveNav extends StatelessWidget {
  const AdaptiveNav({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop || context.isLandscape) {
      return NavigationRail(
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        labelType: NavigationRailLabelType.all,
        groupAlignment: 0.0,
        destinations: const [
          NavigationRailDestination(
            icon: Icon(AppIcons.patients),
            selectedIcon: Icon(AppIcons.patientsActive),
            label: Text(AppStrings.patients),
          ),
          NavigationRailDestination(
            icon: Icon(AppIcons.alerts),
            selectedIcon: Icon(AppIcons.alertsActive),
            label: Text(AppStrings.alerts),
          ),
          NavigationRailDestination(
            icon: Icon(AppIcons.analytics),
            selectedIcon: Icon(AppIcons.analyticsActive),
            label: Text(AppStrings.analytics),
          ),
          NavigationRailDestination(
            icon: Icon(AppIcons.profile),
            selectedIcon: Icon(AppIcons.profileActive),
            label: Text(AppStrings.profile),
          ),
        ],
      );
    }

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(AppIcons.patients),
          selectedIcon: Icon(AppIcons.patientsActive),
          label: AppStrings.patients,
        ),
        NavigationDestination(
          icon: Icon(AppIcons.alerts),
          selectedIcon: Icon(AppIcons.alertsActive),
          label: AppStrings.alerts,
        ),
        NavigationDestination(
          icon: Icon(AppIcons.analytics),
          selectedIcon: Icon(AppIcons.analyticsActive),
          label: AppStrings.analytics,
        ),
        NavigationDestination(
          icon: Icon(AppIcons.profile),
          selectedIcon: Icon(AppIcons.profileActive),
          label: AppStrings.profile,
        ),
      ],
    );
  }
}
