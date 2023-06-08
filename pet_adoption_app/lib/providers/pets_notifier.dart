import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:pet_adoption_app/models/pet.dart';
import 'package:pet_adoption_app/utils/utils.dart';

class PetsNotifier extends ChangeNotifier {
  int _currentCategorySelectedIndex = 0;
  int get currentCategorySelectedIndex => _currentCategorySelectedIndex;

  bool _gettingPets = false;
  bool get gettingPets => _gettingPets;

  List<Pet> _cats = [];
  List<Pet> _dogs = [];
  List<Pet> _birds = [];
  List<Pet> _fishes = [];

  List<Pet> get cats => _cats;
  List<Pet> get dogs => _dogs;
  List<Pet> get birds => _birds;
  List<Pet> get fishes => _fishes;

  void setGettingPets(bool value, {bool notify = true}) {
    _gettingPets = value;
    if (notify) notifyListeners();
  }

  Future<void> setCurrentCategorySelectedIndex(int index, {bool notify = true}) async {
    _currentCategorySelectedIndex = index;
    setGettingPets(true, notify: notify);
    switch (index) {
      case 0:
        "getting cats".log();
        await getCats(0);
      case 1:
        "getting dogs".log();
        await getDogs(0);
      case 2:
        "getting birds".log();
        await getBirds(0);
      case 3:
        "getting fishes".log();
        await getFishes(0);
      default:
        "getting cats".log();
        await getCats(0);
    }
    setGettingPets(false);
  }

  Future<void> getCats(int skip) async {
    assert(AppInit.isar != null, "Isar is not initialized");
    _cats = await AppInit.isar!.pets.where().typeEqualTo(PetType.cat).offset(skip).limit(5).findAll();
  }

  // find dogs
  Future<void> getDogs(int skip) async {
    assert(AppInit.isar != null, "Isar is not initialized");
    _dogs = await AppInit.isar!.pets.where().typeEqualTo(PetType.dog).offset(skip).limit(5).findAll();
  }

  // find birds
  Future<void> getBirds(int skip) async {
    assert(AppInit.isar != null, "Isar is not initialized");
    _birds = await AppInit.isar!.pets.where().typeEqualTo(PetType.bird).offset(skip).limit(5).findAll();
  }

  // find fishes
  Future<void> getFishes(int skip) async {
    assert(AppInit.isar != null, "Isar is not initialized");
    _fishes = await AppInit.isar!.pets.where().typeEqualTo(PetType.fish).offset(skip).limit(5).findAll();
  }

  List<Pet> getPetList(int index, int skip) {
    switch (index) {
      case 0:
        "getting cats list".log();
        return _cats;
      case 1:
        "getting dog list".log();
        return _dogs;
      case 2:
        "getting birds list".log();
        return _birds;
      case 3:
        "getting fishes list".log();
        return _fishes;
      default:
        return _cats;
    }
  }
}
