import 'package:dog_care_desktop/features/auth/domain/entities/user.dart';

import '../auth_datasource.dart';
import '../../models/user_model.dart';

class MockAuthDataSource implements AuthDataSource {
  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (username == 'admin' && password == 'admin123') {
      return const UserModel(
        id: 1,
        username: 'admin',
        name: 'System Administrator',
        role: UserRole.admin,
      );
    }
    throw Exception('Invalid username or password.');
  }
}
