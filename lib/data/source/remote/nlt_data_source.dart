import 'dart:developer';

import 'package:church_notes/domain/models/passage.dart';
import 'package:church_notes/domain/models/verse.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

const _baseUrl = 'https://api.nlt.to';
const _apiKey = String.fromEnvironment('NLT_API');

class NLTDataSource {
  const NLTDataSource();

  Future<Passage> getPassage(BibleReference reference) async {
    var verseRange = '${reference.verseStart}';
    if (reference.verseEnd != null) verseRange += '-${reference.verseEnd}';

    final queryParameters = <String, String>{
      'key': _apiKey,
      'ref': '${reference.bookName}.${reference.chapter}.$verseRange',
    };
    final url = Uri.https('api.nlt.to', '/api/passages', queryParameters);

    final response = await http.get(url);
    log(response.body);

    final verses = parseBibleVerses(response.body);

    return Passage(
      reference: reference,
      verses: verses,
    );
  }

// Function to parse the HTML and map to an array of Verse objects
  List<Verse> parseBibleVerses(String htmlResponse) {
    // Parse the HTML
    Document document = html_parser.parse(htmlResponse);

    // Extract the book name and chapter number
    String bookName = document.querySelector('h2 .cw')?.text ?? 'Unknown';
    int chapter = int.tryParse(document.querySelector('h2 .cw_ch')?.text ?? '0') ?? 0;

    // Find all the <p> elements with verse content
    // List<Element> verseElements = document.querySelectorAll('div#bibletext p');
    List<Element> verseElements = document.querySelectorAll('verse_export[orig]');

    // Initialize an empty map to store combined verse text
    Map<int, String> verseMap = {};

    // Loop through each verse element and combine text for the same verse
    for (Element verseElement in verseElements) {
      // Extract the verse number and text
      int verseNumber = int.tryParse(verseElement.querySelector('.vn')?.text ?? '0') ?? 0;
      String verseText = verseElement.text.replaceFirst(RegExp(r'^\d+'), '').trim();

      verseElement.querySelectorAll('span').forEach((element) {
        verseText = verseText.replaceAll(element.text, '');
      });
      print('THIS IS A VERSE: ${verseText}');

      // Combine text for verses that span multiple paragraphs
      if (verseMap.containsKey(verseNumber)) {
        verseMap[verseNumber] = '$verseText';
      } else {
        verseMap[verseNumber] = verseText;
      }
    }

    // Convert the map to a list of Verse objects
    List<Verse> verses = verseMap.entries.map((entry) {
      return Verse(
        bookName: bookName,
        chapter: chapter,
        verse: entry.key,
        text: entry.value.trim(),
      );
    }).toList();

    return verses;
  }
}
