import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_icons.dart';
import '../../core/responsive/responsive_utils.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../widgets/common/app_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _imageUrl = '';

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _imageUrl = image.path;
      });
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Select Profile Photo',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: AppColors.primary),
                title: const Text('Open camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('Open files (Gallery)'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: context.screenPaddingH,
          right: context.screenPaddingH,
          top: 16,
          bottom: 80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileCard(),
            const SizedBox(height: 24),
            _buildSettingsSection(context),
            const SizedBox(height: 24),
            _buildLogoutButton(context),
            const SizedBox(height: 32),
            Center(
              child: Text(
                AppStrings.appVersion,
                style: AppTypography.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          GestureDetector(
            onTap: _showImageSourceActionSheet,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  backgroundImage: _imageUrl.isNotEmpty ? FileImage(File(_imageUrl)) : null,
                  child: _imageUrl.isEmpty ? const Text(
                    'DS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ) : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dr. Lenin Babu', style: AppTypography.headlineMedium),
                const SizedBox(height: 4),
                Text(
                  'Senior Pulmonologist',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(AppIcons.hospital, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'JIPMER',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(AppStrings.settings, style: AppTypography.titleLarge),
        ),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(AppIcons.notification, color: AppColors.primary),
                title: const Text('Push Notifications'),
                trailing: Switch(
                  value: true,
                  onChanged: (val) {},
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(
                  themeProvider.isDarkMode ? AppIcons.darkMode : AppIcons.lightMode,
                  color: AppColors.primary,
                ),
                title: const Text(AppStrings.themeToggle),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (val) => themeProvider.toggleTheme(),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(AppIcons.device, color: AppColors.primary),
                title: const Text(AppStrings.connectedDevices),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(AppIcons.aboutIcon, color: AppColors.primary),
                title: const Text(AppStrings.about),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      color: AppColors.criticalLight.withValues(alpha: 0.3),
      child: ListTile(
        leading: const Icon(AppIcons.logout, color: AppColors.critical),
        title: Text(
          AppStrings.logout,
          style: AppTypography.titleMedium.copyWith(color: AppColors.critical),
        ),
        onTap: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text(AppStrings.logoutConfirm),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: AppColors.critical),
                  child: const Text('Logout'),
                ),
              ],
            ),
          );

          if (confirm == true && context.mounted) {
            context.read<AuthProvider>().logout();
            context.go('/login');
          }
        },
      ),
    );
  }
}
