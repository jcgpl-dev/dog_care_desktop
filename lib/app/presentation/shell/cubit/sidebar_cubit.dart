import 'package:flutter_bloc/flutter_bloc.dart';

class SidebarCubit extends Cubit<bool> {
  // Initial state
  SidebarCubit() : super(false);

  void toggleSidebar() => emit(!state);
  void collapse() => emit(true);
  void expand() => emit(false);
}
