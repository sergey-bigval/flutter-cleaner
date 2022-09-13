
import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/model.dart';


class ContactsList extends StatelessWidget {
  final List<AppContact> contacts;
  Function() reloadContacts;
  ContactsList({Key? key, required this.contacts, required this.reloadContacts}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          AppContact contact = contacts[index];

          return ListTile(
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (BuildContext context) => ContactDetails(
                //       contact,
                //       onContactDelete: (AppContact _contact) {
                //         reloadContacts();
                //         Navigator.of(context).pop();
                //       },
                //       onContactUpdate: (AppContact _contact) {
                //         reloadContacts();
                //       },
                //     )
                // ));
              },
              title: Text(contact.info.displayName??'default value'),
              // subtitle: Text(
              //     contact.info.phones.length > 0 ? contact.info.phones.elementAt(0).value : ''
              // ),
              // leading: ContactAvatar(contact, 36)
          );
        },
      ),
    );
  }
}
