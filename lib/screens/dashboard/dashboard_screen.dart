import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_icons.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/responsive/responsive_utils.dart';
import '../../providers/patient_provider.dart';
import '../../providers/alert_provider.dart';
import '../../widgets/common/app_search_bar.dart';
import '../../widgets/common/shimmer_loading.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/patient/patient_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.screenPaddingH),
              child: _buildFilters(context),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildPatientList(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-patient'),
        icon: const Icon(AppIcons.add),
        label: const Text('Add Patient'),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(context.screenPaddingH, 24, context.screenPaddingH, 16),
      color: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.greeting('Dr. Lenin Babu'),
                      style: AppTypography.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'JIMPER, Puducherry • ICU Unit',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              _buildNotificationBadge(context),
              const SizedBox(width: 16),
              const CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary,
                child: Text('DS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Consumer<PatientProvider>(
            builder: (context, provider, _) => AppSearchBar(
              hintText: AppStrings.searchPatients,
              onChanged: provider.setSearchQuery,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBadge(BuildContext context) {
    return Consumer<AlertProvider>(
      builder: (context, alertProvider, _) {
        final unreadCount = alertProvider.unreadCount;
        return Stack(
          children: [
            IconButton(
              icon: const Icon(AppIcons.notification, size: 28),
              onPressed: () => context.push('/notifications'),
              color: Theme.of(context).iconTheme.color ?? AppColors.textPrimary,
            ),
            if (unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.critical,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Text(
                    unreadCount > 99 ? '99+' : unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFilters(BuildContext context) {
    final provider = context.watch<PatientProvider>();
    final filters = [
      AppStrings.allPatients,
      AppStrings.criticalFilter,
      AppStrings.warningFilter,
      AppStrings.stableFilter,
      AppStrings.offlineFilter
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = provider.currentFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? AppColors.textOnPrimary : Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              side: BorderSide.none,
              onSelected: (_) => provider.setFilter(filter),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPatientList(BuildContext context) {
    return Consumer<PatientProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: context.screenPaddingH),
            itemCount: 5,
            itemBuilder: (context, index) => const ShimmerCard(),
          );
        }

        if (provider.patients.isEmpty) {
          return EmptyState(
            title: AppStrings.noPatients,
            description: provider.searchQuery.isEmpty ? AppStrings.noPatientsDesc : 'No patients match your search criteria.',
            icon: AppIcons.patients,
          );
        }

        return RefreshIndicator(
          onRefresh: provider.refresh,
          color: AppColors.primary,
          child: ResponsiveLayout(
            mobile: (context, constraints) => ListView.builder(
              padding: EdgeInsets.only(
                left: context.screenPaddingH,
                right: context.screenPaddingH,
                bottom: 80, // FAB spacing
              ),
              itemCount: provider.patients.length,
              itemBuilder: (context, index) {
                final patient = provider.patients[index];
                return PatientCard(
                  patient: patient,
                  onTap: () => context.push('/monitoring/${patient.id}'),
                );
              },
            ),
            tablet: (context, constraints) => GridView.builder(
              padding: EdgeInsets.only(
                left: context.screenPaddingH,
                right: context.screenPaddingH,
                bottom: 80,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.gridColumns,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: 240,
              ),
              itemCount: provider.patients.length,
              itemBuilder: (context, index) {
                final patient = provider.patients[index];
                return PatientCard(
                  patient: patient,
                  onTap: () => context.push('/monitoring/${patient.id}'),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
