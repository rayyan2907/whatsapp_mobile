import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Getmessages{
  final String _baseUrl = "https://whatsappclonebackend.azurewebsites.net";
  Future<List<dynamic>?> loadMessages(final token,final id,final offset)async{
    final url = Uri.parse('$_baseUrl/message/getMessage?id=$id&ofsset=$offset');
    print(url);

    final response= await http.get(
      url,
      headers: {
        "Authorization":  "Bearer $token",
        "Content-Type": "application/json",
      },

    );
    if(response.statusCode==200){
      final List<dynamic> result = json.decode(response.body);
      return result;

    }
    else if(response.statusCode!=200){
      print("status is $response.statusCode");
      showToast(
        "Failed to get messages",
        duration: Duration(seconds: 2), // Equivalent to LENGTH_SHORT
        position: ToastPosition.top,
        backgroundColor: Colors.red,
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
        radius: 8.0, // optional, for rounded edges
      );
      return null;

    }

  }

}

