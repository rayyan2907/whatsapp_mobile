import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class DpUploadService {
  Future<String> UploadDp(String email, File img) async {


    try {
      final url = Uri.parse(
        'https://whatsappclonebackend.azurewebsites.net/api/setdp',
      );
      final request = http.MultipartRequest('POST', url)
        ..fields['email'] = email
        ..files.add(
          await http.MultipartFile.fromPath(
            'Pic', // field name in backend
            img.path,
          ),
        );
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
