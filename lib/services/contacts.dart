import 'package:http/http.dart' as http;
import 'dart:convert';

class GetContacts{
  final String _baseUrl = "http://192.168.0.109:5246";
  Future<List<dynamic>> loadContacts(final token)async{
    final url = Uri.parse('$_baseUrl/getContacts');

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
    else{
      throw Exception("failed to get contacts");
    }

  }

}
