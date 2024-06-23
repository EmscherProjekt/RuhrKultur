class RegisterResponseModel {
  String? error;
  String? message;

  RegisterResponseModel({this.error, this.message, });

  RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
  }
}
