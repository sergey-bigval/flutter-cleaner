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
import '../../../../utils/contacts_utils.dart';

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
  List<Contact> _noNames = [];

  int noPhoneContactsSize = 0;
  List<Contact> _noPhones = [];

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

  getAllContacts() async {
    List<Contact> _contacts = await ContactsService.getContacts();
    var dubNames = getDubNames(_contacts);
    var dubPhones = getDubPhones(_contacts);
    var dubEmails = getDubEmails(_contacts);
    var similarContacts = getSimilarContacts(_contacts);
    var noNames = getNoNameContacts(_contacts);
    var noPhones = getNoPhoneContacts(_contacts);

    setState(() {
      contactsLoaded = true;
      allContSize = _contacts.length;
      _allContacts = _contacts;

      dubNamesSize = dubNames.length;
      _dubNames = dubNames;

      dubPhonesSize = dubPhones.length;
      _dubPhones = dubPhones;

      dubEmailsSize = dubEmails.length;
      _dubEmails = dubEmails;

      similarContactsSize = similarContacts.length;
      _similarContacts = similarContacts;

      noNameContactsSize = noNames.length;
      _noNames = noNames;

      noPhoneContactsSize = noPhones.length;
      _noPhones = noPhones;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DoublePhones(
                    titles: 'Duplicate phones',
                    dubPhones: _dubPhones,
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
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DoubleEmails(
                      titles: 'Duplicate Emails', dubEmails: _dubEmails);
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
          ),
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
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EmptyContacts(titles: 'No names', noNames: _noNames);
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
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EmptyPhone(titles: 'No phones', noPhones: _noPhones);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
