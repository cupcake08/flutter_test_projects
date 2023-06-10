import 'package:isar/isar.dart';
import 'package:pet_adoption_app/utils/utils.dart';

part 'pet.g.dart';

@collection
class Pet {
  Id id = Isar.autoIncrement;

  @Index(caseSensitive: false, type: IndexType.value)
  late String name;

  late String breed;

  @Index()
  @enumerated
  late PetType type;

  @enumerated
  late Gender gender;

  late String image;
  late DateTime birthDate;
  late String ownerName;
  late DateTime publishDate;
  late bool isAdopted;
  late String description;

  late bool isFavorite;
}
