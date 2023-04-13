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
        onSuccess: (res) => contacts = getContactsFromJson(res.body),
        onError: (msg, _) => "Error: $msg".log(),
      ),
    );
    return contacts;
  }

  static Future<Contact?> createContact(Contact contact) async {
    Contact? contactR;
    await NetworkManager().sendHttpRequest(
      endpoint: NetworkingUrls.createContact,
      type: HttpMethod.post,
      body: contact.toJson(),
      callback: ApiCallback(
        onCompleted: () => "requested to create contact".log(),
        onSuccess: (res) => contactR = getContactFromJson(res.body),
        onError: (msg, _) => "Error: $msg".log(),
      ),
    );
    return contactR;
  }

  static Future<bool> updateContact(Contact contact, String id) async {
    bool result = false;
    final body = contact.toJson();
    final url = "${NetworkingUrls.updateContact}?id=$id";
    await NetworkManager().sendHttpRequest(
      endpoint: url,
      type: HttpMethod.put,
      body: body,
      callback: ApiCallback(
        onCompleted: () => "requested to update contact".log(),
        onSuccess: (res) => result = true,
        onError: (msg, _) => "Error: $msg".log(),
      ),
    );
    return result;
  }

  static Future<bool> deleteContact(String id) async {
    bool result = false;
    await NetworkManager().sendHttpRequest(
      endpoint: "${NetworkingUrls.deleteContact}?id=$id",
      type: HttpMethod.delete,
      callback: ApiCallback(
        onCompleted: () => "requested to delete contact".log(),
        onSuccess: (res) => result = true,
        onError: (msg, _) => "Error: $msg".log(),
      ),
    );
    return result;
  }
}
