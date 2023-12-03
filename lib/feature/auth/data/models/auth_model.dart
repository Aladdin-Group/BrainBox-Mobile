class AuthModel {

  String? message;
  dynamic object;
  int? status;

  AuthModel({ this.object, this.message, this.status });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      message: json['message']??'message error',
      status: json['status']??-1,
      object: json['object']??'error'
    );
  }

}