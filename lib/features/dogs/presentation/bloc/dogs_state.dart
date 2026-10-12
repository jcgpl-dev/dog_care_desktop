part of 'dogs_bloc.dart';

enum DogsStatus { initial, loading, success, failure }

enum DogsFeedbackType { saved, deleted, error }

/// One-shot message for the UI (snackbar, close panel...).
///
/// Deliberately NOT Equatable and NOT const: every instance is unique, so
/// `previous.feedback != current.feedback` fires exactly once per message.
class DogsFeedback {
  DogsFeedback.saved(this.message) : type = DogsFeedbackType.saved;
  DogsFeedback.deleted(this.message) : type = DogsFeedbackType.deleted;
  DogsFeedback.error(this.message) : type = DogsFeedbackType.error;

  final DogsFeedbackType type;
  final String message;

  bool get isError => type == DogsFeedbackType.error;
}

/// Single state class. A failed add/update/delete no longer replaces the
/// loaded list with an error screen: data stays, [feedback] reports the error.
class DogsState extends Equatable {
  static const int pageSize = 10;

  const DogsState({
    this.status = DogsStatus.initial,
    this.dogs = const [],
    this.visibleDogs = const [],
    this.query = const DogsQuery(),
    this.page = 0,
    this.selectedDogIds = const {},
    this.isMutating = false,
    this.errorMessage,
    this.feedback,
  });

  final DogsStatus status;

  /// Source of truth.
  final List<Dog> dogs;

  /// Derived: [dogs] after search + filter + sort. Recomputed in [copyWith]
  /// only when [dogs] or [query] change.
  final List<Dog> visibleDogs;

  final DogsQuery query;
  final int page;
  final Set<String> selectedDogIds;
  final bool isMutating;
  final String? errorMessage;
  final DogsFeedback? feedback;

  int get pageCount =>
      visibleDogs.isEmpty ? 1 : (visibleDogs.length / pageSize).ceil();

  List<Dog> get pageDogs =>
      visibleDogs.skip(page * pageSize).take(pageSize).toList();

  DogsState copyWith({
    DogsStatus? status,
    List<Dog>? dogs,
    DogsQuery? query,
    int? page,
    Set<String>? selectedDogIds,
    bool? isMutating,
    String? errorMessage,
    DogsFeedback? feedback,
  }) {
    final nextDogs = dogs ?? this.dogs;
    final nextQuery = query ?? this.query;
    final nextVisible = (dogs != null || query != null)
        ? nextQuery.apply(nextDogs)
        : visibleDogs;
    final lastPage = nextVisible.isEmpty
        ? 0
        : (nextVisible.length - 1) ~/ pageSize;

    return DogsState(
      status: status ?? this.status,
      dogs: nextDogs,
      visibleDogs: nextVisible,
      query: nextQuery,
      page: (page ?? this.page).clamp(0, lastPage).toInt(),
      selectedDogIds: selectedDogIds ?? this.selectedDogIds,
      isMutating: isMutating ?? this.isMutating,
      errorMessage: errorMessage ?? this.errorMessage,
      feedback: feedback ?? this.feedback,
    );
  }

  @override
  List<Object?> get props => [
    status,
    dogs,
    query,
    page,
    selectedDogIds,
    isMutating,
    errorMessage,
    feedback,
  ];
}
