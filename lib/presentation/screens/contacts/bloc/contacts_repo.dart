import 'dart:io';
import 'dart:math';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'contacts_bloc.dart';
import 'contacts_event.dart';

class ContactsRepo {
  late final Bloc bloc;

  ContactsRepo({required this.bloc});

  getAllContacts() async {
    if (await Permission.contacts.request().isGranted) {
      bloc.add(StartScanningContactsEvent()); //TODO: start search
      List<Contact> contacts = await ContactsService.getContacts();
      bloc.add(FinishScanningContactsEvent(
          contactsSize: contacts.length)); //TODO: end search
      return contacts;
    }
  }

  getDubNames() async {
    List<Contact> contacts = [];
    if (await Permission.contacts.request().isGranted) {
      // bloc.add(StartScanningContactsEvent());
      contacts = await ContactsService.getContacts();
      // bloc.add(FinishScanningContactsEvent(
      // contactsSize: contacts.length));
    }
    contacts.sort((m1, m2) {
      if (m1.displayName == null) return -1;
      if (m2.displayName == null) return 1;

      return m1.displayName!
          .toLowerCase()
          .compareTo(m2.displayName!.toLowerCase());
    });

    List<Contact> filterredContacts = [];
    var index = 0;
    while (index < contacts.length - 1) {
      var currentElement = contacts[index];
      var nextElement = contacts[index + 1];
      if (currentElement.displayName?.toLowerCase() ==
          nextElement.displayName?.toLowerCase()) {
        if (!filterredContacts.contains(contacts[index])) {
          filterredContacts.add(contacts[index]);
          //todo: send event
          bloc.add(NewDubNamesFoundEvent(
              contactsNameSize: filterredContacts.length));
        }
        if (!filterredContacts.contains(contacts[index + 1])) {
          filterredContacts.add(contacts[index + 1]);
          //todo: send event
          bloc.add(NewDubNamesFoundEvent(
              contactsNameSize: filterredContacts.length));
        }
      }

      index++;
    }
    bloc.add(
        AllDubsNamesFoundEvent(contactsNamesSize: filterredContacts.length));
    return filterredContacts;
  }

  getDubPhones() async {
    List<Contact> contacts = [];
    if (await Permission.contacts.request().isGranted) {
      // bloc.add(StartScanningContactsEvent());
      contacts = await ContactsService.getContacts();
      // bloc.add(FinishScanningContactsEvent(
      // contactsSize: contacts.length));
    }
    List<Contact> dubPhones = [];
    var i = 0;
    while (i < contacts.length) {
      var contact = contacts[i];
      var phones = contact.phones;
      phones?.forEach((phone) {
        for (var cont in contacts) {
          var contPhones = cont.phones?.map((e) => e.value).toList();
          if (cont != contact && contPhones?.contains(phone.value) == true) {
            if (!dubPhones.contains(contact)) {
              dubPhones.add(contact);
              bloc.add(
                  NewDubPhonesFoundEvent(contactsPhonesSize: dubPhones.length));
            }
            if (!dubPhones.contains(cont)) {
              dubPhones.add(cont);
              bloc.add(
                  NewDubPhonesFoundEvent(contactsPhonesSize: dubPhones.length));
            }
          }
        }
      });
      i++;
    }
    bloc.add(AllDubsPhonesFoundEvent(contactsPhonesSize: dubPhones.length));
    return dubPhones;
  }

  getDubEmails() async {
    List<Contact> contacts = [];
    if (await Permission.contacts.request().isGranted) {
      // bloc.add(StartScanningContactsEvent()); //TODO: start search
      contacts = await ContactsService.getContacts();
      // bloc.add(FinishScanningContactsEvent(contactsSize: contacts.length));
    }
    List<Contact> dubEmails = [];
    var i = 0;
    while (i < contacts.length) {
      var contact = contacts[i];
      var emails = contact.emails;
      emails?.forEach((email) {
        for (var cont in contacts) {
          var contEmails = cont.emails?.map((e) => e.value).toList();
          if (cont != contact && contEmails?.contains(email.value) == true) {
            if (!dubEmails.contains(contact)) {
              dubEmails.add(contact);
              bloc.add(
                  NewEmailsFoundEvent(contactsEmailsSize: dubEmails.length));
            }
            if (!dubEmails.contains(cont)) {
              dubEmails.add(cont);
              bloc.add(
                  NewEmailsFoundEvent(contactsEmailsSize: dubEmails.length));
            }
          }
        }
      });
      i++;
    }
    bloc.add(AllEmailsFoundEvent(contactsEmailsSize: dubEmails.length));
    return dubEmails;
  }

  getNoNameContacts() async {
    List<Contact> contacts = [];
    if (await Permission.contacts.request().isGranted) {
      // bloc.add(StartScanningContactsEvent()); //TODO: start search
      contacts = await ContactsService.getContacts();
      // bloc.add(FinishScanningContactsEvent(contactsSize: contacts.length));
    }
    List<Contact> filterredContacts = [];
    var index = 0;
    while (index < contacts.length - 1) {
      var currentElement = contacts[index];

      if (currentElement.displayName?.isEmpty == true ||
          currentElement.displayName == null) {
        filterredContacts.add(contacts[index]);
        bloc.add(
            NewNoNamesFoundEvent(contactsNoNameSize: filterredContacts.length));
        filterredContacts.add(contacts[index + 1]);
        bloc.add(
            AllNoNamesFoundEvent(contactsNoNameSize: filterredContacts.length));
      }
      index++;
    }
    bloc.add(
        AllNoNamesFoundEvent(contactsNoNameSize: filterredContacts.length));
    return filterredContacts;
  }

  getNoPhoneContacts() async {
    List<Contact> contacts = [];
    if (await Permission.contacts.request().isGranted) {
      // bloc.add(StartScanningContactsEvent()); //TODO: start search
      contacts = await ContactsService.getContacts();
      // bloc.add(FinishScanningContactsEvent(contactsSize: contacts.length));
    }
    List<Contact> filterredContacts = [];
    var index = 0;
    while (index < contacts.length - 1) {
      var currentElement = contacts[index];

      if (currentElement.phones?.isEmpty == true ||
          currentElement.phones == null) {
        filterredContacts.add(contacts[index]);
        bloc.add(NewNoPhonesFoundEvent(
            contactsNoPhonesSize: filterredContacts.length));

        filterredContacts.add(contacts[index + 1]);

        bloc.add(NewNoPhonesFoundEvent(
            contactsNoPhonesSize: filterredContacts.length));
      }
      index++;
    }
    bloc.add(
        AllNoPhonesFoundEvent(contactsNoPhonesSize: filterredContacts.length));
    return filterredContacts;
  }

  int levenshtein(String s, String t, {bool caseSensitive = false}) {
    if (!caseSensitive) {
      s = s.toLowerCase();
      t = t.toLowerCase();
    }

    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<int> v0 = List<int>.filled(t.length + 1, 0);
    List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i < t.length + 1; i < i++) {
      v0[i] = i;
    }

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;

      for (int j = 0; j < t.length; j++) {
        int cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = min(v1[j] + 1, min(v0[j + 1] + 1, v0[j] + cost));
      }

      for (int j = 0; j < t.length + 1; j++) {
        v0[j] = v1[j];
      }
    }

    return v1[t.length];
  }

  double similarity(String s1, String s2) {
    //0.0- 1.0
    String longer = s1, shorter = s2;
    if (s1.length < s2.length) {
      longer = s2;
      shorter = s1;
    }
    int longerLength = longer.length;
    if (longerLength == 0) return 1.0;

    return (longerLength - levenshtein(longer, shorter)) /
        longerLength.toDouble();
  }

  getSimilarContacts() async {
    List<Contact> contacts = [];
    if (await Permission.contacts.request().isGranted) {
      // bloc.add(StartScanningContactsEvent()); //TODO: start search
      contacts = await ContactsService.getContacts();
      // bloc.add(FinishScanningContactsEvent(contactsSize: contacts.length));
    }
    List<Contact> filteredContacts = [];
    var j = 1;
    for (Contact currentElement in contacts) {
      if (currentElement.displayName != null) {
        for (int i = j; i < contacts.length; i++) {
          Contact element = contacts[i];
          if (element.displayName != null) {
            var res =
                similarity(currentElement.displayName!, element.displayName!);
            if (res >= 0.75 && res < 1.0) {
              if (!filteredContacts.contains(currentElement)) {
                filteredContacts.add(currentElement);
                bloc.add(NewSimilarFoundEvent(
                    contactsSimilarSize: filteredContacts.length));
              }
              if (!filteredContacts.contains(element)) {
                filteredContacts.add(element);
                bloc.add(NewSimilarFoundEvent(
                    contactsSimilarSize: filteredContacts.length));
              }
            }
          }
        }
      }
      j++;
    }

    return filteredContacts;
  }
}
