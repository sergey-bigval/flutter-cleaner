import 'package:flutter_bloc/flutter_bloc.dart';

import 'contacts_event.dart';
import 'contacts_repo.dart';
import 'contacts_state.dart';

class CategoryBloc extends Bloc<ContactsEvent, ContactsState> {
  late final ContactsRepo contactsRepo;

  CategoryBloc() : super(ContactsState.initial()) {
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
