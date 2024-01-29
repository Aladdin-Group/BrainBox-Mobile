import 'package:brain_box/core/utils/generic_pagination.dart';
import 'package:brain_box/feature/main/data/models/Movie.dart';

class RequestMovieModel {
  String level;
  int size;
  int page;
  GenericPagination<Content>? data;
  List<Content> listData;

  RequestMovieModel({
    required this.level,
    this.size = 5,
    required this.page,
    this.data,
    this.listData = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'level': level,
      'size': size,
      'page': page,
    };
  }

  factory RequestMovieModel.fromMap(Map<String, dynamic> map) {
    return RequestMovieModel(
      level: map['movieLevel'] as String,
      size: map['size'] as int,
      page: map['page'] as int,
    );
  }

  RequestMovieModel copyWith({
    String? level,
    int? size,
    int? page,
    GenericPagination<Content>? data,
    List<Content>? listData,
  }) {
    return RequestMovieModel(
      level: level ?? this.level,
      size: size ?? this.size,
      page: page ?? this.page,
      data: data ?? this.data,
      listData: listData ?? this.listData,
    );
  }
}
