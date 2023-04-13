import 'package:contacts_app/models/contact.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() => _scrollController);
  }

  _scrollListener() {}

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 213, 213),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Contacts List"),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          return ContactWidget(contact: contacts[index]);
        },
      ),
    );
  }
}

class ContactWidget extends StatelessWidget {
  const ContactWidget({super.key, required this.contact});
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          // user name image
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
              border: Border.all(width: 2),
            ),
            padding: const EdgeInsets.all(10),
            child: Text(
              contact.name[0].toUpperCase(),
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 5),
              Text(
                "+${contact.countryCode} ${contact.phone}",
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
