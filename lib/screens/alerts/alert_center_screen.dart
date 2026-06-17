import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_icons.dart';
import '../../core/responsive/responsive_utils.dart';
import '../../providers/alert_provider.dart';
import '../../widgets/alerts/alert_tile.dart';
import '../../widgets/common/empty_state.dart';

class AlertCenterScreen extends StatefulWidget {
  const AlertCenterScreen({super.key});

  @override
  State<AlertCenterScreen> createState() => _AlertCenterScreenState();
}

class _AlertCenterScreenState extends State<AlertCenterScreen> {
  String _currentFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.alertCenter),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(AppIcons.refresh),
            onPressed: () {},
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(context),
          Expanded(
            child: _buildAlertList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final filters = ['All', AppStrings.critical, AppStrings.warning, AppStrings.info];

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(horizontal: context.screenPaddingH, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = _currentFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (_) => setState(() => _currentFilter = filter),
                showCheckmark: false,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAlertList(BuildContext context) {
    return Consumer<AlertProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var alerts = provider.alerts;
        if (_currentFilter != 'All') {
          alerts = alerts.where((a) => a.severity.name.toLowerCase() == _currentFilter.toLowerCase()).toList();
        }

        if (alerts.isEmpty) {
          return const EmptyState(
            title: AppStrings.noAlerts,
            description: AppStrings.noAlertsDesc,
            icon: AppIcons.checkCircle,
          );
        }

        return ListView.separated(
          padding: EdgeInsets.only(
            top: 16,
            left: context.screenPaddingH,
            right: context.screenPaddingH,
            bottom: 80,
          ),
          itemCount: alerts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final alert = alerts[index];
            return Dismissible(
              key: Key(alert.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(AppIcons.checkCircle, color: Colors.white),
              ),
              onDismissed: (_) {
                provider.dismissAlert(alert.id);
              },
              child: AlertTile(
                alert: alert,
                onAcknowledge: () => provider.acknowledgeAlert(alert.id),
                onDismiss: () => provider.dismissAlert(alert.id),
              ),
            );
          },
        );
      },
    );
  }
}
