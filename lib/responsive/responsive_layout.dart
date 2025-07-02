import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget MobileScreenLayout;


  const ResponsiveLayout({Key ? key, required this.MobileScreenLayout}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){

        return MobileScreenLayout;
      },
    );
  }
}
