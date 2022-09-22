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

class NewDubNamesFoundEvent extends ContactsEvent {
  int contactsNameSize = 0;
  NewDubNamesFoundEvent({required this.contactsNameSize});
}
class AllDubsNamesFoundEvent extends ContactsEvent {
  int contactsNamesSize = 0;
  AllDubsNamesFoundEvent({required this.contactsNamesSize});
}

class NewDubPhonesFoundEvent extends ContactsEvent {
  int contactsPhonesSize = 0;
  NewDubPhonesFoundEvent({required this.contactsPhonesSize});
}
class AllDubsPhonesFoundEvent extends ContactsEvent {
  int contactsPhonesSize = 0;
  AllDubsPhonesFoundEvent({required this.contactsPhonesSize});
}

class NewNoNamesFoundEvent extends ContactsEvent {
  int contactsNoNameSize = 0;
  NewNoNamesFoundEvent({required this.contactsNoNameSize});
}
class AllNoNamesFoundEvent extends ContactsEvent {
  int contactsNoNameSize = 0;
  AllNoNamesFoundEvent({required this.contactsNoNameSize});
}

class NewNoPhonesFoundEvent extends ContactsEvent {
  int contactsNoPhonesSize = 0;
  NewNoPhonesFoundEvent({required this.contactsNoPhonesSize});
}
class AllNoPhonesFoundEvent extends ContactsEvent {
  int contactsNoPhonesSize = 0;
  AllNoPhonesFoundEvent({required this.contactsNoPhonesSize});
}

class NewSimilarFoundEvent extends ContactsEvent {
  int contactsSimilarSize = 0;
  NewSimilarFoundEvent({required this.contactsSimilarSize});
}
class AllSimilarFoundEvent extends ContactsEvent {
  int contactsSimilarSize = 0;
  AllSimilarFoundEvent({required this.contactsSimilarSize});
}
