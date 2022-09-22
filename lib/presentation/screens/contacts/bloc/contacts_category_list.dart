import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/all_contacts.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/contacts_state.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/double_contacts.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/double_emails.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/double_phone.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/no_phone.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/no_name.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/similar_name.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../utils/contacts_utils.dart';
import 'contacts_bloc.dart';

class ContactsInfo extends StatefulWidget {
  const ContactsInfo({super.key});

  @override
  State<ContactsInfo> createState() => _ContactsInfoState();

}

class _ContactsInfoState extends State<ContactsInfo> {
  late ContactsBloc _blocContacts;
  late EmailsBloc _blocEmails;
  late NamesBloc _blocNames;
  late PhonesBloc _blocPhones;
  late NoNameBloc _noNameBloc;
  late NoPhonesBloc _noPhonesBloc;
  late SimilarBloc _similarBloc;
  // late PhonesBloc _phonesBloc;
  // late ContactsBloc _bloc;
  // late ContactsBloc _bloc;
  // late ContactsBloc _bloc;
  // late ContactsBloc _bloc;
  // late ContactsBloc _bloc;

  bool contactsLoaded = false;//TODO: should be deleted

  int dubNamesSize = 0;
  List<Contact> _dubNames = [];

  int dubPhonesSize = 0;
  List<Contact> _dubPhones = [];

  int allContSize = 0;
  List<Contact> _allContacts = [];

  int dubEmailsSize = 0;
  List<Contact> _dubEmails = [];

  int similarContactsSize = 0;
  List<Contact> _similarContacts = [];

  int noNameContactsSize = 0;
  List<Contact> _noNames = [];

  int noPhoneContactsSize = 0;
  List<Contact> _noPhones = [];

  @override
  void initState() {
    super.initState();
    _blocContacts = ContactsBloc();
    _blocEmails = EmailsBloc();
    _blocNames = NamesBloc();
    _blocPhones = PhonesBloc();
    _noPhonesBloc = NoPhonesBloc();
    _noNameBloc = NoNameBloc();
    _similarBloc = SimilarBloc();
  }

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
        body: _myListView(),
      ),
    );
  }

  Widget _myListView() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text('All Contacts'),
          subtitle: const Text('See more'),
          leading: const Icon(
            Icons.people,
            color: Colors.blueAccent,
          ),
          trailing: BlocBuilder<ContactsBloc, ContactsState>(
          bloc: _blocContacts,
          buildWhen: (previous, current) => previous.isScanning != current.isScanning,
          builder: (BuildContext context, state) {
            if (state.isScanning) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const <Widget>[
                       SizedBox(
                         child: SizedBox(
                           height: 20.0,
                           width: 20.0,
                           child: CircularProgressIndicator(),
                         ),
                       )
                ],
              );
            } else {
              return BlocBuilder<ContactsBloc, ContactsState>(
                bloc: _blocContacts,
                buildWhen: (previous, current) =>
                previous.isScanning != current.isScanning,
                builder: (BuildContext context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(state.contactSize.toString())
                    ],
                  );
                }
              );
            }

          }
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AllContacts(
                      titles: 'All contacts', allContacts: _allContacts);
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
          trailing: BlocBuilder<NamesBloc, NamesState>(
              bloc: _blocNames,
              buildWhen: (previous, current) => previous.isScanning != current.isScanning,
              builder: (BuildContext context, state) {
                if (state.isScanning) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const <Widget>[
                      SizedBox(
                        child: SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    ],
                  );
                } else {
                  return BlocBuilder<NamesBloc, NamesState>(
                      bloc: _blocNames,
                      buildWhen: (previous, current) =>
                      previous.isScanning != current.isScanning,
                      builder: (BuildContext context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(state.namesSize.toString())
                          ],
                        );
                      }
                  );
                }

              }
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DoubleContacts(
                      titles: 'Duplicate contacts', dubContacts: _dubNames);
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
          trailing: BlocBuilder<PhonesBloc, PhonesState>(
              bloc: _blocPhones,
              buildWhen: (previous, current) => previous.isScanning != current.isScanning,
              builder: (BuildContext context, state) {
                if (state.isScanning) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const <Widget>[
                      SizedBox(
                        child: SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    ],
                  );
                } else {
                  return BlocBuilder<PhonesBloc, PhonesState>(
                      bloc: _blocPhones,
                      buildWhen: (previous, current) =>
                      previous.isScanning != current.isScanning,
                      builder: (BuildContext context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(state.phoneSize.toString())
                          ],
                        );
                      }
                  );
                }

              }
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DoublePhones(
                    titles: 'Duplicate phones',
                    dubPhones: _dubPhones,
                  );
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
          trailing: BlocBuilder<EmailsBloc, EmailsState>(
              bloc: _blocEmails,
              buildWhen: (previous, current) => previous.isScanning != current.isScanning,
              builder: (BuildContext context, state) {
                if (state.isScanning) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const <Widget>[
                      SizedBox(
                        child: SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    ],
                  );
                } else {
                  return BlocBuilder<EmailsBloc, EmailsState>(
                      bloc: _blocEmails,
                      buildWhen: (previous, current) =>
                      previous.isScanning != current.isScanning,
                      builder: (BuildContext context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(state.emailsSize.toString())
                          ],
                        );
                      }
                  );
                }

              }
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DoubleEmails(
                      titles: 'Duplicate Emails', dubEmails: _dubEmails);
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
          trailing: BlocBuilder<SimilarBloc, SimilarState>(
              bloc: _similarBloc,
              buildWhen: (previous, current) => previous.isScanning != current.isScanning,
              builder: (BuildContext context, state) {
                if (state.isScanning) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const <Widget>[
                      SizedBox(
                        child: SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    ],
                  );
                } else {
                  return BlocBuilder<SimilarBloc, SimilarState>(
                      bloc: _similarBloc,
                      buildWhen: (previous, current) =>
                      previous.isScanning != current.isScanning,
                      builder: (BuildContext context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(state.similarSize.toString())
                          ],
                        );
                      }
                  );
                }

              }
          ),
           onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SimilarContacts(
                      titles: 'Similar names',
                      similarContacts: _similarContacts);
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
          trailing: BlocBuilder<NoNameBloc, NoNameState>(
              bloc: _noNameBloc,
              buildWhen: (previous, current) => previous.isScanning != current.isScanning,
              builder: (BuildContext context, state) {
                if (state.isScanning) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const <Widget>[
                      SizedBox(
                        child: SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    ],
                  );
                } else {
                  return BlocBuilder<NoNameBloc, NoNameState>(
                      bloc: _noNameBloc,
                      buildWhen: (previous, current) =>
                      previous.isScanning != current.isScanning,
                      builder: (BuildContext context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(state.noNameSize.toString())
                          ],
                        );
                      }
                  );
                }

              }
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EmptyContacts(titles: 'No names', noNames: _noNames);
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
          trailing: BlocBuilder<NoPhonesBloc, NoPhonesState>(
              bloc: _noPhonesBloc,
              buildWhen: (previous, current) => previous.isScanning != current.isScanning,
              builder: (BuildContext context, state) {
                if (state.isScanning) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const <Widget>[
                      SizedBox(
                        child: SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    ],
                  );
                } else {
                  return BlocBuilder<NoPhonesBloc, NoPhonesState>(
                      bloc: _noPhonesBloc,
                      buildWhen: (previous, current) =>
                      previous.isScanning != current.isScanning,
                      builder: (BuildContext context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(state.noPhonesSize.toString())
                          ],
                        );
                      }
                  );
                }

              }
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EmptyPhone(titles: 'No phones', noPhones: _noPhones);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
