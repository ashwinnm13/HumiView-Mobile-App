import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_icons.dart';
import '../../providers/monitoring_provider.dart';
import '../../widgets/heater/heater_status_card.dart';

class HeaterControlScreen extends StatelessWidget {
  const HeaterControlScreen({super.key, required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context) {
    // Ensure the provider has the correct patient (it should if accessed from Live Monitoring)
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcons.back),
          onPressed: () => context.pop(),
        ),
        title: const Text(AppStrings.heaterControl),
      ),
      body: Consumer<MonitoringProvider>(
        builder: (context, provider, _) {
          final patient = provider.currentPatient;
          
          if (patient == null || patient.id != patientId) {
            return const Center(child: Text('Patient data not available'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    HeaterStatusCard(
                      status: patient.heaterStatus,
                      onModeChanged: provider.setHeaterMode,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
