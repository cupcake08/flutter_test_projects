import 'dart:convert';

User userFromJson(String body) {
  final data = json.decode(body);
  final tempUserData = data['foundUser'] as Map<String, dynamic>;
  tempUserData['authToken'] = data['authToken'];
  return User.fromJson(tempUserData);
}

class User {
  final String name;
  final String email;
  final String authToken;

  User(this.name, this.email, this.authToken);

  factory User.fromJson(Map<String, dynamic> json) => User(
        json['name'],
        json['email'],
        json['authToken'],
      );
}
