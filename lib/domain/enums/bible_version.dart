import 'package:church_notes/domain/enums/language.dart';

enum BibleVersion {
  asv('ASV', Language.english),
  // nlt('NLT', Language.english),
  tb('TB', Language.indonesian);

  final String code;
  final Language language;
  const BibleVersion(this.code, this.language);

  factory BibleVersion.byName(String name) {
    try {
      return values.byName(name);
    } catch (e) {
      return asv;
    }
  }
}

class BibleRules {
  final int? cacheLimit;
  const BibleRules({this.cacheLimit});
}
