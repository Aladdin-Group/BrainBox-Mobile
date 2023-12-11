// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericPagination<T> _$GenericPaginationFromJson<T>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
    ) =>
    GenericPagination<T>(
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['content'] as List<dynamic>?)?.map(fromJsonT).toList() ?? [],
      count: json['totalElements'] as int? ?? 0,
      page: json['totalPages'] as int? ?? 0,
    );

Map<String, dynamic> _$GenericPaginationToJson<T>(
    GenericPagination<T> instance,
    Object? Function(T value) toJsonT,
    ) =>
    <String, dynamic>{
      'next': instance.next,
      'previous': instance.previous,
      'content': instance.results.map(toJsonT).toList(),
      'totalElements': instance.count,
      'totalPages': instance.page,
    };