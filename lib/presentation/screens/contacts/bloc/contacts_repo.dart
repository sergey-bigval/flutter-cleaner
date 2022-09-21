import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'contacts_bloc.dart';
import 'contacts_event.dart';

class ContactsRepo {
  late final ContactsBloc bloc;

  ContactsRepo({required this.bloc});

  getAllContacts() async {
    if (await Permission.contacts.request().isGranted) {
      bloc.add(StartScanningContactsEvent()); //TODO: start search
      sleep(Duration(milliseconds: 3000));
      List<Contact> contacts = await ContactsService.getContacts();
      bloc.add(FinishScanningContactsEvent(
          contactsSize: contacts.length)); //TODO: end search
      return contacts;
    }
  }
}
