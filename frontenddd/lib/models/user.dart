class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final int loginStreak;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.loginStreak,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      loginStreak: json['login_streak'] ?? 0,
    );
  }
}
