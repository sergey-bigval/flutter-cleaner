
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/all_contacts.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/double_contacts.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/double_emails.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/double_phone.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/no_phone.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/no_name.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/similar_name.dart';

import '../../../../utils/logging.dart';
class ContactsInfo extends StatefulWidget {
  const ContactsInfo({super.key});

  @override
  State<ContactsInfo> createState() => _ContactsInfoState();
}

class _ContactsInfoState extends State<ContactsInfo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListView',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.indigo[500],
        accentColor: Colors.amber[500],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
          centerTitle: true,
        ),
        body: BodyListView(),
      ),
    );
  }
}

class BodyListView extends StatelessWidget {
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}
Widget _myListView(BuildContext context) {
  return ListView(
    children: <Widget>[
      ListTile(
        title: const Text('All Contacts'),
        subtitle: const Text('See more'),
        leading: const Icon(
          Icons.people,
          color: Colors.blueAccent,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text('4')
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AllContacts(titles: 'All contacts');
              },
            ),
          );
        },
      ),
      ListTile(
        title: const Text('Duplicate Contacts'),
        subtitle: const Text('See more'),
        leading: const Icon(
          Icons.contact_phone,
          color: Colors.blueAccent,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text('5')
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DoubleContacts(titles: 'Duplicate contacts');
              },
            ),
          );
        },
      ),
      ListTile(
        title: const Text('Duplicate Phones'),
        subtitle: const Text('See more'),
        leading: const Icon(
          Icons.phone_sharp,
          color: Colors.blueAccent,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text('5')
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DoublePhones(titles: 'Duplicate phones');
              },
            ),
          );
        },
      ),
      ListTile(
        title: const Text('Duplicate Emails'),
        subtitle: const Text('See more'),
        leading: const Icon(
          Icons.email,
          color: Colors.blueAccent,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text('7')
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DoubleEmails(titles: 'Duplicate Emails');
              },
            ),
          );
        },
      ),
      ListTile(
        title: const Text('Similar names'),
        subtitle: const Text('See more'),
        leading: const Icon(
          Icons.sort_by_alpha,
          color: Colors.blueAccent,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text('8')
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return SimilarContacts(titles: 'Similar names');
              },
            ),
          );
        },
      ),
      ListTile(
        title: const Text('No names'),
        subtitle: const Text('See more'),
        leading: const Icon(
          Icons.no_accounts,
          color: Colors.blueAccent,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text('8')
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return EmptyContacts(titles: 'No names');
              },
            ),
          );
        },
      ),
      ListTile(
        title: const Text('No phones'),
        subtitle: const Text('See more'),
        leading: const Icon(
          Icons.no_cell,
          color: Colors.blueAccent,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text('8')
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return EmptyPhone(titles: 'No phones');
              },
            ),
          );
        },
      ),
    ],
  );
}