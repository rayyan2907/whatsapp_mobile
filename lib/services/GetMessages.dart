import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Getmessages{
  final String _baseUrl = "http://192.168.0.109:5246";
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
      Fluttertoast.showToast(
        msg: "Failed to get messages",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return null;

    }

  }

}

