/// id : 0
/// name : "string"
/// description : "string"
/// price : 0
/// avatarUrl : "string"
/// genre : "string"
/// isBought : true
/// level : "BEGINNER"
/// belongAge : 0
/// serial : {"id":0,"name":"string"}

class MovieModel {
  MovieModel({
      num? id, 
      String? name, 
      String? description, 
      num? price, 
      String? avatarUrl, 
      String? genre, 
      bool? isBought, 
      String? level, 
      num? belongAge, 
      Serial? serial,}){
    _id = id;
    _name = name;
    _description = description;
    _price = price;
    _avatarUrl = avatarUrl;
    _genre = genre;
    _isBought = isBought;
    _level = level;
    _belongAge = belongAge;
    _serial = serial;
}

  MovieModel.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _price = json['price'];
    _avatarUrl = json['avatarUrl'];
    _genre = json['genre'];
    _isBought = json['isBought'];
    _level = json['level'];
    _belongAge = json['belongAge'];
    _serial = json['serial'] != null ? Serial.fromJson(json['serial']) : null;
  }
  num? _id;
  String? _name;
  String? _description;
  num? _price;
  String? _avatarUrl;
  String? _genre;
  bool? _isBought;
  String? _level;
  num? _belongAge;
  Serial? _serial;
MovieModel copyWith({  num? id,
  String? name,
  String? description,
  num? price,
  String? avatarUrl,
  String? genre,
  bool? isBought,
  String? level,
  num? belongAge,
  Serial? serial,
}) => MovieModel(  id: id ?? _id,
  name: name ?? _name,
  description: description ?? _description,
  price: price ?? _price,
  avatarUrl: avatarUrl ?? _avatarUrl,
  genre: genre ?? _genre,
  isBought: isBought ?? _isBought,
  level: level ?? _level,
  belongAge: belongAge ?? _belongAge,
  serial: serial ?? _serial,
);
  num? get id => _id;
  String? get name => _name;
  String? get description => _description;
  num? get price => _price;
  String? get avatarUrl => _avatarUrl;
  String? get genre => _genre;
  bool? get isBought => _isBought;
  String? get level => _level;
  num? get belongAge => _belongAge;
  Serial? get serial => _serial;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['price'] = _price;
    map['avatarUrl'] = _avatarUrl;
    map['genre'] = _genre;
    map['isBought'] = _isBought;
    map['level'] = _level;
    map['belongAge'] = _belongAge;
    if (_serial != null) {
      map['serial'] = _serial?.toJson();
    }
    return map;
  }

}

/// id : 0
/// name : "string"

class Serial {
  Serial({
      num? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  Serial.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  num? _id;
  String? _name;
Serial copyWith({  num? id,
  String? name,
}) => Serial(  id: id ?? _id,
  name: name ?? _name,
);
  num? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

}