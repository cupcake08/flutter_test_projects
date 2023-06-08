import 'package:pet_adoption_app/data/images.dart';
import 'package:pet_adoption_app/models/pet.dart';
import 'package:pet_adoption_app/utils/utils.dart';

final List<Pet> pets = [];

generatePets() {
  // Cats
  for (int i = 1; i <= 13; i++) {
    Pet cat = Pet()
      ..name = 'Cat $i'
      ..breed = 'Breed $i'
      ..type = PetType.cat
      ..gender = Gender.male
      ..image = catImages[(i - 1) % 4]
      ..birthDate = DateTime(2021, 1, i)
      ..ownerName = 'Owner $i'
      ..publishDate = DateTime.now()
      ..isAdopted = false
      ..description = 'Description for Cat$i'
      ..isFavorite = false;

    pets.add(cat);
  }

  // Dogs
  for (int i = 1; i <= 13; i++) {
    Pet dog = Pet()
      ..name = 'Dog $i'
      ..breed = 'Breed $i'
      ..type = PetType.dog
      ..gender = Gender.male
      ..image = dogImages[(i - 1) % 4]
      ..birthDate = DateTime(2021, 2, i)
      ..ownerName = 'Owner $i'
      ..publishDate = DateTime.now()
      ..isAdopted = false
      ..description = 'Description for Dog$i'
      ..isFavorite = false;

    pets.add(dog);
  }

  // Birds
  for (int i = 1; i <= 13; i++) {
    Pet bird = Pet()
      ..name = 'Bird $i'
      ..breed = 'Breed $i'
      ..type = PetType.bird
      ..gender = Gender.male
      ..image = birdImages[(i - 1) % 4]
      ..birthDate = DateTime(2021, 3, i)
      ..ownerName = 'Owner $i'
      ..publishDate = DateTime.now()
      ..isAdopted = false
      ..description = 'Description for Bird$i'
      ..isFavorite = false;

    pets.add(bird);
  }

  // Fish
  for (int i = 1; i <= 13; i++) {
    Pet fish = Pet()
      ..name = 'Fish $i'
      ..breed = 'Breed $i'
      ..type = PetType.fish
      ..gender = Gender.male
      ..image = fishImages[(i - 1) % 4]
      ..birthDate = DateTime(2021, 4, i)
      ..ownerName = 'Owner $i'
      ..publishDate = DateTime.now()
      ..isAdopted = false
      ..description = 'Description for Fish$i'
      ..isFavorite = false;

    pets.add(fish);
  }
}
