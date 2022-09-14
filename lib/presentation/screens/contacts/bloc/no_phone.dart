import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../utils/logging.dart';
import 'contact_list.dart';

class EmptyPhone extends StatefulWidget {
  EmptyPhone({Key? key, title, required this.titles}) : super(key: key);

  final String titles;

  @override
  State<EmptyPhone> createState() => _EmptyPhoneState();
}

class _EmptyPhoneState extends State<EmptyPhone> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = Map();
  TextEditingController searchController = TextEditingController();
  bool contactsLoaded = false;

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
    List<Contact> _contacts = (await ContactsService.getContacts());

    for (var element in _contacts) {
      lol('${element.displayName} ${element.hashCode}');
    }
    List<Contact> filterredContacts = [];
    var index = 0;
    while (index < _contacts.length - 1) {
      var currentElement = _contacts[index];
      var nextElement = _contacts[index + 1];
      lol(' index $index show display names ${currentElement.hashCode} | ${nextElement.hashCode}');
      if ( currentElement.phones?.isEmpty == true || currentElement.phones == null) {
        filterredContacts.add(_contacts[index]);
        filterredContacts.add(_contacts[index + 1]);
      }
      index++;
    }

    setState(() {
      contacts = filterredContacts;
      contactsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemsExist =
    ((isSearching == true && contactsFiltered.length > 0) ||
        (isSearching != true && contacts.length > 0));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titles),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            contactsLoaded == true
                ? // if the contacts have not been loaded yet
            listItemsExist == true
                ? // if we have contacts to show
            ContactsList(
              reloadContacts: () {
                getAllContacts();
              },
              contacts:
              isSearching == true ? contactsFiltered : contacts,
            )
                : Container(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  isSearching
                      ? 'No search results to show'
                      : 'No contacts exist',
                  style:
                  const TextStyle(color: Colors.grey, fontSize: 20),
                ))
                : Container(
              // still loading contacts
              padding: const EdgeInsets.only(top: 40),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
