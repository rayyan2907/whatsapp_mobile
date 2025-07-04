import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageUploadService {
  static Future<Map<String, dynamic>?> uploadImage(File file, int receiverId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt') ?? '';

      final uri = Uri.parse("https://whatsappclonebackend.azurewebsites.net/message/sendimg");
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      final mimeType = lookupMimeType(file.path) ?? "image/jpeg";
      final mimeParts = mimeType.split('/');

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        file.path,
        contentType: MediaType(mimeParts[0], mimeParts[1]),
      ));

      request.fields['reciever_id'] = receiverId.toString();
      request.fields['is_seen'] = 'false';
      request.fields['time'] = DateFormat('hh:mm a').format(DateTime.now());
      request.fields['type'] = 'img';

      final response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final imageUrl = respStr.replaceAll('"', '');
        return {
          'img_url': imageUrl,
          'file_name': file.path.split('/').last,
          'time': DateFormat('hh:mm a').format(DateTime.now()),
          'is_seen': false,
          'reciever_id': receiverId,
          'type': 'img',
        };
      } else {
        print("Image upload failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Image upload error: $e");
      return null;
    }
  }
}
