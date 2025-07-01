import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkUserOnlineStatus(final userId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt'); // Get JWT token

  final url = Uri.parse('http://192.168.0.101:5246/is-online/$userId');
  print("url is $url");

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['isOnline'] ?? false;
  } else {
    print('❌ Failed to get online status: ${response.statusCode}');
    return false;
  }
}
