class User {
  final String name;
  final String imageUrl;
  final Gender gender;
  final String city;
  final String country;
  final DateTime dob;

  User(
    this.name,
    this.imageUrl,
    this.gender,
    this.city,
    this.country,
    this.dob,
  );
}

enum Gender {
  male,
  female,
}

final List<User> users = [
  User(
    "Ankit",
    "https://images.unsplash.com/flagged/photo-1570612861542-284f4c12e75f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cGVyc29ufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    Gender.male,
    "London",
    "United Kingdom",
    DateTime(2002, 6, 9),
  ),
  User(
    "Kate Brown",
    "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    Gender.female,
    "London",
    "United Kingdom",
    DateTime(2002, 6, 9),
  ),
  User(
    "Michael Simpson",
    "https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8cGVyc29ufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    Gender.male,
    "London",
    "United Kingdom",
    DateTime(2002, 6, 9),
  ),
  User(
    "Anna Kowalsky",
    "https://images.unsplash.com/photo-1499952127939-9bbf5af6c51c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fHBlcnNvbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
    Gender.female,
    "London",
    "United Kingdom",
    DateTime(2002, 6, 9),
  ),
  User(
    "Kate Brown",
    "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    Gender.female,
    "London",
    "United Kingdom",
    DateTime(2002, 6, 9),
  ),
  User(
    "Michael Simpson",
    "https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8cGVyc29ufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    Gender.male,
    "London",
    "United Kingdom",
    DateTime(2002, 6, 9),
  ),
  User(
    "Anna Kowalsky",
    "https://images.unsplash.com/photo-1499952127939-9bbf5af6c51c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fHBlcnNvbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
    Gender.female,
    "London",
    "United Kingdom",
    DateTime(2002, 6, 9),
  ),
];
