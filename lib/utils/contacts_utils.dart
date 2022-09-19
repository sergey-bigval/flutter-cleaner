import 'package:contacts_service/contacts_service.dart';
import 'dart:math';

List<Contact> getDubNames(List<Contact> contacts) {
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
      }
      if (!filterredContacts.contains(contacts[index + 1])) {
        filterredContacts.add(contacts[index + 1]);
      }
    }

    index++;
  }
  return filterredContacts;
}

List<Contact> getDubPhones(List<Contact> contacts) {
  List<Contact> dubPhones = [];
  var i = 0;
  while (i < contacts.length) {
    var contact = contacts[i];
    var phones = contact.phones;
    phones?.forEach((phone) {
      for (var cont in contacts) {
        var contPhones = cont.phones?.map((e) => e.value).toList();
        if (cont != contact && contPhones?.contains(phone.value) == true) {
          if (!dubPhones.contains(contact)) dubPhones.add(contact);
          if (!dubPhones.contains(cont)) dubPhones.add(cont);
        }
      }
    });
    i++;
  }
  return dubPhones;
}

List<Contact> getDubEmails(List<Contact> contacts) {
  List<Contact> dubEmails = [];
  var i = 0;
  while (i < contacts.length) {
    var contact = contacts[i];
    var emails = contact.emails;
    emails?.forEach((email) {
      for (var cont in contacts) {
        var contEmails = cont.emails?.map((e) => e.value).toList();
        if (cont != contact && contEmails?.contains(email.value) == true) {
          if (!dubEmails.contains(contact)) dubEmails.add(contact);
          if (!dubEmails.contains(cont)) dubEmails.add(cont);
        }
      }
    });
    i++;
  }
  return dubEmails;
}

List<Contact> getNoNameContacts(List<Contact> contacts) {
  List<Contact> filterredContacts = [];
  var index = 0;
  while (index < contacts.length - 1) {
    var currentElement = contacts[index];

    if (currentElement.displayName?.isEmpty == true ||
        currentElement.displayName == null) {
      filterredContacts.add(contacts[index]);
      filterredContacts.add(contacts[index + 1]);
    }
    index++;
  }
  return filterredContacts;
}

List<Contact> getNoPhoneContacts(List<Contact> contacts) {
  List<Contact> filterredContacts = [];
  var index = 0;
  while (index < contacts.length - 1) {
    var currentElement = contacts[index];

    if (currentElement.phones?.isEmpty == true ||
        currentElement.phones == null) {
      filterredContacts.add(contacts[index]);
      filterredContacts.add(contacts[index + 1]);
    }
    index++;
  }

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

double similarity(String s1, String s2) {   //0.0- 1.0
  String longer = s1, shorter = s2;
  if (s1.length < s2.length) {
    longer = s2;
    shorter = s1;
  }
  int longerLength = longer.length;
  if (longerLength == 0)  return 1.0;

  return (longerLength - levenshtein(longer, shorter)) /
      longerLength.toDouble();
}

List<Contact> getSimilarContacts(List<Contact> contacts) {
  List<Contact> filterredContacts = [];
  var j = 1;
  for(Contact currentElement in contacts) {
    if(currentElement.displayName != null) {
      for (int i = j; i < contacts.length; i++) {
        Contact element = contacts[i];
        if(element.displayName != null) {
          var res = similarity(currentElement.displayName!, element.displayName!);
          if(res >= 0.75 && res < 1.0) {
            if(!filterredContacts.contains(currentElement)) filterredContacts.add(currentElement);
            if(!filterredContacts.contains(element)) filterredContacts.add(element);
          }
        }
      }
    }
    j++;
  }

  return filterredContacts;
}
