import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/patient_provider.dart';
import 'providers/monitoring_provider.dart';
import 'providers/alert_provider.dart';
import 'providers/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProxyProvider<PatientProvider, AlertProvider>(
          create: (context) => AlertProvider(context.read<PatientProvider>()),
          update: (context, patientProvider, previous) {
            if (previous != null) {
              previous.updatePatientProvider(patientProvider);
              return previous;
            }
            return AlertProvider(patientProvider);
          },
        ),
        ChangeNotifierProxyProvider<PatientProvider, MonitoringProvider>(
          create: (context) => MonitoringProvider(context.read<PatientProvider>()),
          update: (context, patientProvider, previous) =>
              previous ?? MonitoringProvider(patientProvider),
        ),
      ],
      child: const HumiViewApp(),
    ),
  );
}
