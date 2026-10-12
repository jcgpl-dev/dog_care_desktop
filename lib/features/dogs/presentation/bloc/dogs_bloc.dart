import 'package:dog_care_desktop/features/dogs/presentation/models/dogs_query.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/dog.dart';
import '../../domain/usecases/delete_dog.dart';
import '../../domain/usecases/get_dogs.dart';
import '../../domain/usecases/register_dog.dart';
import '../../domain/usecases/update_dog.dart';

part 'dogs_event.dart';
part 'dogs_state.dart';

/// Orchestrates use cases and holds list state.
/// Search / filter / sort rules live in [DogsQuery]; formatting lives in
/// utils; this class only decides WHEN state changes.
class DogsBloc extends Bloc<DogsEvent, DogsState> {
  DogsBloc({
    required this.getDogs,
    required this.registerDog,
    required this.updateDog,
    required this.deleteDog,
  }) : super(const DogsState()) {
    on<FetchDogsRequested>(_onFetch);
    on<AddDogRequested>(_onAdd);
    on<UpdateDogRequested>(_onUpdate);
    on<DeleteDogRequested>(_onDelete);
    on<DeleteSelectedDogsRequested>(_onDeleteSelected);
    on<SearchDogsQueryChanged>(_onSearch);
    on<DogsSexFilterChanged>(_onSexFilter);
    on<DogsSortChanged>(_onSort);
    on<DogsPageChanged>(_onPage);
    on<ToggleDogSelection>(_onToggleSelection);
    on<ToggleSelectAllDogs>(_onToggleSelectAll);
    on<ClearDogSelections>(_onClearSelection);
  }

  final GetDogs getDogs;
  final RegisterDog registerDog;
  final UpdateDog updateDog;
  final DeleteDog deleteDog;

  bool get _canMutate =>
      state.status == DogsStatus.success && !state.isMutating;

  // ── Data ──────────────────────────────────────────────────────────────
  Future<void> _onFetch(
    FetchDogsRequested event,
    Emitter<DogsState> emit,
  ) async {
    emit(state.copyWith(status: DogsStatus.loading));
    final result = await getDogs(NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DogsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (dogs) => emit(
        state.copyWith(
          status: DogsStatus.success,
          dogs: dogs,
          selectedDogIds: const {},
          page: 0,
        ),
      ),
    );
  }

  Future<void> _onAdd(AddDogRequested event, Emitter<DogsState> emit) async {
    if (!_canMutate) return;
    emit(state.copyWith(isMutating: true));

    final result = await registerDog(event.dog);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isMutating: false,
          feedback: DogsFeedback.error(failure.message),
        ),
      ),
      (created) => emit(
        state.copyWith(
          dogs: [created, ...state.dogs],
          isMutating: false,
          feedback: DogsFeedback.saved('Dog registered'),
        ),
      ),
    );
  }

  Future<void> _onUpdate(
    UpdateDogRequested event,
    Emitter<DogsState> emit,
  ) async {
    if (!_canMutate) return;
    emit(state.copyWith(isMutating: true));

    final result = await updateDog(event.dog);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isMutating: false,
          feedback: DogsFeedback.error(failure.message),
        ),
      ),
      (updated) => emit(
        state.copyWith(
          dogs: [for (final d in state.dogs) d.id == updated.id ? updated : d],
          isMutating: false,
          feedback: DogsFeedback.saved('Changes saved'),
        ),
      ),
    );
  }

  Future<void> _onDelete(DeleteDogRequested event, Emitter<DogsState> emit) =>
      _deleteMany([event.dogId], emit);

  Future<void> _onDeleteSelected(
    DeleteSelectedDogsRequested event,
    Emitter<DogsState> emit,
  ) => _deleteMany(state.selectedDogIds, emit);

  Future<void> _deleteMany(
    Iterable<String> ids,
    Emitter<DogsState> emit,
  ) async {
    final targets = ids.toList();
    if (targets.isEmpty || !_canMutate) return;
    emit(state.copyWith(isMutating: true));

    final outcomes = await Future.wait(
      targets.map((id) async {
        final result = await deleteDog(id);
        return (id: id, ok: result.fold((_) => false, (_) => true));
      }),
    );

    final deleted = {
      for (final outcome in outcomes)
        if (outcome.ok) outcome.id,
    };
    final failedCount = targets.length - deleted.length;

    emit(
      state.copyWith(
        dogs: state.dogs.where((d) => !deleted.contains(d.id)).toList(),
        selectedDogIds: state.selectedDogIds.difference(deleted),
        isMutating: false,
        feedback: failedCount == 0
            ? DogsFeedback.deleted(
                deleted.length == 1
                    ? 'Dog record deleted'
                    : '${deleted.length} dog records deleted',
              )
            : DogsFeedback.error(
                '$failedCount of ${targets.length} records could not be deleted',
              ),
      ),
    );
  }

  // ── Query ─────────────────────────────────────────────────────────────
  void _onSearch(SearchDogsQueryChanged event, Emitter<DogsState> emit) {
    emit(
      state.copyWith(query: state.query.copyWith(search: event.query), page: 0),
    );
  }

  void _onSexFilter(DogsSexFilterChanged event, Emitter<DogsState> emit) {
    emit(
      state.copyWith(
        query: state.query.copyWith(sexFilter: event.filter),
        page: 0,
      ),
    );
  }

  void _onSort(DogsSortChanged event, Emitter<DogsState> emit) {
    final sameField = state.query.sortField == event.field;
    emit(
      state.copyWith(
        query: state.query.copyWith(
          sortField: event.field,
          ascending: sameField ? !state.query.ascending : true,
        ),
        page: 0,
      ),
    );
  }

  void _onPage(DogsPageChanged event, Emitter<DogsState> emit) {
    emit(state.copyWith(page: event.page));
  }

  // ── Selection ─────────────────────────────────────────────────────────
  void _onToggleSelection(ToggleDogSelection event, Emitter<DogsState> emit) {
    final next = Set<String>.of(state.selectedDogIds);
    if (!next.remove(event.dogId)) next.add(event.dogId);
    emit(state.copyWith(selectedDogIds: next));
  }

  void _onToggleSelectAll(ToggleSelectAllDogs event, Emitter<DogsState> emit) {
    final pageIds = state.pageDogs.map((d) => d.id).toSet();
    final allSelected =
        pageIds.isNotEmpty && state.selectedDogIds.containsAll(pageIds);
    emit(
      state.copyWith(
        selectedDogIds: allSelected
            ? state.selectedDogIds.difference(pageIds)
            : {...state.selectedDogIds, ...pageIds},
      ),
    );
  }

  void _onClearSelection(ClearDogSelections event, Emitter<DogsState> emit) {
    emit(state.copyWith(selectedDogIds: const {}));
  }
}
