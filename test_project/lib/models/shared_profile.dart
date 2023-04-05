import 'package:test_project/models/user.dart';

class SharedProfile {
  final User user;
  final int viewCount;
  final DateTime date;

  SharedProfile(this.user, this.viewCount, this.date);
}

final sharedProfiles = [
  SharedProfile(
    users[2],
    7,
    DateTime(2023, 12, 8, 8, 30),
  ),
  SharedProfile(
    users[3],
    7,
    DateTime(2023, 12, 8, 8, 30),
  ),
  SharedProfile(
    users[4],
    7,
    DateTime(2023, 12, 8, 8, 30),
  ),
  SharedProfile(
    users[2],
    7,
    DateTime(2023, 12, 8, 8, 30),
  ),
  SharedProfile(
    users[3],
    7,
    DateTime(2023, 12, 8, 8, 30),
  )
];
