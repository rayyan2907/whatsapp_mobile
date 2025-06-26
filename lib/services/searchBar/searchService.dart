import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

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
        Fluttertoast.showToast(
          msg: "No users found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      return result;
    } else {
      throw Exception("Failed to fetch users: ${response.statusCode}");
    }
  }
}
