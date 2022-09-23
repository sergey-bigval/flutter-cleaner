import 'package:flutter_bloc/flutter_bloc.dart';

import '../contacts_event.dart';
import '../contacts_repo.dart';
import '../contacts_state.dart';

class CategoryBloc extends Bloc<ContactsEvent, ContactsState> {
  late final ContactsRepo contactsRepo;

  CategoryBloc() : super(ContactsState.initial()) {
    contactsRepo = ContactsRepo(bloc: this)
      ..getAllContacts()
      // ..getDubNames()
      ..getDubEmails();
      // ..getNoNameContacts()
      // ..getNoPhoneContacts()
      // ..getDubPhones()
      // ..getSimilarContacts();

    on<StartScanningContactsEvent>(_onContactsLoadingEvent);
    on<FinishScanningContactsEvent>(_onContactsLoadedEvent);

    on<NewEmailsFoundEvent>(_onEmailsFoundEvent);
    on<AllEmailsFoundEvent>(_onAllEmailsFoundEvent);

    // on<NewDubNamesFoundEvent>(_onNamesFoundEvent);
    // on<AllDubsNamesFoundEvent>(_onAllNamesFoundEvent);

    // on<NewDubPhonesFoundEvent>(_onPhonesFoundEvent);
    // on<AllDubsPhonesFoundEvent>(_onAllPhonesFoundEvent);

    // on<NewNoNamesFoundEvent>(_onNoNameFoundEvent);
    // on<AllNoNamesFoundEvent>(_onAllNoNameFoundEvent);

    // on<NewNoPhonesFoundEvent>(_onNoPhoneFoundEvent);
    // on<AllNoPhonesFoundEvent>(_onAllNoPhoneFoundEvent);

    // on<NewSimilarFoundEvent>(_onSimilarFoundEvent);
    // on<AllSimilarFoundEvent>(_onAllSimilarFoundEvent);
  }

  Future<void> _onContactsLoadingEvent(
      StartScanningContactsEvent event,
      Emitter emitter,
      ) async {
    emitter(state.copyWith(isAllContScanning: true));
  }

  Future<void> _onContactsLoadedEvent(
      FinishScanningContactsEvent event,
      Emitter emitter,
      ) async {
    emitter(state.copyWith(
      isAllContScanning: false,
      allContactsSize: event.contactsSize,
    ));
  }

  Future<void> _onEmailsFoundEvent(NewEmailsFoundEvent event,
      Emitter emitter,) async {
    emitter(state.copyWith(
        isDubEmailContScanning: false,
        dubEmailContactsSize: event.contactsEmailsSize
    ));
  }

  Future<void> _onAllEmailsFoundEvent(AllEmailsFoundEvent event,
      Emitter emitter,) async {
    emitter(state.copyWith(
      isDubEmailContScanning: false,
      dubEmailContactsSize: event.contactsEmailsSize,
    ));
  }

  // Future<void> _onSimilarFoundEvent(NewSimilarFoundEvent event,
  //     Emitter emitter,) async {
  //   emitter(state.copyWith(
  //       isScanning: false,
  //       similarFound: event.contactsSimilarSize
  //   ));
  // }
  //
  // Future<void> _onAllSimilarFoundEvent(AllSimilarFoundEvent event,
  //     Emitter emitter,) async {
  //   emitter(state.copyWith(
  //     isScanning: false,
  //     similarFound: event.contactsSimilarSize,
  //   ));
  // }
  //
  // Future<void> _onNoPhoneFoundEvent(NewNoPhonesFoundEvent event,
  //     Emitter emitter,) async {
  //   emitter(state.copyWith(
  //       isScanning: false,
  //       noPhoneFound: event.contactsNoPhonesSize
  //   ));
  // }
  //
  // Future<void> _onAllNoPhoneFoundEvent(AllNoPhonesFoundEvent event,
  //     Emitter emitter,) async {
  //   emitter(state.copyWith(
  //     isScanning: false,
  //     noPhoneFound: event.contactsNoPhonesSize,
  //   ));
  // }
  //
  // Future<void> _onNoNameFoundEvent(NewNoNamesFoundEvent event,
  //     Emitter emitter,) async {
  //   emitter(state.copyWith(
  //       isScanning: false,
  //       noNameFound: event.contactsNoNameSize
  //   ));
  // }
  //
  // Future<void> _onAllNoNameFoundEvent(AllNoNamesFoundEvent event,
  //     Emitter emitter,) async {
  //   emitter(state.copyWith(
  //     isScanning: false,
  //     noNameFound: event.contactsNoNameSize,
  //   ));
  // }
  //
  // Future<void> _onPhonesFoundEvent(NewDubPhonesFoundEvent event,
  //     Emitter emitter,) async {
  //   emitter(state.copyWith(
  //       isScanning: false,
  //       phonesFound: event.contactsPhonesSize
  //   ));
  // }
  //
  // Future<void> _onAllPhonesFoundEvent(AllDubsPhonesFoundEvent event,
  //     Emitter emitter,) async {
  //   emitter(state.copyWith(
  //     isScanning: false,
  //     phonesFound: event.contactsPhonesSize,
  //   ));
  // }
  //
  // Future<void> _onNamesFoundEvent(NewDubNamesFoundEvent event,
  //     Emitter emitter,) async {
  //   emitter(state.copyWith(
  //       isScanning: false,
  //       namesFound: event.contactsNameSize
  //   ));
  // }
  //
  // Future<void> _onAllNamesFoundEvent(AllDubsNamesFoundEvent event,
  //     Emitter emitter,) async {
  //   emitter(state.copyWith(
  //     isScanning: false,
  //     namesFound: event.contactsNamesSize,
  //   ));
  // }
}
