import 'package:church_notes/domain/models/passage.dart';

sealed class PassageState {
  const PassageState();
}

class PassageInitial extends PassageState {
  const PassageInitial();
}

class PassageLoading extends PassageState {
  const PassageLoading();
}

class PassageSuccess extends PassageState {
  final Passage passage;
  const PassageSuccess(this.passage);
}

class PassageFailure extends PassageState {
  const PassageFailure();
}
