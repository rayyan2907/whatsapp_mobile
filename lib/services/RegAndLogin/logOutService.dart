import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_mobile/widgets/mainPages/login.dart';

class LogoutService {
  static Future<void> logout(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.green),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    showToast(
      "You have been Logged Out",
      duration: Duration(seconds: 2), // Equivalent to LENGTH_SHORT
      position: ToastPosition.top,
      backgroundColor: Colors.red,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
      radius: 8.0, // optional, for rounded edges
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
    );
  }
}
