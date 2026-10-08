import 'package:flutter_bloc/flutter_bloc.dart';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsBloc() : super(ReportsInitial()) {
    on<ReportsEvent>((event, emit) {
      // TODO: Implement event handler
    });
  }
}
