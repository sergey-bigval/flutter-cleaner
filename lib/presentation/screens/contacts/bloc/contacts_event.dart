import 'contacts_state.dart';

abstract class ContactsEvent {}
class StartScanningContactsEvent extends ContactsEvent {}
class FinishScanningContactsEvent extends ContactsEvent {
  int contactsSize = 0;
  FinishScanningContactsEvent({required this.contactsSize});
}
