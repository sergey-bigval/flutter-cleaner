import 'package:flutter_bloc/flutter_bloc.dart';

import 'contacts_event.dart';
import 'contacts_repo.dart';
import 'contacts_state.dart';

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
