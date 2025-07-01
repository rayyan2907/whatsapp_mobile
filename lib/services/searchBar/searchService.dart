import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';

class SearchService {
  final String _baseUrl = "https://whatsappclonebackend.azurewebsites.net"; // Replace with your real backend URL

  Future<List<dynamic>> searchUsers(String prefix, final token) async {
    final url = Uri.parse("$_baseUrl/getUser?prefix=$prefix");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body);
      if(result.isEmpty){
        showToast(
          "No users found",
          duration: Duration(seconds: 2), // Equivalent to LENGTH_SHORT
          position: ToastPosition.top,
          backgroundColor: Colors.red,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
          radius: 8.0, // optional, for rounded edges
        );
      }
      return result;
    } else {
      throw Exception("Failed to fetch users: ${response.statusCode}");
    }
  }
}
