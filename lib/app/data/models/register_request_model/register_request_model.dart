class RegisterRequestModel {
  String? username;
  String? email;
  String? password;
  String? message;

  RegisterRequestModel({this.username, this.email, this.password, this.message});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['message'] = this.message;
    return data;
  }
}