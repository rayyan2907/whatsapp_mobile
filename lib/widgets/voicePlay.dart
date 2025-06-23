import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class VoiceMessageBubble extends StatefulWidget {
  final String voiceUrl;
  final String duration;
  final String profileUrl;

  const VoiceMessageBubble({
    super.key,
    required this.voiceUrl,
    required this.duration,
    required this.profileUrl,
  });

  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
  late AudioPlayer _player;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
        });
        _player.seek(Duration.zero);
      }
    });
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      // Update UI first, then pause
      setState(() {
        _isPlaying = false;

      });
      await _player.pause();
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        if (!_isLoaded) {
          await _player.setUrl(widget.voiceUrl);
          _isLoaded = true;
        }
        setState(() {
          _isPlaying = true;
          _isLoading = false;
        });
        await _player.play();
      } catch (e) {
        print("Audio load/play failed: $e");
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(widget.profileUrl),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : GestureDetector(
                        onTap: _togglePlay,
                        child: Icon(
                          _isPlaying ?  Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                const SizedBox(width: 12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 28,
                  width: 100,
                  child: Row(
                    children: List.generate(20, (index) {
                      final height = (_isPlaying ? (6 + index % 15) : 10)
                          .toDouble();
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: Container(
                          width: 2,
                          height: height,
                          color: Colors.white70,
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
