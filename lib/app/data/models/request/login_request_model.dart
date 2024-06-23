class LoginRequestModel {
  String ? email;
  String ? password;


  LoginRequestModel({this.email, this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['clientType'] = "MOBILE";
    data['rememberMe'] = false;
    return data;
  }
}
    
