import 'package:flutter_bloc/flutter_bloc.dart';

import 'contacts_event.dart';
import 'contacts_repo.dart';
import 'contacts_state.dart';

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
