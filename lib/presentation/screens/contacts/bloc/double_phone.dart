import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'contact_list.dart';
import 'model.dart';

class DoublePhones extends StatefulWidget {
  DoublePhones({Key?key,title, required this.titles}) : super(key: key);

  final String titles;

  @override
  State<DoublePhones> createState() => _DoublePhonesState();
}

class _DoublePhonesState extends State<DoublePhones> {
  List<AppContact> contacts = [];
  List<AppContact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = Map();
  // TextEditingController searchController = TextEditingController();
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
      //   filterContacts();
      // });
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
    setState(() {
      contacts = _contacts;
      contactsLoaded = true;
    });
  }

  filterContacts() {
    List<AppContact> _contacts = [];
    _contacts.addAll(contacts);
    // if (searchController.text.isNotEmpty) {
    //   _contacts.retainWhere((contact) {
    //     String searchTerm = searchController.text.toLowerCase();
    //     String searchTermFlatten = flattenPhoneNumber(searchTerm);
    //     String contactName = contact.info.displayName!.toLowerCase();
    //     bool nameMatches = contactName.contains(searchTerm);
    //     if (nameMatches == true) {
    //       return true;
    //     }
    //
    //     if (searchTermFlatten.isEmpty) {
    //       return false;
    //     }
    //
    //     var phone = contact.info.phones!.firstWhere((phn) {
    //       String phnFlattened = flattenPhoneNumber(phn.value.toString());
    //       return phnFlattened.contains(searchTermFlatten);
    //     });
    //
    //     return phone != null;
    //   });
    // }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    // bool isSearching = searchController.text.isNotEmpty;
    // bool listItemsExist = (
    //     (isSearching == true && contactsFiltered.length > 0) ||
    //         (isSearching != true && contacts.length > 0)
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titles),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   backgroundColor: Theme.of(context).primaryColorDark,
      //   onPressed: () async {
      //     try {
      //       Contact contact = await ContactsService.openContactForm();
      //       if (contact != null) {
      //         getAllContacts();
      //       }
      //     } on FormOperationException catch (e) {
      //       switch(e.errorCode) {
      //         case FormOperationErrorCode.FORM_OPERATION_CANCELED:
      //         case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
      //         case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
      //           print(e.toString());
      //       }
      //     }
      //   },
      // ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              // child: TextField(
              //   // controller: searchController,
              //   decoration: InputDecoration(
              //       // labelText: 'Search',
              //       border: OutlineInputBorder(
              //           borderSide: BorderSide(
              //               color: Theme.of(context).primaryColor
              //           )
              //       ),
              //       // prefixIcon: Icon(
              //       //     Icons.search,
              //       //     color: Theme.of(context).primaryColor
              //       // )
              //   ),
              // ),
            ),
            // contactsLoaded == true ?  // if the contacts have not been loaded yet
            // listItemsExist == true ?  // if we have contacts to show
            ContactsList(
              reloadContacts: () {
                getAllContacts();
              },
              contacts: contacts,
            ) ,
            Container(
                padding: EdgeInsets.only(top: 40),
                // child: Text(
                //   'No contacts exist',
                //   style: TextStyle(color: Colors.grey, fontSize: 20),
                // )
            ),
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
