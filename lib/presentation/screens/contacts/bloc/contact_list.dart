import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'contact_details.dart';

class ContactsList extends StatelessWidget {
  final List<Contact> contacts;
  Function() reloadContacts;

  ContactsList({Key? key, required this.contacts, required this.reloadContacts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          Contact contact = contacts[index];
          return ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ContactDetails(
                        contact,
                        onContactDelete: (Contact _contact) {
                          reloadContacts();
                          Navigator.of(context).pop();
                        },
                        onContactUpdate: (Contact _contact) {
                          reloadContacts();
                        },
                      )));
            },
            title: Text(contact.displayName ?? 'default value'),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.blueAccent,
            ),
          );
        },
      ),
    );
  }
}

class EmailList extends StatelessWidget {
  final List<Contact> contacts;
  Function() reloadContacts;

  EmailList({Key? key, required this.contacts, required this.reloadContacts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          Contact contact = contacts[index];
          return ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ContactDetails(
                        contact,
                        onContactDelete: (Contact _contact) {
                          reloadContacts();
                          Navigator.of(context).pop();
                        },
                        onContactUpdate: (Contact _contact) {
                          reloadContacts();
                        },
                      )));
            },
            title: Text(contact.displayName ?? 'default value'),
            subtitle: Text(emailShow(contact)),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.blueAccent,
            ),
          );
        },
      ),
    );
  }

  String emailShow(Contact contact) {
    String? a = contact.emails
        ?.map((e) => e.value)
        .toList()
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '');
    return a.toString();
  }
}

class PhoneList extends StatelessWidget {
  final List<Contact> contacts;
  Function() reloadContacts;

  PhoneList({Key? key, required this.contacts, required this.reloadContacts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          Contact contact = contacts[index];
          return ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ContactDetails(
                        contact,
                        onContactDelete: (Contact _contact) {
                          reloadContacts();
                          Navigator.of(context).pop();
                        },
                        onContactUpdate: (Contact _contact) {
                          reloadContacts();
                        },
                      )));
            },
            title: Text(contact.displayName ?? 'default value'),
            subtitle: Text(phoneShow(contact)),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.blueAccent,
            ),
          );
        },
      ),
    );
  }
}

String phoneShow(Contact contact) {
  String? a = contact.phones
      ?.map((e) => e.value)
      .toList()
      .toString()
      .replaceAll('[', '')
      .replaceAll(']', '');
  return a.toString();
}
