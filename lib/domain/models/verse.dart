import 'package:equatable/equatable.dart';

class Verse extends Equatable {
  final String bookName;
  final int book;
  final int chapter;
  final int verse;
  final String text;

  const Verse({
    required this.bookName,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  factory Verse.fromMap(Map<String, dynamic> data) {
    return Verse(
      bookName: data['book_name'],
      book: data['book'],
      chapter: data['chapter'],
      verse: data['verse'],
      text: data['text'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'book_name': bookName,
      'book': book,
      'chapter': chapter,
      'verse': verse,
      'text': text,
    };
  }

  static List<Verse> fromJSON(List<dynamic> data) {
    return data.map((e) => Verse.fromMap(e)).toList();
  }

  @override
  String toString() => '$verse. $text';

  @override
  List<Object?> get props => [bookName, book, chapter, verse, text];
}
