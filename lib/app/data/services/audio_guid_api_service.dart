import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/config/api_information.dart';
import 'package:ruhrkultur/app/data/models/request/level_req.dart';
import 'package:ruhrkultur/app/data/models/response/audioguid.dart';

import 'package:http/http.dart' as http;
import 'package:ruhrkultur/app/data/models/response/audioguid_video.dart';
import 'package:geolocator/geolocator.dart';

class ApiService {
  static Future<LevelReq> setLevel(int level) async {
    //Todo: Implement setLevel
    return LevelReq();
  }

  static void ReportBug(String title, String message) async {
    print("ReportBug");
    var ur = Uri.parse(
        ApiInformation().baseUrl + ApiInformation().bug + "/$title/$message");
    print(ur);
    var response = http
        .get(ur, headers: {"Content-Type": "application/json"}).then((value) {
      print(value.body);
    });

    print(response);
  }

  static Future<List<AudioGuide>> fetchAudioGuides() async {
    final ApiInformation api = ApiInformation();
    print("fetchAudioGuides");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    double latitude = position.latitude;
    double longitude = position.longitude;
    var url = Uri.parse(
        api.baseUrl + api.getAudiobyPostion + "/$longitude/$latitude/300");
    print(url);
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List body = json.decode(response.body) ?? [];

      return body.map((e) => AudioGuide.fromJson(e)).toList();
    }
    if (response.statusCode == 404) {
      _showErrorDialog(
          "Failed to load Audio Guides", "Failed to load Audio Guides", "OK ");
      return [];
    } else {
      _showErrorDialog(
          "Failed to load Audio Guides", "Failed to load Audio Guides", "OK ");
      throw Exception('Failed to load audio guides');
    }
  }

  static Future<List<AudioGuide>> fetchAudioGuidesSafe() async {
    final api = ApiInformation();
    var url = Uri.parse(api.baseUrl + api.audio + api.getAudioSafe);
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      final List body = json.decode(response.body) ?? [];
      return body.map((e) => AudioGuide.fromJson(e)).toList();
    }
    if (response.statusCode == 404) {
      ReportBug("404", response.body);
      _showErrorDialog(
          "Failed to load Audio Guides", "Failed to load Audio Guides", "OK ");
      return [];
    } else {
      ReportBug(response.statusCode.toString(), response.body);

      _showErrorDialog(
          "Failed to load Audio Guides", "Failed to load Audio Guides", "OK ");
      return [];
    }
  }

  static Future<List<AudioGuideVideo>> fetchAudioGuidesVideos(
      int audioguid) async {
    final api = ApiInformation();
    var url =
        Uri.parse(api.baseUrl + api.audio + api.audiovideo + "/$audioguid");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    print(response.body);
    if (response.statusCode == 200) {
      final List body = json.decode(response.body) ?? [];
      return body.map((e) => AudioGuideVideo.fromJson(e)).toList();
    } else {
      ReportBug("404", response.body);

      _showErrorDialog(
          "Failed to load Videos from this Audio Guid pleas Report a bug",
          "Failed to load Videos",
          "OK");
      return [];
    }
  }

  static void _showErrorDialog(
      String titel, String message, String buttonText) {
    Get.defaultDialog(
      middleText: message,
      title: titel,
      textConfirm: buttonText,
      confirmTextColor: Colors.white,
      onConfirm: () {
       
        Get.back();
      },
    );
  }
}
