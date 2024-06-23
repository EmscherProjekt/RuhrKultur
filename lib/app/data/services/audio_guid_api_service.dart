import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/config/api_information.dart';
import 'package:ruhrkultur/app/data/models/request/level_req.dart';
import 'package:ruhrkultur/app/data/models/response/audioguid.dart';

import 'package:http/http.dart' as http;
import 'package:ruhrkultur/app/routes/app_routes.dart';

class ApiService {

  static Future<LevelReq> setLevel(int level) async {
    //Todo: Implement setLevel
    return LevelReq();
  }

  static Future<List<AudioGuide>> fetchAudioGuides() async {
    final api = ApiInformation();
    var url = Uri.parse(api.baseUrl+api.audio+"?userLatitude=1&userLongitude=1");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    print(response.body);
    if (response.statusCode == 200) {
      final List body = json.decode(response.body)['results'] ?? [];
      return body.map((e) => AudioGuide.fromJson(e)).toList();
    } else {
      _showErrorDialog();
      throw Exception('Failed to load audio guides');
    }
  }

  static Future<List<AudioGuide>> fetchAudioGuidesSafe() async {
    final api = ApiInformation();
    var url = Uri.parse(api.baseUrl+api.audio+api.getAudioSafe);
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
  
      final List body = json.decode(response.body)['results'] ?? [];
      return body.map((e) => AudioGuide.fromJson(e)).toList();
    } else {
      _showErrorDialog();
      throw Exception('Failed to load audio guides');
    }
  }

  static void _showErrorDialog() {
    Get.defaultDialog(
      middleText: 'Failed to load audio guides!',
      title: 'Error',
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.toNamed(AppRoutes.HOME);
        Get.back();
      },
    );
  }
}
