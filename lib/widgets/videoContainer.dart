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
  bool _hasBeenTapped = false;

  bool _isInitializing = false;
  String _duration = '';
  String _position = '';

  Future<void> _initializeVideoPlayer() async {
    if (_isInitialized || _isInitializing) return;

    setState(() {
      _isInitializing = true;
    });

    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller!.initialize();

      if (!mounted) return;

      _controller!.addListener(() {
        if (!mounted) return;
        setState(() {
          _isPlaying = _controller!.value.isPlaying;
          _position = _formatDuration(_controller!.value.position);
        });
      });

      setState(() {
        _isInitialized = true;
        _isInitializing = false;
        _duration = _formatDuration(_controller!.value.duration);
      });

      _controller!.play();
    } catch (e) {
      print('Error initializing video: $e');
      setState(() {
        _isInitializing = false;
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : ''}$twoDigitMinutes:$twoDigitSeconds';
  }

  void _togglePlayPause() {
    if (_isInitializing) return;

    if (_controller != null && _isInitialized) {
      _isPlaying ? _controller!.pause() : _controller!.play();
    } else if (!_hasBeenTapped) {
      _hasBeenTapped = true;
      _initializeVideoPlayer();
    }
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: widget.caption != null
                      ? const BorderRadius.vertical(top: Radius.circular(8))
                      : BorderRadius.circular(8),
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      color: const Color(0xFF111B21),
                      child: _isInitialized && _controller != null
                          ? AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      )
                          : widget.thumbnailUrl != null
                          ? Image.network(
                        widget.thumbnailUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildVideoPlaceholder(),
                      )
                          : _buildVideoPlaceholder(),
                    ),
                  ),
                ),

                // Show loader only while initializing
                if (_isInitializing)
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

                // Play/pause icon
                if (!_isInitializing && (!_isInitialized || (_showControls && !_isPlaying)))

                  Positioned.fill(
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

                // Duration
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

                // Position
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
              ],
            ),

            // Caption
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
