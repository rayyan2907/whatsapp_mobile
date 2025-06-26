import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationService {
  Future<String> register(
    String email,
    String password,
    String first_name,
    String last_name,
    String birthdate,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://whatsappclonebackend.azurewebsites.net/api/register',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "first_name": first_name,
          "last_name": last_name,
          "email": email,
          "password": password,
          "date_of_birth": birthdate,
        }),
      );
      if (response.statusCode == 200) {
        final message = json.decode(response.body);
        return '${message['message']}';
      } else {
        final message = json.decode(response.body);
        return '${message['message']}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
