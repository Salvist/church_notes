import 'package:equatable/equatable.dart';

class Verse extends Equatable {
  final String bookName;
  final int chapter;
  final int verse;
  final String text;
  final DateTime? createdAt;

  const Verse({
    required this.bookName,
    required this.chapter,
    required this.verse,
    required this.text,
    this.createdAt,
  });

  factory Verse.fromMap(Map<String, dynamic> data) {
    return Verse(
      bookName: data['book_name'],
      chapter: data['chapter'],
      verse: data['verse'],
      text: data['text'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'book_name': bookName,
      'chapter': chapter,
      'verse': verse,
      'text': text,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }

  Map<String, dynamic> toRow() {
    return {
      'book_name': bookName,
      'chapter': chapter,
      'verse': verse,
      'text': text,
      if (createdAt != null) 'createdAt': createdAt!.millisecondsSinceEpoch,
    };
  }

  static List<Verse> fromJSON(List<dynamic> data) {
    return data.map((e) => Verse.fromMap(e)).toList();
  }

  @override
  String toString() => '$verse. $text';

  @override
  List<Object?> get props => [bookName, chapter, verse, text, createdAt];
}
