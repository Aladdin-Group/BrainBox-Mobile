
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
class LocalWord extends Equatable{
  final String? id;
  final String? word;
  final String? translate;
  final int? notificationId;

  const LocalWord({required this.id,required this.translate,required this.word,required this.notificationId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'translate': translate,
      'notificationId': notificationId,
    };
  }

  @override
  String toString() {
    return 'LocalWord{id: $id, word: $word, translate: $translate}';
  }

  @override
  List<Object?> get props => [id,word,translate,notificationId];
}
