
class ContactsState {
  final bool isScanning;
  final int contactSize;

  ContactsState({
    required this.isScanning,
    required this.contactSize,
  });

  factory ContactsState.initial() => ContactsState(
    isScanning: false,
    contactSize: 0,
  );

  ContactsState copyWith({
    bool? isScanning,
    int? contactsFound,

  }) {
    return ContactsState(
      isScanning: isScanning ?? this.isScanning,
      contactSize: contactsFound ?? contactSize,
    );
  }
}
class EmailsState {
  final bool isScanning;
  final int emailsSize;

  EmailsState({
    required this.isScanning,
    required this.emailsSize,
  });

  factory EmailsState.initial() => EmailsState(
    isScanning: true,
    emailsSize: 0,
  );

  EmailsState copyWith({
    bool? isScanning,
    int? emailsFound,

  }) {
    return EmailsState(
      isScanning: isScanning ?? this.isScanning,
      emailsSize: emailsFound ?? emailsSize,
    );
  }
}
class NamesState {
  final bool isScanning;
  final int namesSize;

  NamesState({
    required this.isScanning,
    required this.namesSize,
  });

  factory NamesState.initial() => NamesState(
    isScanning: true,
    namesSize: 0,
  );

  NamesState copyWith({
    bool? isScanning,
    int? namesFound,

  }) {
    return NamesState(
      isScanning: isScanning ?? this.isScanning,
      namesSize: namesFound ?? namesSize,
    );
  }
}
class PhonesState {
  final bool isScanning;
  final int phoneSize;

  PhonesState({
    required this.isScanning,
    required this.phoneSize,
  });

  factory PhonesState.initial() => PhonesState(
    isScanning: true,
    phoneSize: 0,
  );

  PhonesState copyWith({
    bool? isScanning,
    int? phonesFound,

  }) {
    return PhonesState(
      isScanning: isScanning ?? this.isScanning,
      phoneSize: phonesFound ?? phoneSize,
    );
  }
}
class NoNameState {
  final bool isScanning;
  final int noNameSize;

  NoNameState({
    required this.isScanning,
    required this.noNameSize,
  });

  factory NoNameState.initial() => NoNameState(
    isScanning: true,
    noNameSize: 0,
  );

  NoNameState copyWith({
    bool? isScanning,
    int? noNameFound,

  }) {
    return NoNameState(
      isScanning: isScanning ?? this.isScanning,
      noNameSize: noNameFound ?? noNameSize,
    );
  }
}
class NoPhonesState {
  final bool isScanning;
  final int noPhonesSize;

  NoPhonesState({
    required this.isScanning,
    required this.noPhonesSize,
  });

  factory NoPhonesState.initial() => NoPhonesState(
    isScanning: true,
    noPhonesSize: 0,
  );

  NoPhonesState copyWith({
    bool? isScanning,
    int? noPhoneFound,

  }) {
    return NoPhonesState(
      isScanning: isScanning ?? this.isScanning,
      noPhonesSize: noPhoneFound ?? noPhonesSize,
    );
  }
}
class SimilarState {
  final bool isScanning;
  final int similarSize;

  SimilarState({
    required this.isScanning,
    required this.similarSize,
  });

  factory SimilarState.initial() => SimilarState(
    isScanning: true,
    similarSize: 0,
  );

  SimilarState copyWith({
    bool? isScanning,
    int? similarFound,

  }) {
    return SimilarState(
      isScanning: isScanning ?? this.isScanning,
      similarSize: similarFound ?? similarSize,
    );
  }
}

