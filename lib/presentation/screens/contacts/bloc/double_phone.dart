import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'contact_list.dart';

class DoublePhones extends StatefulWidget {
  DoublePhones({Key?key,title, required this.titles, required this.dubPhones}) : super(key: key);

  final String titles;
  List<Contact> dubPhones;

  @override
  State<DoublePhones> createState() => _DoublePhonesState(dubPhones);
}

class _DoublePhonesState extends State<DoublePhones> {
  List<Contact> phones = [];
  List<Contact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = Map();
  TextEditingController searchController = TextEditingController();
  bool contactsLoaded = true;

  _DoublePhonesState(List<Contact> dubPhones) {
    phones = dubPhones;
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemsExist = (
        (isSearching == true && contactsFiltered.length > 0) ||
            (isSearching != true && phones.length > 0)
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titles),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            contactsLoaded == true ?  // if the contacts have not been loaded yet
            listItemsExist == true ?  // if we have contacts to show
            PhoneList(
              reloadContacts: () {},
              contacts: isSearching == true ? contactsFiltered : phones,
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
