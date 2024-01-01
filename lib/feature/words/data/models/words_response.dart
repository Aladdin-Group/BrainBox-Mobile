import 'package:flutter/cupertino.dart';

class WordsResponse {
  WordsResponse({
      int? totalPages,
      int? totalElements,
      int? size,
      List<dynamic>? content, 
      int? number,
      Sort? sort, 
      Pageable? pageable, 
      int? numberOfElements,
      bool? first, 
      bool? last, 
      bool? empty,}){
    _totalPages = totalPages;
    _totalElements = totalElements;
    _size = size;
    _content = content;
    _number = number;
    _sort = sort;
    _pageable = pageable;
    _numberOfElements = numberOfElements;
    _first = first;
    _last = last;
    _empty = empty;
}

  WordsResponse.fromJson(dynamic json) {
    _totalPages = json['totalPages'];
    _totalElements = json['totalElements'];
    _size = json['size'];
    if (json['content'] != null) {
      _content = [];
      json['content'].forEach((v) {
        _content?.add(Content.fromJson(v));
      });
    }
    _number = json['number'];
    _sort = json['sort'] != null ? Sort.fromJson(json['sort']) : null;
    _pageable = json['pageable'] != null ? Pageable.fromJson(json['pageable']) : null;
    _numberOfElements = json['numberOfElements'];
    _first = json['first'];
    _last = json['last'];
    _empty = json['empty'];
  }
  int? _totalPages;
  int? _totalElements;
  int? _size;
  List<dynamic>? _content;
  int? _number;
  Sort? _sort;
  Pageable? _pageable;
  int? _numberOfElements;
  bool? _first;
  bool? _last;
  bool? _empty;
WordsResponse copyWith({  int? totalPages,
  int? totalElements,
  int? size,
  List<dynamic>? content,
  int? number,
  Sort? sort,
  Pageable? pageable,
  int? numberOfElements,
  bool? first,
  bool? last,
  bool? empty,
}) => WordsResponse(  totalPages: totalPages ?? _totalPages,
  totalElements: totalElements ?? _totalElements,
  size: size ?? _size,
  content: content ?? _content,
  number: number ?? _number,
  sort: sort ?? _sort,
  pageable: pageable ?? _pageable,
  numberOfElements: numberOfElements ?? _numberOfElements,
  first: first ?? _first,
  last: last ?? _last,
  empty: empty ?? _empty,
);
  int? get totalPages => _totalPages;
  int? get totalElements => _totalElements;
  int? get size => _size;
  List<dynamic>? get content => _content;
  int? get number => _number;
  Sort? get sort => _sort;
  Pageable? get pageable => _pageable;
  int? get numberOfElements => _numberOfElements;
  bool? get first => _first;
  bool? get last => _last;
  bool? get empty => _empty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalPages'] = _totalPages;
    map['totalElements'] = _totalElements;
    map['size'] = _size;
    if (_content != null) {
      map['content'] = _content?.map((v) => v.toJson()).toList();
    }
    map['number'] = _number;
    if (_sort != null) {
      map['sort'] = _sort?.toJson();
    }
    if (_pageable != null) {
      map['pageable'] = _pageable?.toJson();
    }
    map['numberOfElements'] = _numberOfElements;
    map['first'] = _first;
    map['last'] = _last;
    map['empty'] = _empty;
    return map;
  }

}

/// offset : 0
/// sort : {"empty":true,"sorted":true,"unsorted":true}
/// pageNumber : 0
/// pageSize : 0
/// paged : true
/// unpaged : true

class Pageable {
  Pageable({
    int? offset,
      Sort? sort,
    int? pageNumber,
    int? pageSize,
      bool? paged, 
      bool? unpaged,}){
    _offset = offset;
    _sort = sort;
    _pageNumber = pageNumber;
    _pageSize = pageSize;
    _paged = paged;
    _unpaged = unpaged;
}

  Pageable.fromJson(dynamic json) {
    _offset = json['offset'];
    _sort = json['sort'] != null ? Sort.fromJson(json['sort']) : null;
    _pageNumber = json['pageNumber'];
    _pageSize = json['pageSize'];
    _paged = json['paged'];
    _unpaged = json['unpaged'];
  }
  int? _offset;
  Sort? _sort;
  int? _pageNumber;
  int? _pageSize;
  bool? _paged;
  bool? _unpaged;
Pageable copyWith({  int? offset,
  Sort? sort,
  int? pageNumber,
  int? pageSize,
  bool? paged,
  bool? unpaged,
}) => Pageable(  offset: offset ?? _offset,
  sort: sort ?? _sort,
  pageNumber: pageNumber ?? _pageNumber,
  pageSize: pageSize ?? _pageSize,
  paged: paged ?? _paged,
  unpaged: unpaged ?? _unpaged,
);
  int? get offset => _offset;
  Sort? get sort => _sort;
  int? get pageNumber => _pageNumber;
  int? get pageSize => _pageSize;
  bool? get paged => _paged;
  bool? get unpaged => _unpaged;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['offset'] = _offset;
    if (_sort != null) {
      map['sort'] = _sort?.toJson();
    }
    map['pageNumber'] = _pageNumber;
    map['pageSize'] = _pageSize;
    map['paged'] = _paged;
    map['unpaged'] = _unpaged;
    return map;
  }

}

/// empty : true
/// sorted : true
/// unsorted : true

class Sort {
  Sort({
      bool? empty, 
      bool? sorted, 
      bool? unsorted,}){
    _empty = empty;
    _sorted = sorted;
    _unsorted = unsorted;
}

  Sort.fromJson(dynamic json) {
    _empty = json['empty'];
    _sorted = json['sorted'];
    _unsorted = json['unsorted'];
  }
  bool? _empty;
  bool? _sorted;
  bool? _unsorted;
Sort copyWith({  bool? empty,
  bool? sorted,
  bool? unsorted,
}) => Sort(  empty: empty ?? _empty,
  sorted: sorted ?? _sorted,
  unsorted: unsorted ?? _unsorted,
);
  bool? get empty => _empty;
  bool? get sorted => _sorted;
  bool? get unsorted => _unsorted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['empty'] = _empty;
    map['sorted'] = _sorted;
    map['unsorted'] = _unsorted;
    return map;
  }

}

class Content {
  String? id;
  String? value;
  int? count;
  String? pronunciation;
  String? translationEn;
  String? translationRu;

  Content(
      {this.id,
        this.value,
        this.count,
        this.pronunciation,
        this.translationEn,
        this.translationRu});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    count = json['count'];
    pronunciation = json['pronunciation'];
    translationEn = json['translation_en'];
    translationRu = json['translation_ru'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['count'] = this.count;
    data['pronunciation'] = this.pronunciation;
    data['translation_en'] = this.translationEn;
    data['translation_ru'] = this.translationRu;
    return data;
  }
}
