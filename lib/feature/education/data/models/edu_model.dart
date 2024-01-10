class EduModel {
  EduModel({
      num? id, 
      String? link, 
      String? imageLink,}){
    _id = id;
    _link = link;
    _imageLink = imageLink;
}

  EduModel.fromJson(dynamic json) {
    _id = json['id'];
    _link = json['link'];
    _imageLink = json['imageLink'];
  }
  num? _id;
  String? _link;
  String? _imageLink;
EduModel copyWith({  num? id,
  String? link,
  String? imageLink,
}) => EduModel(  id: id ?? _id,
  link: link ?? _link,
  imageLink: imageLink ?? _imageLink,
);
  num? get id => _id;
  String? get link => _link;
  String? get imageLink => _imageLink;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['link'] = _link;
    map['imageLink'] = _imageLink;
    return map;
  }

}