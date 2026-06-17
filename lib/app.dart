import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'navigation/app_router.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';

class HumiViewApp extends StatelessWidget {
  const HumiViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ThemeProvider>(
      builder: (context, authProvider, themeProvider, _) {
        final router = AppRouter.createRouter(authProvider);

        return MaterialApp.router(
          title: 'HumiView',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          // If dark mode is implemented in AppTheme, we can use it here
          // darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          routerConfig: router,
        );
      },
    );
  }
}
