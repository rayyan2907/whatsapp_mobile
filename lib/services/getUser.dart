import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GetUser {

  static Future<Map<String, dynamic>?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson == null) return null;
    return json.decode(userJson); // This gives you a Map with user details
  }
}