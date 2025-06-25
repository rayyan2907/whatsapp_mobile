import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:http/http.dart' as http;
class WhatsAppSearchBar extends StatelessWidget {
  const WhatsAppSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38, // Adjust this value for desired height
      child: TextField(
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          filled: true,
          fillColor: searchBarColor,
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 18),
          hintText: 'Search...',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),

    );
  }
}

