
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../utils/logging.dart';
import 'contact_list.dart';
import 'model.dart';

class DoubleContacts extends StatefulWidget {
  DoubleContacts({Key?key,title, required this.titles}) : super(key: key);

  final String titles;

  @override
  State<DoubleContacts> createState() => _DoubleContactsState();
}

class _DoubleContactsState extends State<DoubleContacts> {
  List<AppContact> contacts = [];
  List<AppContact> contactsFiltered = [];
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
      searchController.addListener(() {
        filterContacts();
      });
    }
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  getAllContacts() async {
    List colors = [
      Colors.green,
      Colors.indigo,
      Colors.yellow,
      Colors.orange
    ];
    int colorIndex = 0;
    List<AppContact> _contacts = (await ContactsService.getContacts()).map((contact) {
      Color baseColor = colors[colorIndex];
      colorIndex++;

      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
      return new AppContact(info: contact, color: baseColor);
    }).toList();

    _contacts.sort((m1, m2) {
      if(m1.info.displayName == null) return -1;
      if(m2.info.displayName == null) return 1;

      return m1.info.displayName!.toLowerCase().compareTo(m2.info.displayName!.toLowerCase());
    });
    _contacts.forEach((element) { lol('${element.info.displayName}');});
    List<AppContact> filterredContacts = [];
    var index = 0;
    while(index < _contacts.length -1) {
      var currentElement = _contacts[index];
      var nextElement = _contacts[index+1];
      // lol('show display names ${currentElement.info.displayName} | ${nextElement.info.displayName}');
      if(currentElement.info.displayName?.toLowerCase() ==  nextElement.info.displayName?.toLowerCase()) {
        filterredContacts.add(_contacts[index]);
        filterredContacts.add(_contacts[index + 1]);
      }

      index++;
    }

    setState(() {
      // contacts = _contacts;
      contacts = filterredContacts;
      contactsLoaded = true;
    });
  }

  filterContacts() {
    List<AppContact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.info.displayName!.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }

        if (searchTermFlatten.isEmpty) {
          return false;
        }

        var phone = contact.info.phones!.firstWhere((phn) {
          String phnFlattened = flattenPhoneNumber(phn.value.toString());
          return phnFlattened.contains(searchTermFlatten);
        });

        return phone != null;
      });
    }
    setState(() {
      contactsFiltered = _contacts;
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
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            // Container(
            //   child: TextField(
            //     // controller: searchController,
            //     // decoration: InputDecoration(
            //     //     // labelText: 'Search',
            //     //     border: OutlineInputBorder(
            //     //         borderSide: BorderSide(
            //     //             color: Theme.of(context).primaryColor
            //     //         )
            //     //     ),
            //     //     // prefixIcon: Icon(
            //     //     //     Icons.search,
            //     //     //     color: Theme.of(context).primaryColor
            //     //     // )
            //     // ),
            //   ),
            // ),
            contactsLoaded == true ?  // if the contacts have not been loaded yet
            listItemsExist == true ?  // if we have contacts to show
            ContactsList(
              reloadContacts: () {
                getAllContacts();
              },
              contacts: isSearching == true ? contactsFiltered : contacts,
            ) : Container(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  isSearching ?'No search results to show' : 'No contacts exist',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                )
            ) :
            Container(  // still loading contacts
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
