import 'package:json_annotation/json_annotation.dart';

part 'generic_pagination.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class GenericPagination<T> {
  @JsonKey(name: 'next')
  final String? next;
  @JsonKey(name: 'previous')
  final String? previous;
  @JsonKey(name: 'content', defaultValue: [])
  final List<T> results;
  @JsonKey(name: 'totalElements', defaultValue: 0)
  final int count;
  @JsonKey(name: 'totalPages', defaultValue: 0)
  final int page;

  GenericPagination(
      {required this.next,
        required this.previous,
        required this.results,
        required this.page,
        required this.count});
  factory GenericPagination.fromJson(
      Map<String, dynamic> json, T Function(Object?) fetch) =>
      _$GenericPaginationFromJson(json, fetch);
}