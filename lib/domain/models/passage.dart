import 'package:church_notes/domain/enums/bible_version.dart';
import 'package:church_notes/domain/models/verse.dart';
import 'package:equatable/equatable.dart';

class BibleReference extends Equatable {
  final String bookName;
  final int chapter;
  final int verseStart;
  final int? verseEnd;
  final BibleVersion version;

  final int matchStart;
  final int matchEnd;

  const BibleReference({
    required this.bookName,
    required this.chapter,
    required this.verseStart,
    this.verseEnd,
    required this.matchStart,
    required this.matchEnd,
    required this.version,
  });

  @override
  String toString() {
    final verseRange = verseEnd == null ? '$verseStart' : '$verseStart-$verseEnd';
    return '$bookName $chapter:$verseRange';
  }

  @override
  List<Object?> get props => [bookName, chapter, verseStart, verseEnd, version, matchStart, matchEnd];
}

class Passage {
  final BibleReference reference;
  final List<Verse> verses;

  const Passage({
    required this.reference,
    required this.verses,
  });

  String get versesText => verses.map((e) => '$e').join("\n");

  @override
  String toString() => '$reference\n$verses';
}
