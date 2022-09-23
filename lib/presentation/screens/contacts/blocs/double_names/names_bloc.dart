import 'package:flutter_bloc/flutter_bloc.dart';

import '../contacts_event.dart';
import '../contacts_repo.dart';
import '../contacts_state.dart';

// class NamesBloc extends Bloc<ContactsEvent, NamesState> {
//   late final ContactsRepo contactsRepo;
//
//   NamesBloc() : super(NamesState.initial()) {
//     contactsRepo = ContactsRepo(bloc: this)
//       ..getDubNames();
//
//     on<NewDubNamesFoundEvent>(_onNamesFoundEvent);
//     on<AllDubsNamesFoundEvent>(_onAllNamesFoundEvent);
//   }
//
//   Future<void> _onNamesFoundEvent(NewDubNamesFoundEvent event,
//       Emitter emitter,) async {
//     emitter(state.copyWith(
//         isScanning: false,
//         namesFound: event.contactsNameSize
//     ));
//   }
//
//   Future<void> _onAllNamesFoundEvent(AllDubsNamesFoundEvent event,
//       Emitter emitter,) async {
//     emitter(state.copyWith(
//       isScanning: false,
//       namesFound: event.contactsNamesSize,
//     ));
//   }
// }
