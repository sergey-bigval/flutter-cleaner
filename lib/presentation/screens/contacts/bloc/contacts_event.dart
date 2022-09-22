import 'contacts_state.dart';

abstract class ContactsEvent {}
class StartScanningContactsEvent extends ContactsEvent {}
class FinishScanningContactsEvent extends ContactsEvent {
  int contactsSize = 0;
  FinishScanningContactsEvent({required this.contactsSize});
}

class NewEmailsFoundEvent extends ContactsEvent {
  int contactsEmailsSize = 0;
  NewEmailsFoundEvent({required this.contactsEmailsSize});
}

class AllEmailsFoundEvent extends ContactsEvent {
  int contactsEmailsSize = 0;
  AllEmailsFoundEvent({required this.contactsEmailsSize});
}
