import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_icons.dart';
import '../../providers/alert_provider.dart';
import '../../widgets/alerts/alert_tile.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcons.back),
          onPressed: () => context.pop(),
        ),
        title: const Text(AppStrings.notifications),
        actions: [
          Consumer<AlertProvider>(
            builder: (context, provider, _) => IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: AppStrings.markAllRead,
              onPressed: provider.unreadCount > 0 ? provider.markAllAsRead : null,
            ),
          ),
        ],
      ),
      body: Consumer<AlertProvider>(
        builder: (context, provider, _) {
          final alerts = provider.alerts;
          if (alerts.isEmpty) {
            return const Center(child: Text('No notifications'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: alerts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return AlertTile(
                alert: alert,
                onAcknowledge: () => provider.acknowledgeAlert(alert.id),
                onDismiss: () => provider.dismissAlert(alert.id),
              );
            },
          );
        },
      ),
    );
  }
}
