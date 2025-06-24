import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_mobile/widgets/videoPlayer.dart';

class VideoMessageBubble extends StatelessWidget {
  final String? videoUrl;
  final String? thumbnailUrl;
  final String? caption;

  const VideoMessageBubble({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
            // Video thumbnail container
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerWidget(videoUrl: videoUrl!),
                  ),
                );
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: caption != null
                        ? const BorderRadius.vertical(top: Radius.circular(8))
                        : BorderRadius.circular(8),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      color: const Color(0xFF111B21),
                      child: thumbnailUrl != null
                          ? Image.network(
                        thumbnailUrl!,
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                          : _placeholder(),
                    ),
                  ),
                  const Positioned.fill(
                    child: Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        color: Colors.white70,
                        size: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Caption text
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

  Widget _placeholder() => const Center(
    child: Icon(Icons.videocam, size: 48, color: Colors.white38),
  );
}
