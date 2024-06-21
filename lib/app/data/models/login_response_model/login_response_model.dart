class LoginResponseModel {
  int? id;
  String? username;
  String? email;
  String? profileImage;
  List<String>? roles;
  String? token;
  String? accessToken;

  LoginResponseModel({this.id, this.username, this.email, this.roles, this.token, this.accessToken});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    profileImage = json['profileImage'] ?? 'default';
    roles = json['roles'].cast<String>();
    token = json['token'];
    accessToken = json['accessToken'];
  }
}
