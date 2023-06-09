import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:pet_adoption_app/models/pet.dart';
import 'package:pet_adoption_app/utils/utils.dart';

final class PetsNotifier extends ChangeNotifier {
  int _currentCategorySelectedIndex = 0;
  int get currentCategorySelectedIndex => _currentCategorySelectedIndex;

  bool _gettingPets = false;
  bool get gettingPets => _gettingPets;

  bool _gettingMorePets = false;
  bool get gettingMorePets => _gettingMorePets;

  bool _hasMoreCats = true;
  bool get hasMoreCats => _hasMoreCats;

  bool _hasMoreDogs = true;
  bool get hasMoreDogs => _hasMoreDogs;

  bool _hasMoreBirds = true;
  bool get hasMoreBirds => _hasMoreBirds;

  bool _hasMoreFishes = true;
  bool get hasMoreFishes => _hasMoreFishes;

  bool _resetTheAnimationController = false;
  bool get resetTheAnimationController => _resetTheAnimationController;

  set setResetTheAnimationController(bool value) => _resetTheAnimationController = value;

  set setGettingMorePets(bool value) {
    _gettingMorePets = value;
    notifyListeners();
  }

  final List<Pet> _cats = [];
  final List<Pet> _dogs = [];
  final List<Pet> _birds = [];
  final List<Pet> _fishes = [];

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
    _resetTheAnimationController = true;
    setGettingPets(true, notify: notify);
    switch (index) {
      case 0:
        "getting cats".log();
        if (_cats.isEmpty) await getPets(0, PetType.cat);
      case 1:
        "getting dogs".log();
        if (_dogs.isEmpty) await getPets(0, PetType.dog);
      case 2:
        "getting birds".log();
        if (_birds.isEmpty) await getPets(0, PetType.bird);
      case 3:
        "getting fishes".log();
        if (_fishes.isEmpty) await getPets(0, PetType.fish);
      default:
        "getting cats".log();
        await getPets(0, PetType.cat);
    }
    setGettingPets(false);
  }

  Future<void> getPetsPagination(int skip) async {
    final index = _currentCategorySelectedIndex;
    _gettingMorePets = true;
    switch (index) {
      case 0:
        "getting cats".log();
        await getPets(skip, PetType.cat);
      case 1:
        "getting dogs".log();
        await getPets(skip, PetType.dog);
      case 2:
        "getting birds".log();
        await getPets(skip, PetType.bird);
      case 3:
        "getting fishes".log();
        await getPets(skip, PetType.fish);
      default:
        "getting cats".log();
        await getPets(skip, PetType.cat);
    }
    _gettingMorePets = false;
    notifyListeners();
  }

  Future<List<Pet>> getPetsListBySearch(String name) async {
    assert(AppInit.isar != null, "Isar is not initialized");
    return await AppInit.isar!.pets.where().nameEqualTo(name).findAll();
  }

  Future<void> getPets(int skip, PetType type) async {
    assert(AppInit.isar != null, "Isar is not initialized");
    final ps = await AppInit.isar!.pets.where().typeEqualTo(type).offset(skip).limit(5).findAll();
    switch (type) {
      case PetType.cat:
        if (ps.isEmpty) _hasMoreCats = false;
        _cats.addAll(ps);
      case PetType.dog:
        if (ps.isEmpty) _hasMoreDogs = false;
        _dogs.addAll(ps);
      case PetType.bird:
        if (ps.isEmpty) _hasMoreBirds = false;
        _birds.addAll(ps);
      case PetType.fish:
        if (ps.isEmpty) _hasMoreFishes = false;
        _fishes.addAll(ps);
    }
  }

  List<Pet> getPetList(int index) {
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
