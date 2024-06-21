import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/data/models/audioguid/audioguid.dart';

import 'package:http/http.dart' as http;
import 'package:ruhrkultur/app/routes/app_routes.dart';
class ApiService {
  static Future<List<AudioGuide>> fetchAudioGuides() async {
    var url = Uri.parse("http://api.ruhrkulturerlebnis.de/api/v2/a?userLatitude=1&userLongitude=1");
    final response = await http.get(url, headers: {"Content-Type": "application/json"});
      print(response.body);
    if (response.statusCode == 200) {
      final List body = json.decode(response.body)['audioGuids'] ?? [];
      return body.map((e) => AudioGuide.fromJson(e)).toList();
    } else {
      _showErrorDialog();
      throw Exception('Failed to load audio guides');
    }
  }

  static Future<List<AudioGuide>> fetchAudioGuidesSafe() async {
    var url = Uri.parse("http://api.ruhrkulturerlebnis.de/api/v2/a?userLatitude=1&userLongitude=1");
    final response = await http.get(url, headers: {"Content-Type": "application/json"});
    
    if (response.statusCode == 200) {
      final List body = json.decode(response.body) ?? [];
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
