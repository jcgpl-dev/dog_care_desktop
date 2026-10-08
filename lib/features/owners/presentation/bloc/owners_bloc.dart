import 'package:flutter_bloc/flutter_bloc.dart';

part 'owners_event.dart';
part 'owners_state.dart';

class OwnersBloc extends Bloc<OwnersEvent, OwnersState> {
  OwnersBloc() : super(OwnersInitial()) {
    on<OwnersEvent>((event, emit) {
      // TODO: Implement event handler
    });
  }
}
