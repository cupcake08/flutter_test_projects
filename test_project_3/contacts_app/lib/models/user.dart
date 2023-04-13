import 'dart:convert';

User userFromJson(String body) {
  final data = json.decode(body) as Map;
  final tempUserData = data['foundUser'] as Map<String, dynamic>;
  tempUserData['authToken'] = data['authToken'];
  return User.fromJson(tempUserData);
}

class User {
  final String name;
  final String email;
  final String? authToken;

  User({
    required this.name,
    required this.email,
    this.authToken,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        email: json['email'],
        authToken: json['authToken'],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
      };
}
