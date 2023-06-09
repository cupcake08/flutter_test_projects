import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:pet_adoption_app/data/images.dart';
import 'package:pet_adoption_app/data/pets.dart';
import 'package:pet_adoption_app/models/pet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppInit {
  static late final Isar? isar;

  static late final SharedPreferences prefs;

  static const String themeModeVar = 'ThemeMode';

  static void cacheAssetImages(BuildContext context) {
    precacheImage(const AssetImage("assets/7953025-min.jpg"), context);
    precacheImage(const AssetImage("assets/cat-min.jpg"), context);
    precacheImage(const AssetImage("assets/dog-min.jpg"), context);
    precacheImage(const AssetImage("assets/fish-min.jpg"), context);
    precacheImage(const AssetImage("assets/bird-min.jpg"), context);
  }

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initPrefs();
    await initIsar();
    if (canIFillDataToIsar()) {
      fillDataToIsar();
    }
  }

  static Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setCanIFillDataToIsar(bool value) async {
    await prefs.setBool('canIFillDataToIsar', value);
  }

  static canIFillDataToIsar() {
    return prefs.getBool('canIFillDataToIsar') ?? true;
  }

  // initialize isar db
  static Future<void> initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([PetSchema], directory: dir.path);
  }

  static void fillDataToIsar() async {
    assert(isar != null, "Isar is not initialized");
    generatePets();
    final ids = (await isar!.pets.where().findAll()).map((e) => e.id).toList();
    await isar!.writeTxn(() async => await isar!.pets.deleteAll(ids));
    await isar!.writeTxn(() async {
      for (final pet in pets) {
        await isar!.pets.put(pet);
      }
    });
  }

  static void preCacheAllImages(BuildContext context) {
    for (final img in catImages) {
      CachedNetworkImageProvider(img);
    }
    for (final img in dogImages) {
      CachedNetworkImageProvider(img);
    }
    for (final img in birdImages) {
      CachedNetworkImageProvider(img);
    }
    for (final img in fishImages) {
      CachedNetworkImageProvider(img);
    }
  }

  static ThemeMode intialThemeMode() {
    return ThemeMode.values.firstWhere(
      (e) => e.toString() == prefs.getString(themeModeVar),
      orElse: () => ThemeMode.light,
    );
  }

  static void setThemeMode(ThemeMode themeMode) {
    prefs.setString(themeModeVar, themeMode.toString());
  }
}
