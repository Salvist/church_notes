import 'package:church_notes/domain/enums/bible_version.dart';
import 'package:church_notes/domain/models/passage.dart';

abstract interface class BibleRepository {
  Future<List<String>> getBookNames(BibleVersion version);
  Future<Passage> getPassage(BibleReference reference);
}
