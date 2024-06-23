class RegisterRequestModel {
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? password;

  RegisterRequestModel({this.firstName, this.lastName, this.username, this.email, this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}
