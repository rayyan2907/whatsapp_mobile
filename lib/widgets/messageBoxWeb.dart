import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/color.dart';

class SendMessageBar extends StatefulWidget {
  const SendMessageBar({super.key});

  @override
  State<SendMessageBar> createState() => _SendMessageBarState();
}

class _SendMessageBarState extends State<SendMessageBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  void _onChanged(String text) {
    setState(() {
      _isTyping = text.trim().isNotEmpty;
    });
  }

  void _sendMessage() {
    // Implement send logic here
    print("Sending: ${_controller.text}");
    _controller.clear();
    setState(() {
      _isTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: chatBarMessage,
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.attach_file, color: Colors.grey),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: mobileChatBoxColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _controller,
                onChanged: _onChanged,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Type a message",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: _isTyping ? _sendMessage : () {},
            icon: Icon(
              _isTyping ? Icons.send : Icons.mic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
