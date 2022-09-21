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

