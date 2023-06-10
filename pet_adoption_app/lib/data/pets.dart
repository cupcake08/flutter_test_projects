import 'package:pet_adoption_app/data/images.dart';
import 'package:pet_adoption_app/models/pet.dart';
import 'package:pet_adoption_app/utils/utils.dart';
import 'dart:math' show Random;

final List<Pet> pets = [];

String generateRandomName(List<String> nameList) {
  final random = Random();
  final index = random.nextInt(nameList.length);
  return nameList[index];
}

String generateRandomPetName() {
  final List<String> firstNames = [
    'Max',
    'Bella',
    'Charlie',
    'Luna',
    'Rocky',
    'Lucy',
    'Cooper',
    'Milo',
    'Daisy',
    'Oliver',
    'Lola',
    'Toby',
    'Sadie',
    'Oscar',
    'Ruby',
    'Teddy',
    'Sophie',
    'Buddy',
    'Molly',
    'Leo',
    'Mia',
    'Jack',
    'Coco',
    'Loki',
    'Zoe',
    'Simba',
    'Rosie',
    'Zeus',
    'Chloe',
    'Casper',
    'Lily',
  ];

  final List<String> lastNames = [
    'Smith',
    'Johnson',
    'Williams',
    'Jones',
    'Brown',
    'Davis',
    'Miller',
    'Wilson',
    'Moore',
    'Taylor',
    'Anderson',
    'Thomas',
    'Jackson',
    'White',
    'Harris',
    'Martin',
    'Thompson',
    'Garcia',
    'Martinez',
    'Robinson',
    'Clark',
    'Rodriguez',
    'Lewis',
    'Lee',
    'Walker',
    'Hall',
    'Allen',
    'Young',
    'King',
    'Wright',
  ];

  final random = Random();
  final firstNameIndex = random.nextInt(firstNames.length);
  final lastNameIndex = random.nextInt(lastNames.length);

  final firstName = firstNames[firstNameIndex];
  final lastName = lastNames[lastNameIndex];

  return '$firstName $lastName';
}

String generateRandomBreedName() {
  final List<String> breedNames = [
    'Labrador Retriever',
    'German Shepherd',
    'Golden Retriever',
    'Bulldog',
    'Beagle',
    'Poodle',
    'Rottweiler',
    'Yorkshire Terrier',
    'Boxer',
    'Dachshund',
    'Chihuahua',
    'Siberian Husky',
    'Great Dane',
    'Pomeranian',
    'Shih Tzu',
    'Doberman Pinscher',
    'French Bulldog',
    'Boston Terrier',
    'Cocker Spaniel',
    'Australian Shepherd',
    'Corgi',
    'Pug',
    'Maltese',
    'Bichon Frise',
    'Shiba Inu',
    'Border Collie',
    'Basset Hound',
    'Saint Bernard',
    'English Mastiff',
    'Bull Terrier',
    'Weimaraner',
  ];
  return generateRandomName(breedNames);
}

DateTime generateRandomDate() {
  final random = Random();
  final now = DateTime.now();
  final minDuration = 365.days;
  final maxDuration = (365 * 3).days;
  final randomDuration = minDuration + Duration(days: random.nextInt(maxDuration.inDays - minDuration.inDays));

  return now.add(randomDuration);
}

String generateRandomOwnerName() {
  final List<String> ownerNames = [
    'Smith',
    'Johnson',
    'Williams',
    'Jones',
    'Brown',
    'Davis',
    'Miller',
    'Wilson',
    'Moore',
    'Taylor',
    'Anderson',
    'Thomas',
    'Jackson',
    'White',
    'Harris',
    'Martin',
    'Thompson',
    'Garcia',
    'Martinez',
    'Robinson',
    'Clark',
    'Rodriguez',
    'Lewis',
    'Lee',
    'Walker',
    'Hall',
    'Allen',
    'Young',
    'King',
    'Wright',
  ];
  return generateRandomName(ownerNames);
}

generatePets() {
  // Cats
  for (int i = 1; i <= 13; i++) {
    Pet cat = Pet()
      ..name = generateRandomPetName()
      ..breed = generateRandomBreedName()
      ..type = PetType.cat
      ..gender = Gender.values[Random().nextInt(2)]
      ..image = catImages[(i - 1) % 4]
      ..birthDate = generateRandomDate()
      ..ownerName = generateRandomOwnerName()
      ..publishDate = DateTime.now()
      ..isAdopted = false
      ..description = 'Description for Cat$i'
      ..isFavorite = false;

    pets.add(cat);
  }

  // Dogs
  for (int i = 1; i <= 13; i++) {
    Pet dog = Pet()
      ..name = generateRandomPetName()
      ..breed = generateRandomBreedName()
      ..type = PetType.dog
      ..gender = Gender.values[Random().nextInt(2)]
      ..image = dogImages[(i - 1) % 4]
      ..birthDate = generateRandomDate()
      ..ownerName = generateRandomOwnerName()
      ..publishDate = DateTime.now()
      ..isAdopted = false
      ..description = 'Description for Dog$i'
      ..isFavorite = false;

    pets.add(dog);
  }

  // Birds
  for (int i = 1; i <= 13; i++) {
    Pet bird = Pet()
      ..name = generateRandomPetName()
      ..breed = generateRandomBreedName()
      ..type = PetType.bird
      ..gender = Gender.values[Random().nextInt(2)]
      ..image = birdImages[(i - 1) % 4]
      ..birthDate = generateRandomDate()
      ..ownerName = generateRandomOwnerName()
      ..publishDate = DateTime.now()
      ..isAdopted = false
      ..description = 'Description for Bird$i'
      ..isFavorite = false;

    pets.add(bird);
  }

  // Fish
  for (int i = 1; i <= 13; i++) {
    Pet fish = Pet()
      ..name = generateRandomPetName()
      ..breed = generateRandomPetName()
      ..type = PetType.fish
      ..gender = Gender.values[Random().nextInt(2)]
      ..image = fishImages[(i - 1) % 4]
      ..birthDate = generateRandomDate()
      ..ownerName = generateRandomOwnerName()
      ..publishDate = DateTime.now()
      ..isAdopted = false
      ..description = 'Description for Fish$i'
      ..isFavorite = false;

    pets.add(fish);
  }
}
