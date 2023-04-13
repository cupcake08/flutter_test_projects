import 'package:contacts_app/models/contact.dart';
import 'package:flutter/material.dart';

class ContactsNotifier extends ChangeNotifier {
  final List<Contact>? _contacts = null;

  List<Contact>? get contacts => _contacts;
}