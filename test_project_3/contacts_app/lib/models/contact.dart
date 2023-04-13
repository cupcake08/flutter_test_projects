import 'dart:convert';

List<Contact> getContactsFromJson(String body) {
  final data = json.decode(body)['result'] as List;
  return List.generate(
    data.length,
    (index) => Contact.fromJson(data[index]),
  );
}

Contact getContactFromJson(String body) => Contact.fromJson(json.decode(body)['result']);

class Contact {
  String name;
  int phone;
  int countryCode;
  final String? id;

  Contact({
    required this.name,
    required this.phone,
    required this.countryCode,
    this.id,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json['_id'],
        name: json['name'],
        phone: json['phone'],
        countryCode: json['countryCode'],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "countryCode": countryCode,
      };
}

// final contacts = [
//   Contact(name: "Ankit Bhankharia", phone: 9079897225, countryCode: 91),
//   Contact(name: "Ankit Bhankharia", phone: 9079897225, countryCode: 91),
//   Contact(name: "Ankit Bhankharia", phone: 9079897225, countryCode: 91),
//   Contact(name: "Ankit Bhankharia", phone: 9079897225, countryCode: 91),
//   Contact(name: "Ankit Bhankharia", phone: 9079897225, countryCode: 91),
//   Contact(name: "Ankit Bhankharia", phone: 9079897225, countryCode: 91),
//   Contact(name: "Ankit Bhankharia", phone: 9079897225, countryCode: 91),
//   Contact(name: "Ankit Bhankharia", phone: 9079897225, countryCode: 91),
//   Contact(name: "Ankit Bhankharia", phone: 9079897225, countryCode: 91),
//   Contact(name: "Ankit Bhankharia", phone: 9079897225, countryCode: 91),
//   Contact(name: "Ankit Bhankharia", phone: 9079897225, countryCode: 91),
//   Contact(name: "Ankit Bhankharia", phone: 9079897225, countryCode: 91),
//   Contact(name: "Ankit Bhankharia", phone: 9079897225, countryCode: 91),
// ];
