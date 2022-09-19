import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'contact_list.dart';

class DoubleEmails extends StatefulWidget {
  DoubleEmails({Key? key, title, required this.titles, required this.dubEmails}) : super(key: key);

  final String titles;
  List<Contact> dubEmails;

  @override
  State<DoubleEmails> createState() => _DoubleEmailsState(dubEmails);
}

class _DoubleEmailsState extends State<DoubleEmails> {
  List<Contact> emails = [];
  List<Contact> emailsFiltered = [];
  Map<String, Color> emailsColorMap = Map();
  TextEditingController searchController = TextEditingController();
  bool contactsLoaded = true;

  _DoubleEmailsState(List<Contact> dubEmails) {
    emails = dubEmails;
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
                        reloadContacts: () {},
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
