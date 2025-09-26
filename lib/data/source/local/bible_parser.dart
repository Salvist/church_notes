import 'dart:convert';

import 'package:church_notes/domain/models/verse.dart';
import 'package:flutter/services.dart';

class BibleParser {
  const BibleParser._();

  static Future<List<Verse>> parseKJV(String biblePath) async {
    final kjvBible = await rootBundle.loadString(biblePath);
    final bibleJSON = jsonDecode(kjvBible) as Map<String, dynamic>;
    final verses = bibleJSON.entries.map((e) => parseKJVVerse(e)).toList();
    return verses;
  }

  static Verse parseKJVVerse(MapEntry<String, dynamic> kjvVerse) {
    final bookAndChapter = kjvVerse.key.split(' ');
    final chapterAndVerse = bookAndChapter.last.split(':');
    final bookName = bookAndChapter[0];
    final chapter = chapterAndVerse[0];
    final verse = chapterAndVerse[1];

    final text = kjvVerse.value
        .replaceAll('#', '')
        .replaceAll('[', '')
        .replaceAll(']', '');
    final parsedVerse = Verse(
      bookName: bookName,
      chapter: int.parse(chapter),
      verse: int.parse(verse),
      text: text,
    );
    return parsedVerse;
  }
}
