

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class LoginService {

  Future<String> login(String email,String password) async{
      try{
        final response = await http.post(
          Uri.parse('https://whatsappclonebackend.azurewebsites.net/whatsapp/login'),
          headers: {'Content-Type':'application/json'},
          body: json.encode({'email':email,'password':password}),
        );
        if (response.statusCode==200){
          final data = json.decode(response.body);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt', data['token']);
          await prefs.setString('user', json.encode(data['user']));

          return 'Login Successful';
        }
        else{
          final message = json.decode(response.body);
          return '${message['message']}';
        }

      }
      catch(e){
        return 'Error: $e';
      }
  }
}