import 'package:equatable/equatable.dart';

class TextData {
  final String raw;
  final String plain;
  const TextData({
    this.raw = r'[{"insert":"\n"}]',
    this.plain = '',
  });
}

class Note extends Equatable {
  final String id;
  final String title;
  final String content;
  final DateTime updatedAt;
  final DateTime createdAt;

  const Note({
    this.id = '',
    this.title = '',
    this.content = r'[{"insert":"\n"}]',
    required this.updatedAt,
    required this.createdAt,
  });

  factory Note.empty() {
    final currentDate = DateTime.now();
    return Note(
      title: '',
      updatedAt: currentDate,
      createdAt: currentDate,
    );
  }

  factory Note.fromSQL(Map<String, dynamic> data) {
    return Note(
      id: data['id'],
      title: data['title'],
      content: data['content'],
      updatedAt: DateTime.parse(data['updatedAt']),
      createdAt: DateTime.parse(data['createdAt']),
    );
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toSQL() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'updatedAt': updatedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, title, content, createdAt];
}
