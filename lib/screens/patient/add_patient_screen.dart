import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_icons.dart';
import '../../providers/patient_provider.dart';
import '../../data/models/patient.dart';

class AddPatientScreen extends StatefulWidget {
  final Patient? patient;
  const AddPatientScreen({super.key, this.patient});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _wardController = TextEditingController();
  final _deviceController = TextEditingController();
  DateTime? _admissionDate;
  String _imageUrl = '';
  bool _isSubmitting = false;
  
  @override
  void initState() {
    super.initState();
    if (widget.patient != null) {
      final p = widget.patient!;
      _nameController.text = p.name;
      _ageController.text = p.age?.toString() ?? '';
      _wardController.text = p.roomNumber;
      _deviceController.text = p.deviceId;
      _admissionDate = p.admissionDate;
      _imageUrl = p.imageUrl;
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _wardController.dispose();
    _deviceController.dispose();
    super.dispose();
  }

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
                  'Select Photo',
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

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    final provider = context.read<PatientProvider>();
    bool success;
    if (widget.patient != null) {
      success = await provider.updatePatientInfo(
        id: widget.patient!.id,
        name: _nameController.text.trim(),
        age: int.tryParse(_ageController.text.trim()),
        admissionDate: _admissionDate,
        imageUrl: _imageUrl,
        roomNumber: _wardController.text.trim(),
        deviceId: _deviceController.text.trim(),
      );
    } else {
      success = await provider.addPatient(
        name: _nameController.text.trim(),
        age: int.tryParse(_ageController.text.trim()),
        admissionDate: _admissionDate,
        imageUrl: _imageUrl,
        roomNumber: _wardController.text.trim(),
        deviceId: _deviceController.text.trim(),
      );
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.patient != null ? 'Patient updated successfully' : 'Patient added successfully')),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? (widget.patient != null ? 'Failed to update patient' : 'Failed to add patient')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.patient != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Patient' : 'Add Patient'),
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
                      backgroundImage: _imageUrl.isNotEmpty ? FileImage(File(_imageUrl)) : null,
                      child: _imageUrl.isEmpty ? const Icon(Icons.person, size: 50, color: AppColors.primary) : null,
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
                          onPressed: _showImageSourceActionSheet,
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
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.cake_outlined),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _admissionDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _admissionDate = date);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Admission Date',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    _admissionDate != null
                        ? '${_admissionDate!.day.toString().padLeft(2, '0')}/${_admissionDate!.month.toString().padLeft(2, '0')}/${_admissionDate!.year}'
                        : 'Select Date',
                    style: TextStyle(
                      color: _admissionDate != null ? null : Theme.of(context).hintColor,
                    ),
                  ),
                ),
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
                    : Text(isEditing ? 'Update Patient' : 'Add Patient'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
