import 'package:flutter/material.dart';
import '../../core/responsive/responsive_utils.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_strings.dart';
import 'package:provider/provider.dart';
import '../../providers/alert_provider.dart';

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
        destinations: [
          const NavigationRailDestination(
            icon: Icon(AppIcons.patients),
            selectedIcon: Icon(AppIcons.patientsActive),
            label: Text(AppStrings.patients),
          ),
          NavigationRailDestination(
            icon: Consumer<AlertProvider>(
              builder: (context, provider, _) {
                if (provider.unreadCount > 0) {
                  return Badge(label: Text('${provider.unreadCount}'), child: const Icon(AppIcons.alerts));
                }
                return const Icon(AppIcons.alerts);
              },
            ),
            selectedIcon: Consumer<AlertProvider>(
              builder: (context, provider, _) {
                if (provider.unreadCount > 0) {
                  return Badge(label: Text('${provider.unreadCount}'), child: const Icon(AppIcons.alertsActive));
                }
                return const Icon(AppIcons.alertsActive);
              },
            ),
            label: const Text(AppStrings.alerts),
          ),
          const NavigationRailDestination(
            icon: Icon(AppIcons.analytics),
            selectedIcon: Icon(AppIcons.analyticsActive),
            label: Text(AppStrings.analytics),
          ),
          const NavigationRailDestination(
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
      destinations: [
        const NavigationDestination(
          icon: Icon(AppIcons.patients),
          selectedIcon: Icon(AppIcons.patientsActive),
          label: AppStrings.patients,
        ),
        NavigationDestination(
          icon: Consumer<AlertProvider>(
            builder: (context, provider, _) {
              if (provider.unreadCount > 0) {
                return Badge(label: Text('${provider.unreadCount}'), child: const Icon(AppIcons.alerts));
              }
              return const Icon(AppIcons.alerts);
            },
          ),
          selectedIcon: Consumer<AlertProvider>(
            builder: (context, provider, _) {
              if (provider.unreadCount > 0) {
                return Badge(label: Text('${provider.unreadCount}'), child: const Icon(AppIcons.alertsActive));
              }
              return const Icon(AppIcons.alertsActive);
            },
          ),
          label: AppStrings.alerts,
        ),
        const NavigationDestination(
          icon: Icon(AppIcons.analytics),
          selectedIcon: Icon(AppIcons.analyticsActive),
          label: AppStrings.analytics,
        ),
        const NavigationDestination(
          icon: Icon(AppIcons.profile),
          selectedIcon: Icon(AppIcons.profileActive),
          label: AppStrings.profile,
        ),
      ],
    );
  }
}
