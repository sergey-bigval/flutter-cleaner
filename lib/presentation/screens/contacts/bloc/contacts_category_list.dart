
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

import '../../../../utils/logging.dart';
class ContactsInfo extends StatefulWidget {
  const ContactsInfo({super.key});

  @override
  State<ContactsInfo> createState() => _ContactsInfoState();
}

class _ContactsInfoState extends State<ContactsInfo> {
  int dubNamesSize = 0;
  List<Contact> _dubNames = [];

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
        if (!filterredContacts.contains(contacts[index+1])) {
          filterredContacts.add(contacts[index + 1]);
        }
      }

      index++;
    }

    return filterredContacts;
  }

  getAllContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts());
    var dubNames = getDubNames(_contacts);

    setState(() {
      dubNamesSize = dubNames.length;
      _dubNames = dubNames;
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
            children: const [
              Text('4')
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AllContacts(titles: 'All contacts');
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
            children: [
              Text(dubNamesSize.toString())
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DoubleContacts(titles: 'Duplicate contacts', dubContacts: _dubNames);
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
            children: const [
              Text('5')
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DoublePhones(titles: 'Duplicate phones');
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
            children: const [
              Text('7')
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DoubleEmails(titles: 'Duplicate Emails');
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
            children: const [
              Text('8')
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SimilarContacts(titles: 'Similar names');
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
            children: const [
              Text('8')
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EmptyContacts(titles: 'No names');
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
            children: const [
              Text('8')
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EmptyPhone(titles: 'No phones');
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

// class BodyListView extends StatelessWidget {
//   var dubContactsSize;
//
//   BodyListView(int dubContactsSize) {
//     this.dubContactsSize = dubContactsSize;
//   }
//
//   Widget build(BuildContext context) {
//     return _myListView(context, dubContactsSize);
//   }
// }
