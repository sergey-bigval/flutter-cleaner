import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/all_contacts.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/double_contacts.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/double_emails.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/double_phone.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/no_phone.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/no_name.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/similar_name.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dart_levenshtein/dart_levenshtein.dart';

import '../../../../utils/logging.dart';
import 'contact_list.dart';

class ContactsInfo extends StatefulWidget {
  const ContactsInfo({super.key});

  @override
  State<ContactsInfo> createState() => _ContactsInfoState();
}

class _ContactsInfoState extends State<ContactsInfo> {
  bool contactsLoaded = false;

  int dubNamesSize = 0;
  List<Contact> _dubNames = [];

  int dubPhonesSize = 0;
  List<Contact> _dubPhones = [];

  int allContSize = 0;
  List<Contact> _allContacts = [];

  int dubEmailsSize = 0;
  List<Contact> _dubEmails = [];

  int similarContactsSize = 0;
  List<Contact> _similarContacts = [];

  int noNameContactsSize = 0;
  List<Contact> _noName = [];

  int noPhoneContactsSize = 0;
  List<Contact> _noPhone = [];

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      getAllContacts();
    }
  }

  Future<double> similarity(String s1, String s2) async {   //0.0- 1.0
    String longer = s1, shorter = s2;
    if (s1.length < s2.length) {
      longer = s2;
      shorter = s1;
    }
    int longerLength = longer.length;
    if (longerLength == 0)  return 1.0;
    // If you have StringUtils, you can use it to calculate the edit distance:
    return (longerLength - (await longer.levenshteinDistance(shorter))) /
        longerLength.toDouble();
  }

  List<Contact> getDubNames(List<Contact> contacts) {
    contacts.sort((m1, m2) {
      if (m1.displayName == null) return -1;
      if (m2.displayName == null) return 1;

      return m1.displayName!
          .toLowerCase()
          .compareTo(m2.displayName!.toLowerCase());
    });
    for (var element in contacts) {
      lol('${element.displayName} ${element.hashCode}');
    }
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
        lol('email is ${phone.value} hash ${contact.hashCode}');
        contacts.forEach((cont) {
          var contPhones = cont.phones?.map((e) => e.value).toList();
          lol('${cont != contact} ${contPhones?.contains(phone.value) == true}');
          if (cont != contact && contPhones?.contains(phone.value) == true) {
            if (!dubPhones.contains(contact)) dubPhones.add(contact);
            if (!dubPhones.contains(cont)) dubPhones.add(cont);
          }
        });
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
        lol('email is ${email.value} hash ${contact.hashCode}');
        contacts.forEach((cont) {
          var contEmails = cont.emails?.map((e) => e.value).toList();
          lol('${cont != contact} ${contEmails?.contains(email.value) == true}');
          if (cont != contact && contEmails?.contains(email.value) == true) {
            if (!dubEmails.contains(contact)) dubEmails.add(contact);
            if (!dubEmails.contains(cont)) dubEmails.add(cont);
          }
        });
      });
      i++;
    }
    return dubEmails;
  }

  List<Contact> getSimilarContacts(List<Contact> contacts) {
    List<Contact> filterredContacts = [];
    var index = 0;
    while (index < contacts.length - 1) {
      var currentElement = contacts[index];
      contacts.forEach((element)  async {
        if(currentElement.displayName != null &&
            (await similarity(currentElement.displayName!, element.displayName!)) >= 0.75) {
          if(!filterredContacts.contains(currentElement)) filterredContacts.add(currentElement);
          if(!filterredContacts.contains(element)) filterredContacts.add(element);
        }
      });
      index++;
    }
    return filterredContacts;
  }

  List<Contact> getNoNameContacts(List<Contact> contacts) {
    List<Contact> filterredContacts = [];
    var index = 0;
    while (index < contacts.length - 1) {
      var currentElement = contacts[index];
      var nextElement = contacts[index + 1];
      // lol(' index $index show display names ${currentElement.hashCode} | ${nextElement.hashCode}');
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
      var nextElement = contacts[index + 1];
      lol(' index $index show display names ${currentElement.hashCode} | ${nextElement.hashCode}');
      if (currentElement.phones?.isEmpty == true ||
          currentElement.phones == null) {
        filterredContacts.add(contacts[index]);
        filterredContacts.add(contacts[index + 1]);
      }
      index++;
    }

    return filterredContacts;
  }

  getAllContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts());
    var dubNames = getDubNames(_contacts);
    var dubPhones = getDubPhones(_contacts);
    var dubEmails = getDubEmails(_contacts);
    // var similarContacts = getSimilarContacts(_contacts);
    var noName = getNoNameContacts(_contacts);
    var noPhone = getNoPhoneContacts(_contacts);

    setState(() {
      contactsLoaded = true;
      allContSize = _contacts.length;

      dubNamesSize = dubNames.length;
      _dubNames = dubNames;

      dubPhonesSize = dubPhones.length;
      _dubPhones = dubPhones;

      dubEmailsSize = dubEmails.length;
      _dubEmails = dubEmails;

      // similarContactsSize = similarContacts.length;
      // _similarContacts = similarContacts;

      noNameContactsSize = noName.length;
      _noName = noName;

      noPhoneContactsSize = noPhone.length;
      _noPhone = noPhone;
    });
  }

  @override
  Widget build(BuildContext context) {
    lol('build');
    return MaterialApp(
      title: 'ListView',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.indigo[500],
        accentColor: Colors.amber[500],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
          centerTitle: true,
        ),
        body: _myListView(),
      ),
    );
  }

  Widget _myListView() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text('All Contacts'),
          subtitle: const Text('See more'),
          leading: const Icon(
            Icons.people,
            color: Colors.blueAccent,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              contactsLoaded == true
                  ? // if we have contacts to show
                  Text(allContSize.toString())
                  : Container(
                      // still loading contacts
                      child: const SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(),
                      ),
                    )
            ],
          ),
          // trailing: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children:  [Text(allContSize.toString())],
          // ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AllContacts(
                      titles: 'All contacts', allContacts: _allContacts);
                },
              ),
            );
          },
        ),
        ListTile(
          title: const Text('Duplicate Contacts'),
          subtitle: const Text('See more'),
          leading: const Icon(
            Icons.contact_phone,
            color: Colors.blueAccent,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              contactsLoaded == true
                  ? // if we have contacts to show
              Text(dubNamesSize.toString())
                  : Container(
                // still loading contacts
                child: const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          ),
          // trailing: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [Text(dubNamesSize.toString())],
          // ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DoubleContacts(
                      titles: 'Duplicate contacts', dubContacts: _dubNames);
                },
              ),
            );
          },
        ),
        ListTile(
          title: const Text('Duplicate Phones'),
          subtitle: const Text('See more'),
          leading: const Icon(
            Icons.phone_sharp,
            color: Colors.blueAccent,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              contactsLoaded == true
                  ? // if we have contacts to show
              Text(dubPhonesSize.toString())
                  : Container(
                // still loading contacts
                child: const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          ),          // trailing: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [Text(dubPhonesSize.toString())],
          // ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DoublePhones(
                    titles: 'Duplicate phones',
                    dubPhone: _dubPhones,
                  );
                },
              ),
            );
          },
        ),
        ListTile(
          title: const Text('Duplicate Emails'),
          subtitle: const Text('See more'),
          leading: const Icon(
            Icons.email,
            color: Colors.blueAccent,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              contactsLoaded == true
                  ? // if we have contacts to show
              Text(dubEmailsSize.toString())
                  : Container(
                // still loading contacts
                child: const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          ),          // trailing: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [Text(dubEmailsSize.toString())],
          // ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DoubleEmails(
                      titles: 'Duplicate Emails', dubEmail: _dubEmails);
                },
              ),
            );
          },
        ),
        ListTile(
          title: const Text('Similar names'),
          subtitle: const Text('See more'),
          leading: const Icon(
            Icons.sort_by_alpha,
            color: Colors.blueAccent,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              contactsLoaded == true
                  ? // if we have contacts to show
              Text(similarContactsSize.toString())
                  : Container(
                // still loading contacts
                child: const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          ),          // trailing: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [Text(similarContactsSize.toString())],
          // ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SimilarContacts(
                      titles: 'Similar names',
                      similarContacts: _similarContacts);
                },
              ),
            );
          },
        ),
        ListTile(
          title: const Text('No names'),
          subtitle: const Text('See more'),
          leading: const Icon(
            Icons.no_accounts,
            color: Colors.blueAccent,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              contactsLoaded == true
                  ? // if we have contacts to show
              Text(noNameContactsSize.toString())
                  : Container(
                // still loading contacts
                child: const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          ),          // trailing: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children:  [Text(noNameContactsSize.toString())],
          // ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EmptyContacts(titles: 'No names', noName: _noName);
                },
              ),
            );
          },
        ),
        ListTile(
          title: const Text('No phones'),
          subtitle: const Text('See more'),
          leading: const Icon(
            Icons.no_cell,
            color: Colors.blueAccent,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              contactsLoaded == true
                  ? // if we have contacts to show
              Text(noPhoneContactsSize.toString())
                  : Container(
                // still loading contacts
                child: const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          ),          // trailing: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children:  [Text(noPhoneContactsSize.toString())],
          // ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EmptyPhone(titles: 'No phones', noPhone: _noPhone);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
