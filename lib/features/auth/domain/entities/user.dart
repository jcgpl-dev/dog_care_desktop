enum UserRole { admin, staff }

class User {
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
}
