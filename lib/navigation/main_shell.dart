import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/common/adaptive_nav.dart';
import '../core/responsive/responsive_utils.dart';

class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final useRail = context.isDesktop || context.isLandscape;

    return Scaffold(
      body: Row(
        children: [
          if (useRail)
            AdaptiveNav(
              currentIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
            ),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: useRail
          ? null
          : AdaptiveNav(
              currentIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
            ),
    );
  }
}
