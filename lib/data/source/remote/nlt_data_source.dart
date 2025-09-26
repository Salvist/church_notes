import 'dart:developer';

import 'package:church_notes/domain/models/passage.dart';
import 'package:church_notes/domain/models/verse.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

const _apiKey = String.fromEnvironment('NLT_API_KEY');

class NLTDataSource {
  const NLTDataSource();

  Future<Passage> getPassage(BibleReference reference) async {
    var verseRange = '${reference.verseStart}';
    if (reference.verseEnd != null) verseRange += '-${reference.verseEnd}';

    final queryParameters = <String, String>{
      'key': _apiKey,
      'ref': '${reference.bookName}.${reference.chapter}.$verseRange',
      'version': 'NLT',
    };
    final url = Uri.https('api.nlt.to', '/api/passages', queryParameters);

    final response = await http.get(url);
    log(response.body);

    final passageData = parsePassageFromHtml(reference, response.body);
    log(passageData.toString());
    return passageData;
  }

  // Function to parse the HTML and create a complete Passage object
  Passage parsePassageFromHtml(BibleReference reference, String htmlResponse) {
    // Parse the HTML
    Document document = html_parser.parse(htmlResponse);

    // Extract the book name and chapter from the header
    String bookName = 'Unknown';
    int chapter = 0;

    final headerElement = document.querySelector('h2.bk_ch_vs_header');
    if (headerElement != null) {
      final headerText = headerElement.text;
      // Parse "John 3:16-20, NLT" format
      final match = RegExp(
        r'^([A-Za-z]+)\s+(\d+):(\d+)(?:-(\d+))?',
      ).firstMatch(headerText);
      if (match != null) {
        bookName = match.group(1) ?? 'Unknown';
        chapter = int.tryParse(match.group(2) ?? '0') ?? 0;
      }
    }

    // Since the HTML is malformed, let's use a regex-based approach to extract verses
    List<Verse> verses = _extractVersesFromMalformedHtml(
      htmlResponse,
      bookName,
      chapter,
    );

    return Passage(reference: reference, verses: verses);
  }

  // Function to extract verses from malformed HTML using regex
  List<Verse> _extractVersesFromMalformedHtml(
    String htmlResponse,
    String bookName,
    int chapter,
  ) {
    List<Verse> verses = [];

    // Use regex to find all verse_export elements and their content
    final versePattern = RegExp(
      r'<verse_export[^>]*orig="[^"]*" bk="[^"]*" ch="[^"]*" vn="(\d+)"[^>]*>(.*?)</verse_export>',
      dotAll: true,
    );
    final matches = versePattern.allMatches(htmlResponse);

    for (final match in matches) {
      final verseNumber = int.tryParse(match.group(1) ?? '0') ?? 0;
      final verseContent = match.group(2) ?? '';

      if (verseNumber > 0) {
        // Extract text from the verse content
        String verseText = _extractTextFromVerseContent(verseContent);

        if (verseText.isNotEmpty) {
          verses.add(
            Verse(
              bookName: bookName,
              chapter: chapter,
              verse: verseNumber,
              text: verseText,
            ),
          );
        }
      }
    }

    // Sort verses by verse number
    verses.sort((a, b) => a.verse.compareTo(b.verse));

    return verses;
  }

  // Function to extract clean text from verse content
  String _extractTextFromVerseContent(String verseContent) {
    // First, remove all tn (footnote) elements from the HTML before parsing
    String cleanedContent = _removeFootnoteElements(verseContent);

    // Parse the cleaned verse content as HTML to extract text
    final document = html_parser.parse(cleanedContent);

    // Look for span.red elements first (for some verse formats)
    final redSpans = document.querySelectorAll('span.red');
    if (redSpans.isNotEmpty) {
      return _cleanVerseText(
        redSpans.map((span) => span.text.trim()).join(' '),
      );
    }

    // Look for p.body-ch-hd elements (for chapter headers with verses)
    final bodyElements = document.querySelectorAll('p.body-ch-hd');
    if (bodyElements.isNotEmpty) {
      String text = bodyElements.map((p) => p.text.trim()).join(' ');
      return _cleanVerseText(text);
    }

    // Look for p.ext-hanging-sp elements (for hanging paragraphs)
    final hangingElements = document.querySelectorAll('p.ext-hanging-sp');
    if (hangingElements.isNotEmpty) {
      String text = hangingElements.map((p) => p.text.trim()).join(' ');
      return _cleanVerseText(text);
    }

    // Look for p.body-ch elements (for chapter content)
    final bodyChElements = document.querySelectorAll('p.body-ch');
    if (bodyChElements.isNotEmpty) {
      String text = bodyChElements.map((p) => p.text.trim()).join(' ');
      return _cleanVerseText(text);
    }

    // Look for poetry elements (poet1-vn-hd, poet1-vn, poet1, poet2)
    final poetryElements = document.querySelectorAll(
      'p.poet1-vn-hd, p.poet1-vn, p.poet1, p.poet2',
    );
    if (poetryElements.isNotEmpty) {
      String text = poetryElements.map((p) => p.text.trim()).join(' ');
      return _cleanVerseText(text);
    }

    // Look for any p elements with body class
    final bodyPElements = document.querySelectorAll('p.body');
    if (bodyPElements.isNotEmpty) {
      String text = bodyPElements.map((p) => p.text.trim()).join(' ');
      return _cleanVerseText(text);
    }

    // Fallback: get all text and clean it up
    String text = document.outerHtml;

    // Remove HTML tags
    text = text.replaceAll(RegExp(r'<[^>]*>'), ' ');

    return _cleanVerseText(text);
  }

  // Helper function to remove unwanted elements from HTML (footnotes, subheads, chapter headers)
  String _removeFootnoteElements(String htmlContent) {
    String cleaned = htmlContent;

    // Remove <span class="tn">...</span> elements entirely
    cleaned = cleaned.replaceAll(
      RegExp(r'<span class="tn">.*?</span>', dotAll: true),
      '',
    );

    // Remove <h3 class="subhead">...</h3> elements entirely
    cleaned = cleaned.replaceAll(
      RegExp(r'<h3 class="subhead">.*?</h3>', dotAll: true),
      '',
    );

    // Remove <h2 class="chapter-number">...</h2> elements entirely
    cleaned = cleaned.replaceAll(
      RegExp(r'<h2 class="chapter-number">.*?</h2>', dotAll: true),
      '',
    );

    return cleaned;
  }

  // Helper function to clean verse text
  String _cleanVerseText(String text) {
    // Clean up extra whitespace first
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Remove verse number from the beginning (more aggressive pattern)
    text = text.replaceFirst(RegExp(r'^\s*\d+\s*'), '');

    // Remove footnote markers (asterisks and anything after them)
    text = text.replaceAll(RegExp(r'\*.*'), '').trim();

    return text;
  }

  // Function to parse the HTML and map to an array of Verse objects
  List<Verse> parseBibleVerses(String htmlResponse) {
    // Parse the HTML
    Document document = html_parser.parse(htmlResponse);

    // Extract the book name and chapter from the header
    String bookName = 'Unknown';
    int chapter = 0;

    final headerElement = document.querySelector('h2.bk_ch_vs_header');
    if (headerElement != null) {
      final headerText = headerElement.text;
      // Parse "John 3:16-20, NLT" format
      final match = RegExp(r'^([A-Za-z]+)\s+(\d+):').firstMatch(headerText);
      if (match != null) {
        bookName = match.group(1) ?? 'Unknown';
        chapter = int.tryParse(match.group(2) ?? '0') ?? 0;
      }
    }

    return _extractVersesFromMalformedHtml(htmlResponse, bookName, chapter);
  }
}
