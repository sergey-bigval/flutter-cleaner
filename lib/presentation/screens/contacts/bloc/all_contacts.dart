import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'contact_list.dart';

class AllContacts extends StatefulWidget {
  AllContacts({Key? key, title, required this.titles, required this.allContacts}) : super(key: key);

  final String titles;
  List<Contact> allContacts;

  @override
  State<AllContacts> createState() => _AllContactsState(allContacts);
}

class _AllContactsState extends State<AllContacts> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = Map();
  TextEditingController searchController = TextEditingController();
  bool contactsLoaded = true;

  _AllContactsState(List<Contact> allContacts) {
    contacts = allContacts;
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
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    prefixIcon: Icon(Icons.search,
                        color: Theme.of(context).primaryColor)),
              ),
            ),
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
                        padding: EdgeInsets.only(top: 40),
                )
                : Container(
                    // still loading contacts
                    padding: EdgeInsets.only(top: 40),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
