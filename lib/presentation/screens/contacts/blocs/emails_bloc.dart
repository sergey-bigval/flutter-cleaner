import 'package:flutter_bloc/flutter_bloc.dart';

import 'contacts_event.dart';
import 'contacts_repo.dart';
import 'contacts_state.dart';

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
