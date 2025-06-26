import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OtpService {
  Future<String> verifyOtp(
      String email,
      String Otp,
      ) async {
    try {
      final url = Uri.parse('https://whatsappclonebackend.azurewebsites.net/api/enterotp');
      final request = http.MultipartRequest('POST',url);
      request.fields['email']=email;
      request.fields['otp']=Otp;
      final response = await request.send();

      if (response.statusCode == 200) {
        return "success";

      } else {
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> decoded = json.decode(responseBody);
        final message = decoded['message'];
        return '${message}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
