import 'package:church_notes/domain/models/passage.dart';
import 'package:church_notes/domain/repositories/bible_repository.dart';
import 'package:church_notes/presentation/onboarding/2_how_to/cubit/passage_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PassageCubit extends Cubit<PassageState> {
  final BibleRepository _bibleRepository;
  PassageCubit(this._bibleRepository) : super(const PassageInitial());

  void fetchPassage(BibleReference reference) async {
    try {
      final passage = await _bibleRepository.getPassage(reference);
      emit(PassageSuccess(passage));
    } catch (e) {
      emit(const PassageFailure());
    }
  }
}
