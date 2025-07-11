import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:whatsapp_mobile/services/getUser.dart';
import 'package:whatsapp_mobile/services/RegAndLogin/logOutService.dart';
import 'package:whatsapp_mobile/widgets/mainPages/dpUpdatePage.dart';
import 'package:whatsapp_mobile/widgets/mainPages/login.dart';
import 'package:signalr_core/signalr_core.dart';

import '../players/imageViewer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String fullName = '';
  String pic_url = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final localPic = prefs.getString('profile_pic_url');
    final user = await GetUser.getLoggedInUser();
    print(user);
    if (user != null) {
      setState(() {
        fullName = "${user['first_name']} ${user['last_name']}";

        pic_url = localPic??user['profile_pic_url'];
      });


    } else {
      await LogoutService.logout(context);
    }
  }



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
                  GestureDetector(
                    onTap: () {
                      if (pic_url.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImageViewer(imageUrl: pic_url),
                          ),
                        );
                      }
                    },
                    child: Hero(
                      tag: 'profile-pic-hero',
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey.shade800,
                        backgroundImage: pic_url.isNotEmpty
                            ? NetworkImage(pic_url)
                            : null,
                        child: pic_url.isEmpty
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Hi, there I am using whatsapp clone",
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
                title: const Text(
                  "Change Profile Picture",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => DpUpdatePage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );

                },
              ),
            ),

            // Log Out
            Container(
              color: const Color(0xFF121212),

              child: ListTile(
                leading: const Icon(
                  CupertinoIcons.arrow_right_square,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  "Log out",
                  style: TextStyle(color: Colors.redAccent, fontSize: 16),
                ),

                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    ),
                  );
                  await Future.delayed(const Duration(seconds: 1));

                  print("🔴 Connection stopped on logout");

                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();

                  showToast(
                    "Logged out successfully",
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
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
