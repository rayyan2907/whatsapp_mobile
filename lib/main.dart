import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:whatsapp_mobile/responsive/responsive_layout.dart';
import 'package:whatsapp_mobile/screens/mobile_screen_layout.dart';
import 'package:whatsapp_mobile/screens/web_screen_layout.dart';
import 'package:whatsapp_mobile/widgets/mainPages/login.dart';
import 'services/RegAndLogin/jwtExpire.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> getHomeScreen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt');
      if (token != null && token.isNotEmpty) {
        if (!jwtCheck.isJwtExpired(token)) {
          return const ResponsiveLayout(
            MobileScreenLayout: MobileScreenLayout(),
            WebScreenLayout: WebScreenLayout(),
          );
        } else {
          showToast(
            "Session Expired",
            duration: Duration(seconds: 2), // Equivalent to LENGTH_SHORT
            position: ToastPosition.top,
            backgroundColor: Colors.red,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            radius: 8.0, // optional, for rounded edges
          );
          return const LoginScreen();
        }
      } else {
        return const LoginScreen();
      }
    } catch (e) {
      debugPrint("Error in getHomeScreen(): $e");
      return const Scaffold(body: Center(child: Text("Error loading screen")));
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: FutureBuilder(
        future: getHomeScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            );
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              return snapshot.data!;
            } else {
              return const Scaffold(
                body: Center(child: Text("Something went wrong")),
              );
            }
          }
        },
      ),
    );
  }
}
