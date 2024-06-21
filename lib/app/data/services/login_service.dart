import 'package:get/get.dart';

import 'package:get/get_connect/http/src/status/http_status.dart';

import 'package:ruhrkultur/app/config/api_information.dart';
import 'package:ruhrkultur/app/controllers/authentication_controller.dart';
import 'package:ruhrkultur/app/data/models/login_request_model/login_request_model.dart';
import 'package:ruhrkultur/app/data/models/login_response_model/login_response_model.dart';
import 'package:ruhrkultur/app/data/models/register_request_model/register_request_model.dart';
import 'package:ruhrkultur/app/data/models/register_respone_modeldart/register_respone_model.dart';

/// LoginService responsible to communicate with web-server
/// via authenticaton related APIs
class LoginService extends GetConnect {
  final api = ApiInformation();
  final authenticationController = Get.put(AuthenticationController());
  Future<LoginResponseModel?> fetchLogin(LoginRequestModel model) async {
    print(model.toJson());
    final url = api.baseUrl + api.auth + api.login;
    print(url);
    final response = await post(url, model.toJson());
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == HttpStatus.ok) {
      authenticationController.login(response.body['accessToken']);
      authenticationController.checkLoginStatus();
      return LoginResponseModel.fromJson(response.body);
    } else {
      return null;
    }
  }

  Future<RegisterResponseModel?> fetchRegister(
      RegisterRequestModel model) async {
    final url = api.baseUrl + api.auth + api.register;
    print(url);
    
    final response =
        await post(url, model.toJson());
    print(response.body);
    if (response.statusCode == HttpStatus.ok) {
      return RegisterResponseModel.fromJson(response.body);
    } else {
      return null;
    }
  }
}
