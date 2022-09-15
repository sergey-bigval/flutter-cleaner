import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../utils/logging.dart';
import 'contact_list.dart';

class DoublePhones extends StatefulWidget {
  DoublePhones({Key?key,title, required this.titles, required this.dubPhone}) : super(key: key);

  final String titles;
  List<Contact> dubPhone;


  @override
  State<DoublePhones> createState() => _DoublePhonesState();
}

class _DoublePhonesState extends State<DoublePhones> {
  List<Contact> phone = [];
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

    List<Contact> _contacts = (await ContactsService.getContacts());
    List<Contact> dubPhones = [];
    var i = 0;
    while(i < _contacts.length) {
      var contact = _contacts[i];
      var phones = contact.phones;
      phones?.forEach((phone) {
        lol('email is ${phone.value} hash ${contact.hashCode}');
        _contacts.forEach((cont) {
          var contPhones = cont.phones?.map((e) => e.value).toList();
          lol('${cont != contact} ${contPhones?.contains(phone.value) == true}');
          if(cont != contact && contPhones?.contains(phone.value) == true) {
            if(!dubPhones.contains(contact)) dubPhones.add(contact);
            if(!dubPhones.contains(cont)) dubPhones.add(cont);
          }
        });
      });
      i++;
    }

    setState(() {
      phone = dubPhones;
      contactsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemsExist = (
        (isSearching == true && contactsFiltered.length > 0) ||
            (isSearching != true && phone.length > 0)
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
              reloadContacts: () {
                getAllContacts();
              },
              contacts: isSearching == true ? contactsFiltered : phone,
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
