import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_management_event.dart';
part 'user_management_state.dart';

class UserManagementBloc extends Bloc<UserManagementEvent, UserManagementState> {
  UserManagementBloc() : super(UserManagementInitial()) {
    on<UserManagementEvent>((event, emit) {
      // TODO: Implement event handler
    });
  }
}
