import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/color.dart';

class CallsPage extends StatelessWidget {
  const CallsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            // Title
            const Text(
              "Calls",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Favourites section
            const Text(
              "Favourites",
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white24,
                  child: Icon(CupertinoIcons.add, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text("Add favourite", style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 30),

            // Recent Calls Header
            const Text(
              "Recent",
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            // No calls placeholder
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              alignment: Alignment.center,
              child: const Text(
                "No recent calls",
                style: TextStyle(color: Colors.white38, fontSize: 16),
              ),
            ),

            const SizedBox(height: 30),

            // End-to-end encryption note
            Center(
              child: Text.rich(
                TextSpan(
                  text: "Your personal calls are ",
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                  children: [
                    TextSpan(
                      text: "end-to-end encrypted",
                      style: const TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
