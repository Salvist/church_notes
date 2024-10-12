sealed class VerseLookupState {
  const VerseLookupState();

  bool get isLoading => this == const VerseLookupLoading();
}

class VerseLookupLoading extends VerseLookupState {
  const VerseLookupLoading();
}

class VerseLookupSuccess extends VerseLookupState {
  const VerseLookupSuccess();
}

class VerseLookupFailure extends VerseLookupState {
  const VerseLookupFailure();
}
