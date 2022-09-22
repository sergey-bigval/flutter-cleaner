import 'package:hello_flutter/presentation/screens/contacts/bloc/contact_list.dart';

class ContactsState {
  final bool isScanning;
  final int contactSize;

  ContactsState({
    required this.isScanning,
    required this.contactSize,
  });

  factory ContactsState.initial() => ContactsState(
    isScanning: false,
    contactSize: 0,
  );

  ContactsState copyWith({
    bool? isScanning,
    int? contactsFound,

  }) {
    return ContactsState(
      isScanning: isScanning ?? this.isScanning,
      contactSize: contactsFound ?? contactSize,
    );
  }
}
class EmailsState {
  final bool isScanning;
  final int emailsSize;

  EmailsState({
    required this.isScanning,
    required this.emailsSize,
  });

  factory EmailsState.initial() => EmailsState(
    isScanning: true,
    emailsSize: 0,
  );

  EmailsState copyWith({
    bool? isScanning,
    int? emailsFound,

  }) {
    return EmailsState(
      isScanning: isScanning ?? this.isScanning,
      emailsSize: emailsFound ?? emailsSize,
    );
  }
}

