import 'package:equatable/equatable.dart';

enum UserRole { admin, staff }

class User extends Equatable {
  final int id;
  final String username;
  final String name;
  final UserRole role;

  const User({
    required this.id,
    required this.username,
    required this.name,
    required this.role,
  });

  @override
  List<Object?> get props => [id, username, name, role];
}