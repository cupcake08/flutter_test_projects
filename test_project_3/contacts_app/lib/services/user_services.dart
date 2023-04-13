import 'package:contacts_app/models/models.dart';
import 'package:contacts_app/utils/utils.dart';

class UserServices {
  UserServices._();

  // login user
  static Future<User?> loginUser(String email, String password) async {
    User? user;
    await NetworkManager().sendHttpRequest(
      endpoint: NetworkingUrls.login,
      type: HttpMethod.post,
      body: {
        "email": email,
        "password": password,
      },
      callback: ApiCallback(
        onCompleted: () => "login request".log(),
        onSuccess: (res) => user = userFromJson(res.body),
        onError: (msg, _) => "Error: $msg".log(),
      ),
    );
    return user;
  }

  static Future<List<Contact>?> getContacts(int skip, int limit) async {
    List<Contact>? contacts;
    await NetworkManager().sendHttpRequest(
      endpoint: "${NetworkingUrls.getContacts}?limit=$limit&skip=$skip",
      type: HttpMethod.get,
      callback: ApiCallback(
        onCompleted: () => "requested to get contacts".log(),
        onSuccess: (res) => getContactsFromJson(res.body),
        onError: (msg, _) => "Error: $msg".log(),
      ),
    );
    return contacts;
  }

  static Future<bool> updateContact(Contact contact) async {
    bool result = false;
    await NetworkManager().sendHttpRequest(
      endpoint: NetworkingUrls.updateContact,
      type: HttpMethod.put,
      body: contact.toJson(),
      callback: ApiCallback(
        onCompleted: () => "requested to get contacts".log(),
        onSuccess: (res) => result = true,
        onError: (msg, _) => "Error: $msg".log(),
      ),
    );
    return result;
  }

  static Future<bool> deleteContact() async {
    bool result = false;
    await NetworkManager().sendHttpRequest(
      endpoint: NetworkingUrls.deleteContact,
      type: HttpMethod.delete,
      callback: ApiCallback(
        onCompleted: () => "requested to get contacts".log(),
        onSuccess: (res) => result = true,
        onError: (msg, _) => "Error: $msg".log(),
      ),
    );
    return result;
  }
}
