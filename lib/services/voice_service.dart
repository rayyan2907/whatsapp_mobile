import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoiceUploadService {
  static Future<Map<String, dynamic>?> uploadVoice(File file, int receiverId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt') ?? '';
print(file.path);
      final uri = Uri.parse("https://whatsappclonebackend.azurewebsites.net/message/sendvoice"); // Your endpoint
      final request = http.MultipartRequest('POST', uri)
      ..fields['type']='voice'
        ..fields['is_seen']='false'
        ..fields['time']=DateFormat('hh:mm a').format(DateTime.now())
        ..fields['reciever_id'] = receiverId.toString()
        ..files.add(await http.MultipartFile.fromPath('voice', file.path))
        ..headers['Authorization'] = 'Bearer $token';
print(request);
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        return {
          "voice_url": responseBody.trim()
        };

      } else {
        final responseBody = await response.stream.bytesToString();
        print(responseBody);
        print("Voice upload failed with status ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Voice upload exception: $e");
      return null;
    }
  }
}
