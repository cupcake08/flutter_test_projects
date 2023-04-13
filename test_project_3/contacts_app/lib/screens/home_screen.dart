// ignore_for_file: use_build_context_synchronously
import 'package:contacts_app/models/contact.dart';
import 'package:contacts_app/notifiers/notifiers.dart';
import 'package:contacts_app/screens/login_screen.dart';
import 'package:contacts_app/utils/utils.dart';
import 'package:contacts_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final ScrollController _scrollController;
  double previousMaxScrollExtent = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() => _scrollListener());
    context.read<ContactsNotifier>().getContacts(skip: 0);
  }

  _scrollListener() {
    final contactsNotifier = context.read<ContactsNotifier>();
    final double maxScrollExtent = _scrollController.position.maxScrollExtent;
    final double distanceFromLast = (maxScrollExtent / contactsNotifier.contacts.length) * 2.5;
    if (contactsNotifier.apiStatus != ApiStatus.waiting &&
        _scrollController.position.pixels > maxScrollExtent - distanceFromLast &&
        maxScrollExtent >= previousMaxScrollExtent) {
      previousMaxScrollExtent = maxScrollExtent;
      int postListSize = contactsNotifier.contacts.length;
      int skip = postListSize;
      if (contactsNotifier.moreContacts) {
        contactsNotifier.getContacts(skip: skip);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(() => _scrollListener());
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
        actions: [
          IconButton(
              onPressed: () async {
                // logout user
                await SharedPrefs.logOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: SafeArea(
        top: false,
        child: Selector<ContactsNotifier, Tuple2<int, ApiStatus>>(
          selector: (_, notifier) => Tuple2(notifier.contacts.length, notifier.apiStatus),
          builder: (context, data, _) {
            switch (data.item2) {
              case ApiStatus.success:
                return ContactList(scrollController: _scrollController);
              case ApiStatus.waiting:
                return const Center(child: CircularProgressIndicator());
              case ApiStatus.error:
                return InternetError(
                  height: 200,
                  errorMsg: "Failed to get Contacts",
                  onTap: () => context.read<ContactsNotifier>().getContacts(skip: 0),
                );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                titlePadding: const EdgeInsets.only(top: 0),
                title: AppBar(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  title: Text(
                    'Create Contact',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
                content: const ContactForm(),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ContactList extends StatefulWidget {
  const ContactList({
    super.key,
    required this.scrollController,
  });
  final ScrollController scrollController;

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    return Selector<ContactsNotifier, ApiStatus>(
      selector: (p0, p1) => p1.contactApiStatus,
      builder: (context, _, __) {
        final provider = context.read<ContactsNotifier>();
        if (provider.contacts.isEmpty) {
          return Center(
            child: Text(
              "No Contacts",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          );
        }
        return ListView.builder(
          itemCount: provider.contacts.length + 1,
          controller: widget.scrollController,
          itemBuilder: (context, index) => index == provider.contacts.length
              ? Selector<ContactsNotifier, ApiStatus>(
                  selector: (p0, p1) => p1.apiStatus,
                  builder: (context, value, child) {
                    final provider = context.read<ContactsNotifier>();
                    if (provider.moreContacts) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Column(
                        children: [
                          Text(
                            "No more contacts",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }
                  },
                )
              : ContactWidget(contact: provider.contacts[index]),
        );
      },
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
      margin: const EdgeInsets.all(10),
      child: ExpansionTile(
        title: Text(
          contact.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        leading: Container(
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
        subtitle: Text(
          "+${contact.countryCode} ${contact.phone}",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: () => _editHandler(context), icon: const Icon(Icons.edit, color: Colors.green)),
              IconButton(onPressed: () => _handleDelete(context), icon: const Icon(Icons.delete, color: Colors.red)),
            ],
          ),
        ],
      ),
    );
  }

  _handleDelete(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                "Deleting contact...",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        );
      },
    );
    await context.read<ContactsNotifier>().deleteContact(contact);
    Navigator.of(context).pop();
  }

  _editHandler(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(top: 0),
          title: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Text(
              'Edit Contact',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
          ),
          content: ContactForm(contact: contact),
        );
      },
    );
  }
}
