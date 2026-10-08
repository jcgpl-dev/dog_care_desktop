import 'package:flutter_bloc/flutter_bloc.dart';

part 'alerts_event.dart';
part 'alerts_state.dart';

class AlertsBloc extends Bloc<AlertsEvent, AlertsState> {
  AlertsBloc() : super(AlertsInitial()) {
    on<AlertsEvent>((event, emit) {
      // TODO: Implement event handler
    });
  }
}
