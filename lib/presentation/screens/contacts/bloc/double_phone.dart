import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../utils/logging.dart';
import 'contact_list.dart';

class DoublePhones extends StatefulWidget {
  DoublePhones({Key?key,title, required this.titles}) : super(key: key);

  final String titles;

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

    // _contacts.sort((m1, m2) {
    //   if(m1.emails == null) return -1;
    //   if(m2.emails == null) return 1;
    //
    //   // return m1.emails.compareTo(m2.emails);
    //   return 0;
    // });
    // for (var element in _contacts) { lol('${element.emails} ${element.hashCode}');}
    // List<Contact> filterredContacts = [];
    // var index = 0;
    // while(index < _contacts.length -1) {
    //   var currentElement = _contacts[index];
    //   var nextElement = _contacts[index+1];
    //   // lol(' index $index show display names ${currentElement.hashCode} | ${nextElement.hashCode}');
    //   if(currentElement.emails ==  nextElement.emails) {
    //     // lol('index ${index} ${_contacts[index].info.displayName} | ${_contacts[index+1].info.displayName}');
    //     if(!filterredContacts.contains(_contacts[index])) {
    //       filterredContacts.add(_contacts[index]);
    //     }
    //     filterredContacts.add(_contacts[index + 1]);
    //   }
    //
    //   index++;
    // }
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
