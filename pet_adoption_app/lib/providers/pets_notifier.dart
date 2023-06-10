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

  bool _searchingPets = false;
  bool get searchingPets => _searchingPets;

  set setResetTheAnimationController(bool value) => _resetTheAnimationController = value;

  set setGettingMorePets(bool value) {
    _gettingMorePets = value;
    notifyListeners();
  }

  void setSearchingPets(bool value, {bool notify = true}) {
    _searchingPets = value;
    if (notify) notifyListeners();
  }

  final List<Pet> _cats = [];
  final List<Pet> _dogs = [];
  final List<Pet> _birds = [];
  final List<Pet> _fishes = [];
  List<Pet> _searchPets = [];

  List<Pet> get cats => _cats;
  List<Pet> get dogs => _dogs;
  List<Pet> get birds => _birds;
  List<Pet> get fishes => _fishes;
  List<Pet> get searchPets => _searchPets;

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
        if (_cats.isEmpty) await getPets(0, PetType.cat);
      case 1:
        if (_dogs.isEmpty) await getPets(0, PetType.dog);
      case 2:
        if (_birds.isEmpty) await getPets(0, PetType.bird);
      case 3:
        if (_fishes.isEmpty) await getPets(0, PetType.fish);
      default:
        await getPets(0, PetType.cat);
    }
    setGettingPets(false);
  }

  Future<void> getPetsPagination(int skip) async {
    final index = _currentCategorySelectedIndex;
    _gettingMorePets = true;
    switch (index) {
      case 0:
        await getPets(skip, PetType.cat);
      case 1:
        await getPets(skip, PetType.dog);
      case 2:
        await getPets(skip, PetType.bird);
      case 3:
        await getPets(skip, PetType.fish);
      default:
        await getPets(skip, PetType.cat);
    }
    _gettingMorePets = false;
    notifyListeners();
  }

  Future<void> getPetsListBySearch(String name) async {
    assert(AppInit.isar != null, "Isar is not initialized");
    setSearchingPets(true, notify: false);
    _searchPets = await AppInit.isar!.pets.where().nameStartsWith(name).limit(6).findAll();
    setSearchingPets(false);
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
        return _cats;
      case 1:
        return _dogs;
      case 2:
        return _birds;
      case 3:
        return _fishes;
      default:
        return _cats;
    }
  }

  void markPetAsAdopted(Pet pet) async {
    assert(AppInit.isar != null, "Isar is not initialized");
    switch (pet.type) {
      case PetType.cat:
        int idx = _cats.indexWhere((element) => element.id == pet.id);
        if (idx != -1) {
          _cats[idx].isAdopted = true;
        }
      case PetType.dog:
        int idx = _dogs.indexWhere((element) => element.id == pet.id);
        if (idx != -1) {
          _dogs[idx].isAdopted = true;
        }
      case PetType.bird:
        int idx = _birds.indexWhere((element) => element.id == pet.id);
        if (idx != -1) _birds[idx].isAdopted = true;
      case PetType.fish:
        int idx = _fishes.indexWhere((element) => element.id == pet.id);
        if (idx != -1) _fishes[idx].isAdopted = true;
    }
    await AppInit.isar!.writeTxn(() async {
      pet.isAdopted = true;
      await AppInit.isar!.pets.put(pet);
    });
  }

  void markPetAsFavorite(Pet pet) async {
    assert(AppInit.isar != null, "Isar is not initialized");
    bool succ = false;
    switch (pet.type) {
      case PetType.cat:
        int idx = _cats.indexWhere((element) => element.id == pet.id);
        if (idx != -1) {
          succ = true;
          _cats[idx].isFavorite = !pet.isFavorite;
        }
      case PetType.dog:
        int idx = _dogs.indexWhere((element) => element.id == pet.id);
        if (idx != -1) {
          succ = true;
          _dogs[idx].isFavorite = !pet.isFavorite;
        }
      case PetType.bird:
        int idx = _birds.indexWhere((element) => element.id == pet.id);
        if (idx != -1) {
          succ = true;
          _birds[idx].isFavorite = !pet.isFavorite;
        }
      case PetType.fish:
        int idx = _fishes.indexWhere((element) => element.id == pet.id);
        if (idx != -1) {
          succ = true;
          _fishes[idx].isFavorite = !pet.isFavorite;
        }
    }
    await AppInit.isar!.writeTxn(() async {
      pet.isFavorite = succ ? pet.isFavorite : !pet.isFavorite;
      await AppInit.isar!.pets.put(pet);
    });
  }
}
