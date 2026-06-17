import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_icons.dart';
import '../../core/utils/validators.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/responsive/responsive_utils.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'doctor@hospital.com');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final auth = context.read<AuthProvider>();
      final success = await auth.login(
        _emailController.text,
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(auth.error ?? 'Login failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationResponsiveLayout(
        portrait: _buildPortrait(context),
        landscape: _buildLandscape(context),
      ),
    );
  }

  Widget _buildPortrait(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: context.screenHeight,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Center(child: _buildBranding()),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: _buildLoginForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLandscape(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            decoration: const BoxDecoration(gradient: AppColors.splashGradient),
            child: Center(child: _buildBranding()),
          ),
        ),
        Expanded(
          flex: 5,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: AppCard(
                  padding: const EdgeInsets.all(40),
                  child: _buildLoginForm(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBranding() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(AppIcons.shield, size: 64, color: AppColors.surface),
        ),
        const SizedBox(height: 24),
        Text(
          AppStrings.appName,
          style: AppTypography.displayMedium.copyWith(color: AppColors.surface),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.tagline,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.surface.withValues(alpha: 0.8)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    final auth = context.watch<AuthProvider>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.welcomeBack,
            style: AppTypography.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.loginSubtitle,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          AppTextField(
            label: AppStrings.email,
            controller: _emailController,
            hint: AppStrings.emailHint,
            prefixIcon: AppIcons.email,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          AppTextField(
            label: AppStrings.password,
            controller: _passwordController,
            hint: AppStrings.passwordHint,
            prefixIcon: AppIcons.lock,
            obscureText: _obscurePassword,
            validator: Validators.password,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? AppIcons.visibilityOff : AppIcons.visibility),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: auth.rememberMe,
                    onChanged: (val) => auth.setRememberMe(val ?? false),
                    activeColor: AppColors.primary,
                  ),
                  Text(AppStrings.rememberMe, style: AppTypography.bodyMedium),
                ],
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                child: const Text(AppStrings.forgotPassword),
              ),
            ],
          ),
          const SizedBox(height: 32),
          AppButton(
            text: AppStrings.login,
            onPressed: _handleLogin,
            isLoading: auth.isLoading,
          ),
        ],
      ),
    );
  }
}
