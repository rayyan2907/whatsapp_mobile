import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoMessageBubble extends StatefulWidget {
  final String videoUrl;
  final String? caption;
  final String? thumbnailUrl;

  const VideoMessageBubble({
    super.key,
    required this.videoUrl,
    this.caption,
    this.thumbnailUrl,
  });

  @override
  State<VideoMessageBubble> createState() => _VideoMessageBubbleState();
}

class _VideoMessageBubbleState extends State<VideoMessageBubble> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;
  String _duration = '';
  String _position = '';

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _duration = _formatDuration(_controller!.value.duration);
        });

        _controller!.addListener(() {
          if (mounted) {
            setState(() {
              _isPlaying = _controller!.value.isPlaying;
              _position = _formatDuration(_controller!.value.position);
            });
          }
        });
      }
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : ''}$twoDigitMinutes:$twoDigitSeconds';
  }

  void _togglePlayPause() {
    if (_controller != null && _isInitialized) {
      setState(() {
        if (_isPlaying) {
          _controller!.pause();
        } else {
          _controller!.play();
        }
      });
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
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
            // Video container
            Stack(
              children: [
                ClipRRect(
                  borderRadius: widget.caption != null
                      ? const BorderRadius.vertical(top: Radius.circular(8))
                      : BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    color: const Color(0xFF111B21),
                    child: _isInitialized && _controller != null
                        ? GestureDetector(
                      onTap: _toggleControls,
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                    )
                        : widget.thumbnailUrl != null
                        ? Image.network(
                      widget.thumbnailUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) => _buildVideoPlaceholder(),
                    )
                        : _buildVideoPlaceholder(),
                  ),
                ),

                // Loading indicator
                if (!_isInitialized)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF00A884),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),

                // Play/Pause button
                if (_isInitialized && _showControls)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _togglePlayPause,
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Video duration
                if (_isInitialized)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _duration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                // Video progress
                if (_isInitialized && _isPlaying)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _position,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                // Video icon overlay (when not playing)
                if (!_isInitialized)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.videocam,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),

            // Caption container
            if (widget.caption != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 6),
                child: Text(
                  widget.caption!,
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

  Widget _buildVideoPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      color: const Color(0xFF111B21),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_circle_outline,
              color: Color(0xFF8696A0),
              size: 48,
            ),
            SizedBox(height: 8),
            Text(
              'Video',
              style: TextStyle(
                color: Color(0xFF8696A0),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}