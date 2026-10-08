import 'package:flutter_bloc/flutter_bloc.dart';

part 'dogs_event.dart';
part 'dogs_state.dart';

class DogsBloc extends Bloc<DogsEvent, DogsState> {
  DogsBloc() : super(DogsInitial()) {
    on<DogsEvent>((event, emit) {
      // TODO: Implement event handler
    });
  }
}
