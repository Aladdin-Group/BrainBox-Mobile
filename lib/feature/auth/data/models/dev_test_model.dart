/// message : "Xush kelibsiz"
/// object : "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJGT1ItTE9HSU4iLCJpc3MiOiJNRURJVU0iLCJ1c2VybmFtZSI6ImRldkBnbWFpbC5jb20iLCJpYXQiOjE3MDQxMDY3MzcsImV4cCI6ODgxMDQxMDY3Mzd9.3iu2ktPG0VBdSDh-in-WuXw3Guav-EfbiM80sSxA0Qk"
/// status : 200
library;

class DevTestModel {
  DevTestModel({
    String? message,
    String? object,
    num? status,
  }) {
    _message = message;
    _object = object;
    _status = status;
  }

  DevTestModel.fromJson(dynamic json) {
    _message = json['message'];
    _object = json['object'];
    _status = json['status'];
  }

  String? _message;
  String? _object;
  num? _status;

  DevTestModel copyWith({
    String? message,
    String? object,
    num? status,
  }) =>
      DevTestModel(
        message: message ?? _message,
        object: object ?? _object,
        status: status ?? _status,
      );

  String? get message => _message;

  String? get object => _object;

  num? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['object'] = _object;
    map['status'] = _status;
    return map;
  }
}
