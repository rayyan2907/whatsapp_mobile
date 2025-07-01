import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:oktoast/oktoast.dart';

import '../../widgets/mainPages/login.dart';

class DpUpdateService {
  Future<String> UploadDp(File img, final token) async {
    final String _baseUrl = "https://whatsappclonebackend.azurewebsites.net";

    try {
      print("token in uplaod dp is$token");
      final url = Uri.parse('$_baseUrl/dpUpdate');
      final request = http.MultipartRequest('POST', url)
        ..headers.addAll({'Authorization': 'Bearer $token'})
        ..files.add(
          await http.MultipartFile.fromPath(
            'Pic', // field name in backend
            img.path,
          ),
        );
      final response = await request.send();
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> decoded = json.decode(responseBody);
        final message = decoded['message'];
        print(decoded['profile_pic_url']);
        await prefs.setString('profile_pic_url', decoded['profile_pic_url']);

        return 'success';
      } else if (response.statusCode == 401) {
        showToast(
          "You have been Logged Out",
          duration: Duration(seconds: 2), // Equivalent to LENGTH_SHORT
          position: ToastPosition.top,
          backgroundColor: Colors.red,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
          radius: 8.0, // optional, for rounded edges
        );
        return 'Error in uploading';
      } else {
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> decoded = json.decode(responseBody);
        final message = decoded['message'];
        return '${message}';
      }
    } catch (e) {
      print({'$e'});
      return 'Error: $e';
    }
  }
}
