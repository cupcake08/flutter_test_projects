// userFromJson()

class User {
  final String name;
  final String email;
  final String id;

  User(this.id, this.name, this.email);

  factory User.fromJson(Map<String, dynamic> json) => User(
        json['id'],
        json['name'],
        json['email'],
      );
}
