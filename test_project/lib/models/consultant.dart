import 'package:test_project/models/models.dart';

class Consultant {
  final User user;
  final bool active;
  final DateTime time;

  Consultant(this.user, this.active, this.time);
}

final List<Consultant> consultants = [
  Consultant(
    users[2],
    true,
    DateTime(DateTime.now().year, 12, 8, 17, 45),
  ),
  Consultant(
    users[1],
    false,
    DateTime(DateTime.now().year, 12, 9, 8, 30),
  ),
  Consultant(
    users[3],
    false,
    DateTime(DateTime.now().year, 12, 10, 9, 45),
  )
];
