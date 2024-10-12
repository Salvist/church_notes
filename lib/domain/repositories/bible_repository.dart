import 'package:church_notes/domain/models/passage.dart';

abstract interface class BibleRepository {
  Future<Passage> getPassage(BibleReference reference);
}
