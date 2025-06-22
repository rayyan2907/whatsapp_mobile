import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:whatsapp_mobile/responsive/responsive_layout.dart';
void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor:  backgroundColor,
      ),
      home: ResponsiveLayout(MobileScreenLayout: MobileScreenLayout,WebScreenLayout: WebScreenLayout),
    );
  }
}
