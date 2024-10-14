import 'package:church_notes/domain/enums/language.dart';

enum BibleVersion {
  asv('ASV', Language.english),
  tb('TB', Language.indonesian);

  final String code;
  final Language language;
  const BibleVersion(this.code, this.language);
}
