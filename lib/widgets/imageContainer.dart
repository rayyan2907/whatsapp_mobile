import 'package:flutter/material.dart';

class ImageMessageBubble extends StatelessWidget {
  final String imageUrl;
  final String? caption;
  final String time;

  const ImageMessageBubble({
    super.key,
    required this.imageUrl,
    this.caption,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1F2C34), // WhatsApp dark message bubble
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with size constraints
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 0,
                  maxWidth: 300,
                  minHeight: 100,
                  maxHeight: 300,
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return SizedBox(
                      height: 160,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)
                              : null,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    height: 160,
                    child: Center(child: Icon(Icons.broken_image, color: Colors.white)),
                  ),
                ),
              ),
            ),

            // Caption
            if (caption != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  caption!,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),


          ],
        ),
      ),
    );
  }
}
