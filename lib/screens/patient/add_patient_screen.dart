import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_icons.dart';
import '../../providers/patient_provider.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _wardController = TextEditingController();
  final _deviceController = TextEditingController();
  bool _isSubmitting = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    _wardController.dispose();
    _deviceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    final provider = context.read<PatientProvider>();
    final success = await provider.addPatient(
      name: _nameController.text.trim(),
      roomNumber: _wardController.text.trim(),
      deviceId: _deviceController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient added successfully')),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Failed to add patient'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Patient'),
        leading: IconButton(
          icon: const Icon(AppIcons.back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primarySurface,
                      child: const Icon(Icons.person, size: 50, color: AppColors.primary),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.surface, width: 2),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                          onPressed: () {
                            // Mock image picker
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Image picker mocked')),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Patient Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _wardController,
                decoration: const InputDecoration(
                  labelText: 'Ward / Room Number',
                  prefixIcon: Icon(AppIcons.room),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter ward details' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deviceController,
                decoration: const InputDecoration(
                  labelText: 'Device Name (ESP32 ID)',
                  prefixIcon: Icon(AppIcons.device),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a device ID' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Add Patient'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
