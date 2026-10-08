import 'package:flutter_bloc/flutter_bloc.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  ServicesBloc() : super(ServicesInitial()) {
    on<ServicesEvent>((event, emit) {
      // TODO: Implement event handler
    });
  }
}
