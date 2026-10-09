import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../domain/entities/dog.dart';
import '../bloc/dogs_bloc.dart';

class DogRegistrationSidebar extends StatefulWidget {
  final Dog? dogToEdit;
  final VoidCallback onClose;

  const DogRegistrationSidebar({
    super.key,
    this.dogToEdit,
    required this.onClose,
  });

  @override
  State<DogRegistrationSidebar> createState() => _DogRegistrationSidebarState();
}

class _DogRegistrationSidebarState extends State<DogRegistrationSidebar> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _petNameController;
  late TextEditingController _speciesController;
  late TextEditingController _breedController;
  late TextEditingController _ownerNameController;
  late TextEditingController _addressController;
  late TextEditingController _contactNumberController;

  late DogSex _selectedSex;
  late DateTime _selectedBirthdate;

  @override
  void initState() {
    super.initState();
    final dog = widget.dogToEdit;
    _petNameController = TextEditingController(text: dog?.petName ?? '');
    _speciesController = TextEditingController(text: dog?.species ?? 'Dog');
    _breedController = TextEditingController(text: dog?.breed ?? '');
    _ownerNameController = TextEditingController(text: dog?.ownerName ?? '');
    _addressController = TextEditingController(text: dog?.address ?? '');
    _contactNumberController = TextEditingController(
      text: dog?.contactNumber ?? '',
    );

    _selectedSex = dog?.sex ?? DogSex.male;
    _selectedBirthdate =
        dog?.birthdate ?? DateTime.now().subtract(const Duration(days: 365));
  }

  @override
  void dispose() {
    _petNameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _ownerNameController.dispose();
    _addressController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.dogToEdit != null;

    return Container(
      width: 460,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          left: BorderSide(
            color: isDarkMode ? AppColors.darkBorder : AppColors.border,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: AppDimensions.sidebarHeaderHeight,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing20,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDarkMode ? AppColors.darkBorder : AppColors.border,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Edit Dog Record' : 'Register New Dog',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(PhosphorIcons.x(PhosphorIconsStyle.bold)),
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),
          // Form Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.spacing24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _petNameController,
                      label: 'Pet Name *',
                      hint: 'e.g. Bruno',
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    _buildTextField(
                      controller: _speciesController,
                      label: 'Species *',
                      hint: 'e.g. Dog',
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    _buildTextField(
                      controller: _breedController,
                      label: 'Breed *',
                      hint: 'e.g. Askal / Aspin',
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    // Birthdate Picker
                    Text('Birthdate *', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppDimensions.spacing8),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedBirthdate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => _selectedBirthdate = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.spacing12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDarkMode
                                ? AppColors.darkBorder
                                : AppColors.border,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMedium,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat(
                                'yyyy-MM-dd',
                              ).format(_selectedBirthdate),
                              style: AppTextStyles.bodyMedium,
                            ),
                            Icon(
                              PhosphorIcons.calendar(PhosphorIconsStyle.bold),
                              size: AppDimensions.spacing20,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    // Sex Selector
                    Text('Sex *', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppDimensions.spacing8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<DogSex>(
                            title: const Text('Male'),
                            value: DogSex.male,
                            groupValue: _selectedSex,
                            onChanged: (val) =>
                                setState(() => _selectedSex = val!),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<DogSex>(
                            title: const Text('Female'),
                            value: DogSex.female,
                            groupValue: _selectedSex,
                            onChanged: (val) =>
                                setState(() => _selectedSex = val!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    _buildTextField(
                      controller: _ownerNameController,
                      label: 'Owner Name *',
                      hint: 'e.g. Juan Dela Cruz',
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    _buildTextField(
                      controller: _addressController,
                      label: 'Address *',
                      hint: 'e.g. Barangay Poblacion',
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    _buildTextField(
                      controller: _contactNumberController,
                      label: 'Contact Number *',
                      hint: 'e.g. +63 917 123 4567',
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Footer Buttons
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacing20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDarkMode ? AppColors.darkBorder : AppColors.border,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: widget.onClose,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final dog = Dog(
                        id:
                            widget.dogToEdit?.id ??
                            'DOG-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                        petName: _petNameController.text,
                        species: _speciesController.text,
                        breed: _breedController.text,
                        birthdate: _selectedBirthdate,
                        sex: _selectedSex,
                        ownerName: _ownerNameController.text,
                        address: _addressController.text,
                        contactNumber: _contactNumberController.text,
                        registeredAt:
                            widget.dogToEdit?.registeredAt ?? DateTime.now(),
                      );

                      if (isEditing) {
                        context.read<DogsBloc>().add(
                          AddDogRequested(dog),
                        ); // or update event
                      } else {
                        context.read<DogsBloc>().add(AddDogRequested(dog));
                      }
                      widget.onClose();
                    }
                  },
                  child: Text(isEditing ? 'Save Changes' : 'Register Dog'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelLarge),
        const SizedBox(height: AppDimensions.spacing8),
        TextFormField(
          controller: controller,
          validator: (val) =>
              val == null || val.isEmpty ? 'Field required' : null,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
              vertical: AppDimensions.spacing12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          ),
        ),
      ],
    );
  }
}
