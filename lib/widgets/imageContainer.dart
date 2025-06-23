import 'package:flutter/material.dart';

class ImageMessageBubble extends StatelessWidget {
  final String imageUrl;
  final String? caption;
  const ImageMessageBubble({
    super.key,
    required this.imageUrl,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
          minWidth: 200,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF202C33),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.13),
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image container
            Stack(
              children: [
                ClipRRect(
                  borderRadius: caption != null
                      ? const BorderRadius.vertical(top: Radius.circular(8))
                      : BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 200,
                        width: double.infinity,

                        color: const Color(0xFF111B21),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF00A884),
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      width: double.infinity,
                      color: const Color(0xFF111B21),
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Color(0xFF8696A0),
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ),
                // Download/View overlay (optional)

              ],
            ),

            // Caption container
            if (caption != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 6),
                child: Text(
                  caption!,
                  style: const TextStyle(
                    color: Color(0xFFE9EDEF),
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}