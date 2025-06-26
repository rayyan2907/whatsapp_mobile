import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class DpUploadService {
  Future<String> UploadDp(String email, File img) async {
    final cropImg = await cropImageToSquare(img);
    if (cropImg == null) return 'Cropping failed';

    try {
      final url = Uri.parse(
        'https://whatsappclonebackend.azurewebsites.net/api/setdp',
      );
      final request = http.MultipartRequest('POST', url)
        ..fields['email'] = email
        ..files.add(
          await http.MultipartFile.fromPath(
            'Pic', // field name in backend
            cropImg.path,
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

  Future<File?> cropImageToSquare(File originalImageFile) async {
    try {
      Uint8List bytes = await originalImageFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) return null;

      int size = image.width < image.height ? image.width : image.height;
      int offsetX = (image.width - size) ~/ 2;
      int offsetY = (image.height - size) ~/ 2;

      img.Image cropped = img.copyCrop(
        image,
        x: offsetX,
        y: offsetY,
        width: size,
        height: size,
      );

      List<int> croppedBytes = img.encodeJpg(cropped);

      final tempDir = await getTemporaryDirectory();
      final croppedFile = File('${tempDir.path}/cropped_profile.jpg');
      await croppedFile.writeAsBytes(croppedBytes);

      return croppedFile;
    } catch (e) {
      print("Cropping failed: $e");
      return null;
    }
  }
}
