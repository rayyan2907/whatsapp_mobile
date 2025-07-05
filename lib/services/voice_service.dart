import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoiceUploadService {
  static Future<Map<String, dynamic>?> uploadVoice(File file, int receiverId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt') ?? '';
      print("voice service called");

      final uri = Uri.parse("https://whatsappclonebackend.azurewebsites.net/message/sendvoice");
      //final uri = Uri.parse("http://192.168.0.101:5246/message/sendvoice");

      // Read file as bytes and convert to base64
      final bytes = await file.readAsBytes();
      final base64Audio = base64Encode(bytes);
      final fileName = file.path.split('/').last;
      final time = DateFormat('hh:mm a').format(DateTime.now());
print(base64Audio);
      final body = jsonEncode({
        'reciever_id': receiverId,
        'is_seen': false,
        'time': time,
        'type': 'voice',
        'file_name': fileName,
        'voice_byte': base64Audio,
      });
print(body);
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print(response.body);
        final voiceUrl = response.body.replaceAll('"', '');
        return {
          'voice_url': voiceUrl,
          'file_name': fileName,
          'time': time,
          'is_seen': false,
          'reciever_id': receiverId,
          'type': 'voice',
        };
      } else {
        print("Voice upload failed: ${response.statusCode}");
        print("Response: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Voice upload error: $e");
      return null;
    }
  }
}
