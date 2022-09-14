
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

import 'contact_details.dart';

class ContactsList extends StatelessWidget {
  final List<Contact> contacts;
  Function() reloadContacts;
  ContactsList({Key? key, required this.contacts, required this.reloadContacts}) : super(key: key);

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
                    )
                ));
              },

              title: Text(contact.displayName??'default value'),
              // subtitle: Text(
              //     contact.info.phones.length > 0 ? contact.info.phones.elementAt(0).value : ''
              // ),
              // leading: ContactAvatar(contact, 36)
          );
        },
      ),
    );
  }
  //  emailShow(String) {
  //   String a = contact.emails.map(e => e.value).toList().toString().replaceAll('[', '').replaceAll(']', '');
  //   return String;
  // }
}
class EmailList extends StatelessWidget {
  final List<Contact> contacts;
  Function() reloadContacts;
  EmailList({Key? key, required this.contacts, required this.reloadContacts}) : super(key: key);

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
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (BuildContext context) => ContactDetails(
                //       contact,
                //       onContactDelete: (Contact _contact) {
                //         reloadContacts();
                //         Navigator.of(context).pop();
                //       },
                //       onContactUpdate: (Contact _contact) {
                //         reloadContacts();
                //       },
                //     )
                // ));
              },

              title: Text(contact.displayName??'default value'),
            subtitle: Text(contact.emails!.map((e) => e.value).toList().toString()),
              // subtitle: Text(
              //     contact.info.phones.length > 0 ? contact.info.phones.elementAt(0).value : ''
              // ),
              // leading: ContactAvatar(contact, 36)
          );
        },
      ),
    );
  }
  //  emailShow(String) {
  //   String a = contact.emails.map(e => e.value).toList().toString().replaceAll('[', '').replaceAll(']', '');
  //   return String;
  // }
}
class PhoneList extends StatelessWidget {
  final List<Contact> contacts;
  Function() reloadContacts;
  PhoneList({Key? key, required this.contacts, required this.reloadContacts}) : super(key: key);

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
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (BuildContext context) => ContactDetails(
                //       contact,
                //       onContactDelete: (Contact _contact) {
                //         reloadContacts();
                //         Navigator.of(context).pop();
                //       },
                //       onContactUpdate: (Contact _contact) {
                //         reloadContacts();
                //       },
                //     )
                // ));
              },

              title: Text(contact.displayName??'default value'),
            subtitle: Text(contact.phones!.map((e) => e.value).toList().toString()),
              // subtitle: Text(
              //     contact.info.phones.length > 0 ? contact.info.phones.elementAt(0).value : ''
              // ),
              // leading: ContactAvatar(contact, 36)
          );
        },
      ),
    );
  }
  //  emailShow(String) {
  //   String a = contact.emails.map(e => e.value).toList().toString().replaceAll('[', '').replaceAll(']', '');
  //   return String;
  // }
}
