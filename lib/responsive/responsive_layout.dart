import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget MobileScreenLayout;
  final Widget WebScreenLayout;

  const ResponsiveLayout({Key ? key, required this.MobileScreenLayout , this.WebScreenLayout}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        if(constraints.maxWidth > 900){
          return WebScreenLayout;
        }
        return MobileScreenLayout;
      },
    );
  }
}
