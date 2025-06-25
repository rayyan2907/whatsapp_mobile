import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/color.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            const Text(
              "Settings",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Profile Info Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=1"),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rayyan",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Hi, there I am using whatsapp",
                          style: TextStyle(color: Colors.white60, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Change Profile Picture
            Container(
              color: const Color(0xFF121212),

              child: ListTile(
                leading: const Icon(CupertinoIcons.photo, color: Colors.white),
                title: const Text("Change Profile Picture", style: TextStyle(color: Colors.white,fontSize: 16)),
                onTap: () {
                  // Add logic to open image picker
                },
              ),
            ),

            // Log Out
            Container(
              color: const Color(0xFF121212),

              child: ListTile(
                leading: const Icon(CupertinoIcons.arrow_right_square, color: Colors.redAccent),
                title: const Text("Log out", style: TextStyle(color: Colors.redAccent,fontSize: 16)),
                onTap: () {
                  // Add log out logic
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
