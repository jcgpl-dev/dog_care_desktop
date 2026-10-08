import 'package:flutter_bloc/flutter_bloc.dart';

part 'health_records_event.dart';
part 'health_records_state.dart';

class HealthRecordsBloc extends Bloc<HealthRecordsEvent, HealthRecordsState> {
  HealthRecordsBloc() : super(HealthRecordsInitial()) {
    on<HealthRecordsEvent>((event, emit) {
      // TODO: Implement event handler
    });
  }
}
