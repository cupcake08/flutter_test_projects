import 'package:contacts_app/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._();

  static late final SharedPreferences storage;

  static Future<bool> logOut() async {
    bool isCleared = await _clearStorage();
    return isCleared;
  }

  static Future<void> setUserData(User user) async {
    await storage.setString("name", user.name);
    await storage.setString("email", user.email);
    await updateAuthToken(user.authToken!);
  }

  static Future<void> init() async => storage = await SharedPreferences.getInstance();

  static Future<bool> _clearStorage() async => await storage.clear();

  static updateAuthToken(String authToken) => storage.setString('authToken', authToken);

  static bool isUserLoggedIn() {
    var value = storage.getString('authToken');

    if (value != null && value.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static String? getAuthToken() => storage.getString('authToken') ?? '';
}
