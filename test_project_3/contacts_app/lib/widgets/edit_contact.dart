import 'package:contacts_app/models/contact.dart';
import 'package:contacts_app/notifiers/contacts_notifier.dart';
import 'package:contacts_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:provider/provider.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({
    Key? key,
    this.contact,
  }) : super(key: key);
  final Contact? contact;

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  late CountryCode _selectedCode;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _nameController.text = widget.contact!.name;
      _phoneController.text = widget.contact!.phone.toString();
      _selectedCode = CountryCode.fromDialCode("+${widget.contact!.countryCode}");
    } else {
      _selectedCode = CountryCode.fromDialCode("+91");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RegExp phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              CountryCodePicker(
                onChanged: (code) => setState(() {
                  _selectedCode = code;
                }),
                textStyle: Theme.of(context).textTheme.bodyLarge,
                showDropDownButton: true,
                initialSelection: _selectedCode.code,
                favorite: const ['+91'],
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
              ),
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    } else if (!phoneRegex.hasMatch(value)) {
                      return 'Enter Valid Phone Number';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _loading ? null : _handleTap,
            style: ElevatedButton.styleFrom(
              fixedSize: Size(context.width * .9, 50),
              padding: const EdgeInsets.all(10),
            ),
            child: _loading ? const CircularProgressIndicator() : Text(widget.contact != null ? 'Edit' : 'Create'),
          ),
        ],
      ),
    );
  }

  _handleTap() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
      final contact = Contact(
        name: _nameController.text.trim(),
        phone: int.parse(_phoneController.text.trim()),
        countryCode: int.parse(_selectedCode.dialCode!.substring(1)),
      );
      final provider = context.read<ContactsNotifier>();
      if (widget.contact != null) {
        await provider.updateContact(contact, widget.contact!.id!);
      } else {
        await provider.createContact(contact);
      }
      setState(() => _loading = false);
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }
}
