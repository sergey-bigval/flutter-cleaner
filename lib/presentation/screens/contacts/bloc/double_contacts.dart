import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'contact_list.dart';

class DoubleContacts extends StatefulWidget {
  DoubleContacts({Key? key, title, required this.titles, required this.dubContacts}) : super(key: key);

  final String titles;
  List<Contact> dubContacts;

  @override
  State<DoubleContacts> createState() => _DoubleContactsState(dubContacts);
}

class _DoubleContactsState extends State<DoubleContacts> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = Map();
  TextEditingController searchController = TextEditingController();
  bool contactsLoaded = true;

  _DoubleContactsState(List<Contact> dubContacts) {
    contacts = dubContacts;
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
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            contactsLoaded == true
                ? // if the contacts have not been loaded yet
                listItemsExist == true
                    ? // if we have contacts to show
                    ContactsList(
                        reloadContacts: () {},
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
