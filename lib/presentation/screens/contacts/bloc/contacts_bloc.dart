  import 'package:flutter_bloc/flutter_bloc.dart';

  import 'contacts_event.dart';
  import 'contacts_repo.dart';
  import 'contacts_state.dart';

  class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
    late final ContactsRepo contactsRepo;

    ContactsBloc() : super(ContactsState.initial()) {
      contactsRepo = ContactsRepo(bloc: this)
        ..getAllContacts();

      on<StartScanningContactsEvent>(_onContactsLoadingEvent);
      on<FinishScanningContactsEvent>(_onContactsLoadedEvent);
    }


    Future<void> _onContactsLoadingEvent(StartScanningContactsEvent event,
        Emitter emitter,) async {
      emitter(state.copyWith(
        isScanning: true
      ));
    }

    Future<void> _onContactsLoadedEvent(FinishScanningContactsEvent event,
        Emitter emitter,) async {
      emitter(state.copyWith(
        isScanning: false,
        contactsFound: event.contactsSize,
      ));
    }
  }
  class EmailsBloc extends Bloc<ContactsEvent, EmailsState> {
    late final ContactsRepo contactsRepo;

    EmailsBloc() : super(EmailsState.initial()) {
      contactsRepo = ContactsRepo(bloc: this)
        ..getDubEmails();

      on<NewEmailsFoundEvent>(_onEmailsFoundEvent);
      on<AllEmailsFoundEvent>(_onAllEmailsFoundEvent);
    }

    Future<void> _onEmailsFoundEvent(NewEmailsFoundEvent event,
        Emitter emitter,) async {
      emitter(state.copyWith(
        isScanning: false,
        emailsFound: event.contactsEmailsSize
      ));
    }

    Future<void> _onAllEmailsFoundEvent(AllEmailsFoundEvent event,
        Emitter emitter,) async {
      emitter(state.copyWith(
        isScanning: false,
        emailsFound: event.contactsEmailsSize,
      ));
    }
  }
  class NamesBloc extends Bloc<ContactsEvent, NamesState> {
    late final ContactsRepo contactsRepo;

    NamesBloc() : super(NamesState.initial()) {
      contactsRepo = ContactsRepo(bloc: this)
        ..getDubNames();

      on<NewDubNamesFoundEvent>(_onNamesFoundEvent);
      on<AllDubsNamesFoundEvent>(_onAllNamesFoundEvent);
    }

    Future<void> _onNamesFoundEvent(NewDubNamesFoundEvent event,
        Emitter emitter,) async {
      emitter(state.copyWith(
        isScanning: false,
        namesFound: event.contactsNameSize
      ));
    }

    Future<void> _onAllNamesFoundEvent(AllDubsNamesFoundEvent event,
        Emitter emitter,) async {
      emitter(state.copyWith(
        isScanning: false,
        namesFound: event.contactsNamesSize,
      ));
    }
  }
  class PhonesBloc extends Bloc<ContactsEvent, PhonesState> {
    late final ContactsRepo contactsRepo;

    PhonesBloc() : super(PhonesState.initial()) {
      contactsRepo = ContactsRepo(bloc: this)
        ..getDubPhones();

      on<NewDubPhonesFoundEvent>(_onPhonesFoundEvent);
      on<AllDubsPhonesFoundEvent>(_onAllPhonesFoundEvent);
    }

    Future<void> _onPhonesFoundEvent(NewDubPhonesFoundEvent event,
        Emitter emitter,) async {
      emitter(state.copyWith(
        isScanning: false,
        phonesFound: event.contactsPhonesSize
      ));
    }

    Future<void> _onAllPhonesFoundEvent(AllDubsPhonesFoundEvent event,
        Emitter emitter,) async {
      emitter(state.copyWith(
        isScanning: false,
        phonesFound: event.contactsPhonesSize,
      ));
    }
  }
  class NoNameBloc extends Bloc<ContactsEvent, NoNameState> {
    late final ContactsRepo contactsRepo;

    NoNameBloc() : super(NoNameState.initial()) {
      contactsRepo = ContactsRepo(bloc: this)
        ..getNoNameContacts();

      on<NewNoNamesFoundEvent>(_onNoNameFoundEvent);
      on<AllNoNamesFoundEvent>(_onAllNoNameFoundEvent);
    }

    Future<void> _onNoNameFoundEvent(NewNoNamesFoundEvent event,
        Emitter emitter,) async {
      emitter(state.copyWith(
        isScanning: false,
        noNameFound: event.contactsNoNameSize
      ));
    }

    Future<void> _onAllNoNameFoundEvent(AllNoNamesFoundEvent event,
        Emitter emitter,) async {
      emitter(state.copyWith(
        isScanning: false,
        noNameFound: event.contactsNoNameSize,
      ));
    }
  }
  class NoPhonesBloc extends Bloc<ContactsEvent, NoPhonesState> {
    late final ContactsRepo contactsRepo;

    NoPhonesBloc() : super(NoPhonesState.initial()) {
      contactsRepo = ContactsRepo(bloc: this)
        ..getNoPhoneContacts();

      on<NewNoPhonesFoundEvent>(_onNoPhoneFoundEvent);
      on<AllNoPhonesFoundEvent>(_onAllNoPhoneFoundEvent);
    }

    Future<void> _onNoPhoneFoundEvent(NewNoPhonesFoundEvent event,
        Emitter emitter,) async {
      emitter(state.copyWith(
        isScanning: false,
        noPhoneFound: event.contactsNoPhonesSize
      ));
    }

    Future<void> _onAllNoPhoneFoundEvent(AllNoPhonesFoundEvent event,
        Emitter emitter,) async {
      emitter(state.copyWith(
        isScanning: false,
        noPhoneFound: event.contactsNoPhonesSize,
      ));
    }
  }
  class SimilarBloc extends Bloc<ContactsEvent, SimilarState> {
    late final ContactsRepo contactsRepo;

    SimilarBloc() : super(SimilarState.initial()) {
      contactsRepo = ContactsRepo(bloc: this)
        ..getSimilarContacts();

      on<NewSimilarFoundEvent>(_onSimilarFoundEvent);
      on<AllSimilarFoundEvent>(_onAllSimilarFoundEvent);
    }

    Future<void> _onSimilarFoundEvent(NewSimilarFoundEvent event,
        Emitter emitter,) async {
      emitter(state.copyWith(
        isScanning: false,
        similarFound: event.contactsSimilarSize
      ));
    }

    Future<void> _onAllSimilarFoundEvent(AllSimilarFoundEvent event,
        Emitter emitter,) async {
      emitter(state.copyWith(
        isScanning: false,
        similarFound: event.contactsSimilarSize,
      ));
    }
  }
