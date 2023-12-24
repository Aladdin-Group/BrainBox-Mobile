
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
class LocalWord extends Equatable{
  final int? id;
  final String? word;
  final String? translate;

  const LocalWord({required this.id,required this.translate,required this.word});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'translate': translate,
    };
  }

  @override
  String toString() {
    return 'LocalWord{id: $id, word: $word, translate: $translate}';
  }

  @override
  List<Object?> get props => [id,word,translate];
}
