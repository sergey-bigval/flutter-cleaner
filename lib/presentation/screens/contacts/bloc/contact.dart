import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../utils/constants.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contacts")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
                onPressed: checkContacts,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueAccent),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: const Text("Press for contacts searching"))
          ],
        ),
      ),
    );
  }

  Future<void> checkContacts() async {
    if (await Permission.contacts.request().isGranted) {
      Navigator.pushNamed(context, contactsInfo);
    } else {}
  }
}
