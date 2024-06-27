import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/config/api_information.dart';
import 'package:ruhrkultur/app/data/models/request/level_req.dart';
import 'package:ruhrkultur/app/data/models/response/audioguid.dart';

import 'package:http/http.dart' as http;
import 'package:ruhrkultur/app/data/models/response/audioguid_video.dart';
import 'package:ruhrkultur/app/routes/app_routes.dart';
import 'package:geolocator/geolocator.dart';

class ApiService {
  static Future<LevelReq> setLevel(int level) async {
    //Todo: Implement setLevel
    return LevelReq();
  }

  static Future<List<AudioGuide>> fetchAudioGuides() async {
    final ApiInformation api = ApiInformation();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double latitude = position.latitude;
    double longitude = position.longitude;
    var url = Uri.parse(api.baseUrl +
        api.audio +
        api.getAudiobyPostion +
        "?userLatitude=$latitude&userLongitude=$longitude");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      final List body = json.decode(response.body) ?? [];
      return body.map((e) => AudioGuide.fromJson(e)).toList();
    } else {
      _showErrorDialog();
      throw Exception('Failed to load audio guides');
    }
  }

  static Future<List<AudioGuide>> fetchAudioGuidesSafe() async {
    final api = ApiInformation();
    var url = Uri.parse("http://api.ruhrkulturerlebnis.de/audio");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      final List body = json.decode(response.body) ?? [];
      return body.map((e) => AudioGuide.fromJson(e)).toList();
    } else {
      _showErrorDialog();
      throw Exception('Failed to load audio guides');
    }
  }

  static Future<List<AudioGuideVideo>> fetchAudioGuidesVideos(
      int audioguid) async {
    final api = ApiInformation();
    var url =
        Uri.parse(api.baseUrl + api.audio + api.getAudioSafe + "/$audioguid");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      final List body = json.decode(response.body)['results'] ?? [];
      return body.map((e) => AudioGuideVideo.fromJson(e)).toList();
    } else {
      _showErrorDialog();
      throw Exception('Failed to load audio guides');
    }
  }

  //static Future<List<

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
