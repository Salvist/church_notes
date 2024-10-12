import 'package:church_notes/domain/models/verse.dart';
import 'package:equatable/equatable.dart';

class BibleReference extends Equatable {
  final String bookName;
  final int chapter;
  final int verseStart;
  final int? verseEnd;

  final int matchStart;
  final int matchEnd;

  const BibleReference({
    required this.bookName,
    required this.chapter,
    required this.verseStart,
    this.verseEnd,
    required this.matchStart,
    required this.matchEnd,
  });

  @override
  String toString() {
    final verseRange = verseEnd == null ? '$verseStart' : '$verseStart-$verseEnd';
    return '$bookName $chapter:$verseRange';
  }

  @override
  List<Object?> get props => [bookName, chapter, verseStart, verseEnd, matchStart, matchEnd];
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
