import 'package:flutter_bloc/flutter_bloc.dart';

import 'contacts_event.dart';
import 'contacts_repo.dart';
import 'contacts_state.dart';

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
