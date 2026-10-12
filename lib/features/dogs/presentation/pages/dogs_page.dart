import 'dart:math' as math;

import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/features/dogs/presentation/widgets/dialogs/confirm_delete_dialog.dart';
import 'package:dog_care_desktop/features/dogs/presentation/widgets/form/dog_form_panel.dart';
import 'package:dog_care_desktop/features/dogs/presentation/widgets/metrics/dogs_metric_cards.dart';
import 'package:dog_care_desktop/features/dogs/presentation/widgets/states/dogs_empty_state.dart';
import 'package:dog_care_desktop/features/dogs/presentation/widgets/states/dogs_error_state.dart';
import 'package:dog_care_desktop/features/dogs/presentation/widgets/states/dogs_loading_skeleton.dart';
import 'package:dog_care_desktop/features/dogs/presentation/widgets/table/dogs_pagination_bar.dart';
import 'package:dog_care_desktop/features/dogs/presentation/widgets/table/dogs_selection_bar.dart';
import 'package:dog_care_desktop/features/dogs/presentation/widgets/table/dogs_table.dart';
import 'package:dog_care_desktop/features/dogs/presentation/widgets/toolbar/dogs_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/dog.dart';
import '../bloc/dogs_bloc.dart';
import '../models/dogs_metrics.dart';

/// Composition root for the screen: wires BLoC <-> widgets, owns the
/// side-panel open/closed state, and asks for confirmation before deleting.
/// It contains no styling, filtering, or formatting logic.
class DogsPage extends StatefulWidget {
  const DogsPage({super.key});

  @override
  State<DogsPage> createState() => _DogsPageState();
}

class _DogsPageState extends State<DogsPage> {
  bool _isPanelOpen = false;
  Dog? _dogToEdit;

  DogsBloc get _bloc => context.read<DogsBloc>();

  @override
  void initState() {
    super.initState();
    _bloc.add(const FetchDogsRequested());
  }

  // ── Panel ─────────────────────────────────────────────────────────────
  void _openPanel([Dog? dog]) => setState(() {
    _dogToEdit = dog;
    _isPanelOpen = true;
  });

  void _closePanel() => setState(() {
    _isPanelOpen = false;
    _dogToEdit = null;
  });

  void _submit(Dog dog) {
    _bloc.add(
      _dogToEdit == null ? AddDogRequested(dog) : UpdateDogRequested(dog),
    );
  }

  // ── Feedback ──────────────────────────────────────────────────────────
  void _onFeedback(BuildContext context, DogsState state) {
    final feedback = state.feedback!;
    if (feedback.type == DogsFeedbackType.saved) _closePanel();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          width: 420,
          behavior: SnackBarBehavior.floating,
          backgroundColor: feedback.isError ? AppColors.error : null,
          content: Text(feedback.message),
        ),
      );
  }

  // ── Destructive actions always confirm ────────────────────────────────
  Future<void> _confirmDelete(Dog dog) async {
    final confirmed = await showConfirmDeleteDialog(
      context,
      count: 1,
      singleLabel: dog.petName,
    );
    if (!confirmed || !mounted) return;
    if (_dogToEdit?.id == dog.id) _closePanel();
    _bloc.add(DeleteDogRequested(dog.id));
  }

  Future<void> _confirmDeleteSelected(int count) async {
    final confirmed = await showConfirmDeleteDialog(context, count: count);
    if (!confirmed || !mounted) return;
    _bloc.add(const DeleteSelectedDogsRequested());
  }

  // ── Build ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocListener<DogsBloc, DogsState>(
      listenWhen: (previous, current) =>
          current.feedback != null && previous.feedback != current.feedback,
      listener: _onFeedback,
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing16),
                child: BlocBuilder<DogsBloc, DogsState>(builder: _buildContent),
              ),
            ),
            if (_isPanelOpen)
              BlocSelector<DogsBloc, DogsState, bool>(
                selector: (state) => state.isMutating,
                builder: (context, isMutating) => DogFormPanel(
                  key: ValueKey(_dogToEdit?.id ?? 'new'),
                  dogToEdit: _dogToEdit,
                  isSubmitting: isMutating,
                  onSubmit: _submit,
                  onClose: _closePanel,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, DogsState state) {
    const gap = SizedBox(height: AppDimensions.spacing16);

    final content = Column(
      children: [
        if (state.status == DogsStatus.success) ...[
          DogsMetricCards(metrics: DogsMetrics.from(state.dogs)),
          gap,
        ],
        DogsToolbar(
          sexFilter: state.query.sexFilter,
          onSearchChanged: (q) => _bloc.add(SearchDogsQueryChanged(q)),
          onSexFilterChanged: (f) => _bloc.add(DogsSexFilterChanged(f)),
          onRegisterPressed: _openPanel,
        ),
        gap,
        Expanded(child: _buildList(context, state)),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        const minHeight = 600.0;
        return SingleChildScrollView(
          child: SizedBox(
            height: math.max(constraints.maxHeight, minHeight),
            child: content,
          ),
        );
      },
    );
  }

  Widget _buildList(BuildContext context, DogsState state) {
    switch (state.status) {
      case DogsStatus.initial:
      case DogsStatus.loading:
        return const DogsLoadingSkeleton();

      case DogsStatus.failure:
        return DogsErrorState(
          message: state.errorMessage ?? 'Something went wrong.',
          onRetry: () => _bloc.add(const FetchDogsRequested()),
        );

      case DogsStatus.success:
        if (state.visibleDogs.isEmpty) {
          return DogsEmptyState(
            isFiltering: state.query.isFiltering,
            onRegister: _openPanel,
          );
        }

        return Stack(
          children: [
            Positioned.fill(
              child: DogsTable(
                dogs: state.pageDogs,
                selectedDogIds: state.selectedDogIds,
                sortField: state.query.sortField,
                ascending: state.query.ascending,
                onSort: (field) => _bloc.add(DogsSortChanged(field)),
                onToggleSelection: (id) => _bloc.add(ToggleDogSelection(id)),
                onToggleSelectAll: () => _bloc.add(const ToggleSelectAllDogs()),
                onOpen: _openPanel,
                onDelete: _confirmDelete,
                footer: DogsPaginationBar(
                  page: state.page,
                  pageSize: DogsState.pageSize,
                  totalItems: state.visibleDogs.length,
                  onPageChanged: (p) => _bloc.add(DogsPageChanged(p)),
                ),
              ),
            ),
            if (state.selectedDogIds.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 72,
                child: Center(
                  child: DogsSelectionBar(
                    count: state.selectedDogIds.length,
                    onDelete: () =>
                        _confirmDeleteSelected(state.selectedDogIds.length),
                    onClear: () => _bloc.add(const ClearDogSelections()),
                  ),
                ),
              ),
          ],
        );
    }
  }
}
