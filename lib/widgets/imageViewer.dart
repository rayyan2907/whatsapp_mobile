import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final String imageUrl;

  const ImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context), // tap to close
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Hero(
            tag: imageUrl,
            child: InteractiveViewer(
              child: Image.network(imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}
