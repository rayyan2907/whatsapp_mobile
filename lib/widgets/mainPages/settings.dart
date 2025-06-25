import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:whatsapp_mobile/services/getUser.dart';
import 'package:whatsapp_mobile/services/logOutService.dart';
import 'package:whatsapp_mobile/widgets/mainPages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String fullName='';
  String pic_url='';

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final user = await GetUser.getLoggedInUser();
    print(user);
    if (user != null) {
      setState(() {
        fullName = "${user['first_name']} ${user['last_name']}";
        pic_url = user['profile_pic_url'];
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
                   CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      pic_url,
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
                title: const Text(
                  "Change Profile Picture",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onTap: () {
                  // Add logic to open image picker
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
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Fluttertoast.showToast(
                    msg: "Logged out successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
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
