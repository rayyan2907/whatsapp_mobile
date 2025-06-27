import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_mobile/services/GetMessages.dart';
import 'package:whatsapp_mobile/widgets/messagesSection/recievedMessage.dart';
import 'package:whatsapp_mobile/widgets/messagesSection/sentMessage.dart';

class Chatlist extends StatefulWidget {
  final Map<String, dynamic> user;

  const Chatlist({super.key, required this.user});

  @override
  State<Chatlist> createState() => _ChatlistState();
}

class _ChatlistState extends State<Chatlist> {
  List messages = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadMessages();
  }
  void loadMessages() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');

    final result = await Getmessages().loadMessages(
      token,
      widget.user['contact_id'],
      0,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      messages = result ?? [];
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
  }


  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0, // because we use reverse: true
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    return ListView.builder(
      reverse: true, // Newest message at bottom
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return msg['is_sent'] == true
            ? Sentmessage(
          textMsg: msg['text_msg'].toString(),
          date: msg['time'].toString(),
          type: msg['type'].toString(),
          imgUrl: msg['img_url'].toString(),
          videoUrl: msg['video_url'].toString(),
          caption: msg['caption'].toString(),
          isSeen: msg['is_seen'] as bool? ?? false,
          duration: msg['duration'].toString(),
          voiceUrl: msg['voice_url'].toString(),
        )
            : ReceivedMessage(
          textMsg: msg['text_msg'].toString(),
          date: msg['time'].toString(),
          type: msg['type'].toString(),
          imgUrl: msg['img_url'].toString(),
          videoUrl: msg['video_url'].toString(),
          caption: msg['caption'].toString(),
          duration: msg['duration'].toString(),
          voiceUrl: msg['voice_url'].toString(),
        );
      },
    );
  }
}
