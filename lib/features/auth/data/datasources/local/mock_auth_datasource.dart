import 'package:dog_care_desktop/features/auth/domain/entities/user.dart';

import '../../models/user_model.dart';

class MockAuthDataSource {
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    //delay.
    await Future.delayed(const Duration(milliseconds: 800));

    if (username == 'admin' && password == 'admin123') {
      return const UserModel(
        id: 1,
        username: 'admin',
        name: 'System Administrator',
        role: UserRole.admin,
      );
    }

    if (username == 'staff' && password == 'staff123') {
      return const UserModel(
        id: 2,
        username: 'staff',
        name: 'Municipal Agriculture Staff',
        role: UserRole.staff,
      );
    }

    throw Exception('Invalid username or password.');
  }
}
