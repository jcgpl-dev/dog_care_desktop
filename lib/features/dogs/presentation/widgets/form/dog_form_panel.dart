import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/config/theme/app_text_styles.dart';
import 'package:dog_care_desktop/core/presentation/widgets/buttons/app_button.dart';
import 'package:dog_care_desktop/core/presentation/widgets/inputs/app_avatar_picker.dart';
import 'package:dog_care_desktop/core/presentation/widgets/inputs/app_text_field.dart';
import 'package:dog_care_desktop/features/dogs/presentation/utils/dog_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../domain/entities/dog.dart';
import '../../utils/dog_id_generator.dart';
import '../../utils/dog_validators.dart';
import 'dog_birthdate_field.dart';
import 'dog_sex_selector.dart';

class DogFormPanel extends StatefulWidget {
  const DogFormPanel({
    super.key,
    this.dogToEdit,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onClose,
  });

  final Dog? dogToEdit;
  final bool isSubmitting;
  final ValueChanged<Dog> onSubmit;
  final VoidCallback onClose;

  @override
  State<DogFormPanel> createState() => _DogFormPanelState();
}

class _DogFormPanelState extends State<DogFormPanel> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _petName;
  late final TextEditingController _breed;
  late final TextEditingController _ownerName;
  late final TextEditingController _address;
  late final TextEditingController _contactNumber;

  DateTime? _birthdate;
  DogSex? _sex;
  String? _photoUrl;
  bool get _isEditing => widget.dogToEdit != null;

  @override
  void initState() {
    super.initState();
    final dog = widget.dogToEdit;
    _petName = TextEditingController(text: dog?.petName ?? '');
    _breed = TextEditingController(text: dog?.breed ?? '');
    _ownerName = TextEditingController(text: dog?.ownerName ?? '');
    _address = TextEditingController(text: dog?.address ?? '');
    _contactNumber = TextEditingController(text: dog?.contactNumber ?? '');
    _birthdate = dog?.birthdate;
    _sex = dog?.sex;
    _photoUrl = dog?.photoUrl;
  }

  @override
  void dispose() {
    _petName.dispose();
    _breed.dispose();
    _ownerName.dispose();
    _address.dispose();
    _contactNumber.dispose();
    super.dispose();
  }

  void _submit() {
    if (widget.isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    final existing = widget.dogToEdit;
    widget.onSubmit(
      Dog(
        id: existing?.id ?? DogIdGenerator.next(),
        petName: _petName.text.trim(),
        breed: _breed.text.trim(),
        birthdate: _birthdate!,
        sex: _sex!,
        ownerName: _ownerName.text.trim(),
        address: _address.text.trim(),
        contactNumber: _contactNumber.text.trim(),
        registeredAt: existing?.registeredAt ?? DateTime.now(),
        photoUrl: _photoUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    const gap = SizedBox(height: AppDimensions.spacing16);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): widget.onClose,
      },
      child: Container(
        width: 460,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(left: BorderSide(color: borderColor)),
        ),
        child: Column(
          children: [
            _Header(
              title: _isEditing ? 'Edit Dog Record' : 'Register New Dog',
              subtitle: widget.dogToEdit == null
                  ? null
                  : '${widget.dogToEdit!.id} · Registered ${DogFormatters.date(widget.dogToEdit!.registeredAt)}',
              borderColor: borderColor,
              onClose: widget.onClose,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.spacing24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppAvatarPicker(
                        imagePath: _photoUrl,
                        onChanged: (p) => setState(() => _photoUrl = p),
                      ),
                      const SizedBox(height: AppDimensions.spacing24),
                      const _SectionTitle('Pet details'),
                      AppTextField(
                        controller: _petName,
                        label: 'Pet Name *',
                        hint: 'e.g. Bruno',
                        validator: DogValidators.required('Pet name'),
                      ),
                      gap,
                      AppTextField(
                        controller: _breed,
                        label: 'Breed *',
                        hint: 'e.g. Askal / Aspin',
                        validator: DogValidators.required('Breed'),
                      ),
                      gap,
                      DogBirthdateField(
                        value: _birthdate,
                        onChanged: (v) => setState(() => _birthdate = v),
                      ),
                      gap,
                      DogSexSelector(value: _sex, onChanged: (v) => _sex = v),
                      const SizedBox(height: AppDimensions.spacing24),
                      const _SectionTitle('Owner details'),
                      AppTextField(
                        controller: _ownerName,
                        label: 'Owner Name *',
                        hint: 'e.g. Juan Dela Cruz',
                        validator: DogValidators.required('Owner name'),
                      ),
                      gap,
                      AppTextField(
                        controller: _address,
                        label: 'Address *',
                        hint: 'e.g. Barangay Poblacion',
                        validator: DogValidators.required('Address'),
                      ),
                      gap,
                      AppTextField(
                        controller: _contactNumber,
                        label: 'Contact Number *',
                        hint: 'e.g. +63 917 123 4567',
                        keyboardType: TextInputType.phone,
                        validator: DogValidators.phone,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing20),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: borderColor)),
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
                      label: widget.isSubmitting
                          ? 'Saving...'
                          : (_isEditing ? 'Save Changes' : 'Register Dog'),
                      variant: AppButtonVariant.primary,
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.subtitle,
    required this.borderColor,
    required this.onClose,
  });

  final String title;
  final String? subtitle;
  final Color borderColor;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.sidebarHeaderHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Close (Esc)',
            icon: Icon(PhosphorIcons.x(PhosphorIconsStyle.bold)),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacing16),
      child: Text(
        text,
        style: AppTextStyles.titleSmall.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
