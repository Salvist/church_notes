import 'package:church_notes/domain/enums/bible_version.dart';
import 'package:church_notes/domain/models/passage.dart';
import 'package:church_notes/domain/repositories/bible_repository.dart';
import 'package:church_notes/presentation/verse_lookup/cubit/verse_lookup_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';

class VerseLookupCubit extends Cubit<VerseLookupState> {
  final BibleRepository _bibleRepository;
  VerseLookupCubit(this._bibleRepository, this.bibleVersion) : super(const VerseLookupSuccess());

  BibleVersion bibleVersion;
  final referencesInNote = <BibleReference, int>{};

  Future<List<BibleReference>> getBibleReferences(String text, {BibleVersion? version}) async {
    final bookNames = await _bibleRepository.getBookNames(version ?? bibleVersion);

    final regex = RegExp(r'(\d?(?:\d\s)?[A-Za-z]+(?:\s[A-Za-z]+)*)\s(\d{1,3}):(\d{1,3})(?:-(\d{1,3}))?');
    final matches = regex.allMatches(text).where((element) => bookNames.contains(element.group(1)));
    final references = matches.map((match) {
      final bookName = match.group(1)!;
      final chapter = int.parse(match.group(2)!);
      final verseStart = int.parse(match.group(3)!);
      final verseEnd = int.tryParse(match.group(4) ?? '');
      return BibleReference(
        bookName: bookName,
        chapter: chapter,
        verseStart: verseStart,
        verseEnd: verseEnd,
        version: version ?? bibleVersion,
        matchStart: match.start,
        matchEnd: match.end,
      );
    }).toList();

    return references;
  }

  Future<void> getPassages(QuillController noteController) async {
    emit(const VerseLookupLoading());
    final content = noteController.document.toPlainText();
    final bibleReferences = await getBibleReferences(content);

    for (final reference in bibleReferences) {
      final x = content.characters.elementAtOrNull(reference.matchEnd);
      final y = content.characters.elementAtOrNull(reference.matchEnd + 1);
      final hasSpace = x == '\n' && (y == null || y == '\n');

      if (hasSpace) {
        final passage = await _bibleRepository.getPassage(reference);

        noteController.document.insert(
          reference.matchEnd,
          '\n${passage.versesText}',
        );
      } else {
        final passage = await _bibleRepository.getPassage(reference);
        final verses = getVersesRecursively(reference.matchEnd, content);

        noteController.document.replace(
          reference.matchEnd,
          verses.length,
          '\n${passage.versesText}',
        );
      }
    }
    emit(const VerseLookupSuccess());
  }

  String getVersesRecursively(int matchEnd, String content) {
    final nextLineIndex = content.indexOf('\n', matchEnd + 1);
    final a = content.substring(matchEnd, nextLineIndex);
    final y = content.characters.elementAtOrNull(matchEnd + a.length + 1);
    final hasMoreVerse = int.tryParse(y ?? '') != null;

    if (!hasMoreVerse) {
      return a;
    }
    return '$a\n${getVersesRecursively(matchEnd + a.length + 1, content)}';
  }
}
