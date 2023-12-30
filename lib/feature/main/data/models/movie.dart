class Movie {
  Movie({
      List<Content>? content, 
      Pageable?  pageable,
      bool? last, 
      num? totalPages, 
      num? totalElements, 
      num? size, 
      num? number, 
      Sort? sort, 
      bool? first, 
      num? numberOfElements, 
      bool? empty,}){
    _content = content;
    _pageable = pageable;
    _last = last;
    _totalPages = totalPages;
    _totalElements = totalElements;
    _size = size;
    _number = number;
    _sort = sort;
    _first = first;
    _numberOfElements = numberOfElements;
    _empty = empty;
}

  Movie.fromJson(dynamic json) {
    if (json['content'] != null) {
      _content = [];
      json['content'].forEach((v) {
        _content?.add(Content.fromJson(v));
      });
    }
    _pageable = json['pageable'] != null ? Pageable.fromJson(json['pageable']) : null;
    _last = json['last'];
    _totalPages = json['totalPages'];
    _totalElements = json['totalElements'];
    _size = json['size'];
    _number = json['number'];
    _sort = json['sort'] != null ? Sort.fromJson(json['sort']) : null;
    _first = json['first'];
    _numberOfElements = json['numberOfElements'];
    _empty = json['empty'];
  }
  List<Content>? _content;
  Pageable? _pageable;
  bool? _last;
  num? _totalPages;
  num? _totalElements;
  num? _size;
  num? _number;
  Sort? _sort;
  bool? _first;
  num? _numberOfElements;
  bool? _empty;
Movie copyWith({  List<Content>? content,
  Pageable? pageable,
  bool? last,
  num? totalPages,
  num? totalElements,
  num? size,
  num? number,
  Sort? sort,
  bool? first,
  num? numberOfElements,
  bool? empty,
}) => Movie(  content: content ?? _content,
  pageable: pageable ?? _pageable,
  last: last ?? _last,
  totalPages: totalPages ?? _totalPages,
  totalElements: totalElements ?? _totalElements,
  size: size ?? _size,
  number: number ?? _number,
  sort: sort ?? _sort,
  first: first ?? _first,
  numberOfElements: numberOfElements ?? _numberOfElements,
  empty: empty ?? _empty,
);
  List<Content>? get content => _content;
  Pageable? get pageable => _pageable;
  bool? get last => _last;
  num? get totalPages => _totalPages;
  num? get totalElements => _totalElements;
  num? get size => _size;
  num? get number => _number;
  Sort? get sort => _sort;
  bool? get first => _first;
  num? get numberOfElements => _numberOfElements;
  bool? get empty => _empty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_content != null) {
      map['content'] = _content?.map((v) => v.toJson()).toList();
    }
    if (_pageable != null) {
      map['pageable'] = _pageable?.toJson();
    }
    map['last'] = _last;
    map['totalPages'] = _totalPages;
    map['totalElements'] = _totalElements;
    map['size'] = _size;
    map['number'] = _number;
    if (_sort != null) {
      map['sort'] = _sort?.toJson();
    }
    map['first'] = _first;
    map['numberOfElements'] = _numberOfElements;
    map['empty'] = _empty;
    return map;
  }

}

class Content{
  int? id;
  String? name;
  String? description;
  int? price;
  String? avatarUrl;
  String? genre;
  bool? isBought;
  String? level;
  int? belongAge;
  dynamic? serial;

  Content(
      {this.id,
        this.name,
        this.description,
        this.price,
        this.avatarUrl,
        this.genre,
        this.isBought,
        this.level,
        this.belongAge,
        this.serial});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    avatarUrl = json['avatarUrl'];
    genre = json['genre'];
    isBought = json['isBought'];
    level = json['level'];
    belongAge = json['belongAge'];
    serial = json['serial'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['avatarUrl'] = avatarUrl;
    data['genre'] = genre;
    data['isBought'] = isBought;
    data['level'] = level;
    data['belongAge'] = belongAge;
    data['serial'] = serial;
    return data;
  }
}

class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort({this.empty, this.sorted, this.unsorted});

  Sort.fromJson(Map<String, dynamic> json) {
    empty = json['empty'];
    sorted = json['sorted'];
    unsorted = json['unsorted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empty'] = this.empty;
    data['sorted'] = this.sorted;
    data['unsorted'] = this.unsorted;
    return data;
  }
}

class Pageable {
  int? offset;
  Sort? sort;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  bool? unpaged;

  Pageable({this.offset, this.sort, this.pageNumber, this.pageSize, this.paged, this.unpaged});

  Pageable.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    paged = json['paged'];
    unpaged = json['unpaged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offset'] = this.offset;
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['paged'] = this.paged;
    data['unpaged'] = this.unpaged;
    return data;
  }
}
