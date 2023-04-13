import 'package:contacts_app/models/contact.dart';
import 'package:contacts_app/services/user_services.dart';
import 'package:contacts_app/utils/enums.dart';
import 'package:flutter/material.dart';

class ContactsNotifier extends ChangeNotifier {
  final List<Contact> _contacts = [];
  bool _moreContacts = true;
  ApiStatus _apiStatus = ApiStatus.success;
  ApiStatus _contactApiStatus = ApiStatus.success;

  // getters
  List<Contact>? get contacts => _contacts;
  bool get moreContacts => _moreContacts;
  ApiStatus get apiStatus => _apiStatus;
  ApiStatus get contactApiStatus => _contactApiStatus;

  _setApiStatus(ApiStatus value, bool notify) {
    _apiStatus = value;
    if (notify) {
      notifyListeners();
    }
  }

  _setContactApiStatus(ApiStatus status, bool notify) {
    _contactApiStatus = status;
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> getContacts({required int skip, int limit = 10, bool notify = false}) async {
    _setApiStatus(ApiStatus.waiting, notify);
    if (skip == 0) {
      _contacts.clear();
    }
    final contacts = await UserServices.getContacts(skip, limit);
    if (contacts != null) {
      _moreContacts = contacts.length == limit;
      _contacts.addAll(contacts);
      _setApiStatus(ApiStatus.success, true);
    } else {
      _setApiStatus(ApiStatus.error, true);
    }
  }

  Future<void> createContact(Contact contact) async {
    _setContactApiStatus(ApiStatus.waiting, true);
    final created = await UserServices.updateContact(contact);
    if (created) {
    } else {
      _setContactApiStatus(ApiStatus.error, true);
    }
  }

  Future<void> updateContact(Contact contact) async {
    _setContactApiStatus(ApiStatus.waiting, true);
    final updated = await UserServices.updateContact(contact);
    if (updated) {
    } else {
      _setContactApiStatus(ApiStatus.error, true);
    }
  }

  Future<void> deleteContact(int index) async {}
}
