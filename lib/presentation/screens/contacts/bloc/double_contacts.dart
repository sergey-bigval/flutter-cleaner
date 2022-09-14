
import 'dart:collection';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../utils/logging.dart';
import 'contact_list.dart';

class DoubleContacts extends StatefulWidget {
  DoubleContacts({Key?key,title, required this.titles}) : super(key: key);

  final String titles;

  @override
  State<DoubleContacts> createState() => _DoubleContactsState();
}

class _DoubleContactsState extends State<DoubleContacts> {
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
      // searchController.addListener(() {
        // filterContacts();
      // });
    }
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  getAllContacts() async {
    // List colors = [
    //   Colors.green,
    //   Colors.indigo,
    //   Colors.yellow,
    //   Colors.orange
    // ];
    // int colorIndex = 0;
    List<Contact> _contacts = (await ContactsService.getContacts());
    // List<AppContact> _contacts = (await ContactsService.getContacts()).map((contact) {
    //   Color baseColor = colors[colorIndex];
    //   colorIndex++;
    //
    //   if (colorIndex == colors.length) {
    //     colorIndex = 0;
    //   }
    //   return new AppContact(info: contact, color: baseColor);
    // }).toList();

    _contacts.sort((m1, m2) {
      if(m1.displayName == null) return -1;
      if(m2.displayName == null) return 1;

      return m1.displayName!.toLowerCase().compareTo(m2.displayName!.toLowerCase());
    });
    for (var element in _contacts) { lol('${element.displayName} ${element.hashCode}');}
    List<Contact> filterredContacts = [];
    var index = 0;
    while(index < _contacts.length -1) {
      var currentElement = _contacts[index];
      var nextElement = _contacts[index+1];
      lol(' index $index show display names ${currentElement.hashCode} | ${nextElement.hashCode}');
      if(currentElement.displayName?.toLowerCase() ==  nextElement.displayName?.toLowerCase()) {
        // lol('index ${index} ${_contacts[index].info.displayName} | ${_contacts[index+1].info.displayName}');
        if(!filterredContacts.contains(_contacts[index])) {
          filterredContacts.add(_contacts[index]);
        }
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
    bool listItemsExist = (
        (isSearching == true && contactsFiltered.length > 0) ||
            (isSearching != true && contacts.length > 0)
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titles),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            contactsLoaded == true ?  // if the contacts have not been loaded yet
            listItemsExist == true ?  // if we have contacts to show
            ContactsList(
              reloadContacts: () {
                getAllContacts();
              },
              contacts: isSearching == true ? contactsFiltered : contacts,
            ) : Container(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  isSearching ?'No search results to show' : 'No contacts exist',
                  style: const TextStyle(color: Colors.grey, fontSize: 20),
                )
            ) :
            Container(  // still loading contacts
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
