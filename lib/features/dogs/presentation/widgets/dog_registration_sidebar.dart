import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/presentation/widgets/buttons/app_button.dart';
import '../../../../core/presentation/widgets/inputs/app_text_field.dart';
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
    _breedController.dispose();
    _ownerNameController.dispose();
    _addressController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Field is required';
    }
    return null;
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
                    AppTextField(
                      controller: _petNameController,
                      label: 'Pet Name *',
                      hint: 'e.g. Bruno',
                      validator: _requiredValidator,
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    AppTextField(
                      controller: _breedController,
                      label: 'Breed *',
                      hint: 'e.g. Askal / Aspin',
                      validator: _requiredValidator,
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    // Birthdate Picker
                    Text('Birthdate *', style: AppTextStyles.labelMedium),
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
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSmall,
                      ),
                      child: Container(
                        height: AppDimensions.buttonHeight,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing16,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.darkFieldBackground
                              : AppColors.surface,
                          border: Border.all(
                            color: isDarkMode
                                ? AppColors.darkBorder
                                : AppColors.border,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSmall,
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
                    Text('Sex *', style: AppTextStyles.labelMedium),
                    const SizedBox(height: AppDimensions.spacing8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<DogSex>(
                            title: const Text('Male'),
                            value: DogSex.male,
                            groupValue: _selectedSex,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) =>
                                setState(() => _selectedSex = val!),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<DogSex>(
                            title: const Text('Female'),
                            value: DogSex.female,
                            groupValue: _selectedSex,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) =>
                                setState(() => _selectedSex = val!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    AppTextField(
                      controller: _ownerNameController,
                      label: 'Owner Name *',
                      hint: 'e.g. Juan Dela Cruz',
                      validator: _requiredValidator,
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    AppTextField(
                      controller: _addressController,
                      label: 'Address *',
                      hint: 'e.g. Barangay Poblacion',
                      validator: _requiredValidator,
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    AppTextField(
                      controller: _contactNumberController,
                      label: 'Contact Number *',
                      hint: 'e.g. +63 917 123 4567',
                      keyboardType: TextInputType.phone,
                      validator: _requiredValidator,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Footer Buttons using AppButton
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
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Cancel',
                    variant: AppButtonVariant.outlined,
                    onPressed: widget.onClose,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: AppButton(
                    label: isEditing ? 'Save Changes' : 'Register Dog',
                    variant: AppButtonVariant.primary,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final dog = Dog(
                          id:
                              widget.dogToEdit?.id ??
                              'DOG-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                          petName: _petNameController.text,
                          breed: _breedController.text,
                          birthdate: _selectedBirthdate,
                          sex: _selectedSex,
                          ownerName: _ownerNameController.text,
                          address: _addressController.text,
                          contactNumber: _contactNumberController.text,
                          registeredAt:
                              widget.dogToEdit?.registeredAt ?? DateTime.now(),
                        );

                        context.read<DogsBloc>().add(AddDogRequested(dog));
                        widget.onClose();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
