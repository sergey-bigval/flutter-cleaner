import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../utils/logging.dart';
import 'contact_list.dart';

class DoubleEmails extends StatefulWidget {
  DoubleEmails({Key? key, title, required this.titles, required this.dubEmail}) : super(key: key);

  final String titles;
  List<Contact> dubEmail;

  @override
  State<DoubleEmails> createState() => _DoubleEmailsState();
}

class _DoubleEmailsState extends State<DoubleEmails> {
  List<Contact> emails = [];
  List<Contact> emailsFiltered = [];
  Map<String, Color> emailsColorMap = Map();
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
    List<Contact> dubEmails = [];
    var i = 0;
    while (i < _contacts.length) {
      var contact = _contacts[i];
      var emails = contact.emails;
      emails?.forEach((email) {
        lol('email is ${email.value} hash ${contact.hashCode}');
        _contacts.forEach((cont) {
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

    setState(() {
      emails = dubEmails;
      contactsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemsExist = ((isSearching == true && emailsFiltered.length > 0) ||
        (isSearching != true && emails.length > 0));
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
                    EmailList(
                        reloadContacts: () {
                          getAllContacts();
                        },
                        contacts: isSearching == true ? emailsFiltered : emails,
                      )
                    : Container(
                        padding: const EdgeInsets.only(top: 40),
                        child: Text(
                          isSearching
                              ? 'No search results to show'
                              : 'No emails exist',
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
