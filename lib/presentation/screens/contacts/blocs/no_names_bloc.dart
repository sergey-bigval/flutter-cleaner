import 'package:flutter_bloc/flutter_bloc.dart';

import 'contacts_event.dart';
import 'contacts_repo.dart';
import 'contacts_state.dart';

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
