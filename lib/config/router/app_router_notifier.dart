import 'dart:async';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';

class AppRouterNotifier extends ChangeNotifier {
  final AuthBloc _authBloc;
  late final StreamSubscription<AuthState> _subscription;

  AppRouterNotifier(this._authBloc) {
    _subscription = _authBloc.stream.listen((_) {
      notifyListeners();
    });
  }

  AuthState get state => _authBloc.state;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
