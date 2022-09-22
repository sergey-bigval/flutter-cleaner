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
