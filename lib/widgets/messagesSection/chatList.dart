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
  int offset = 0;
  List messages = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadMessages(); // initial load
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent &&
        !_isFetchingMore &&
        !_isLoading) {
      fetchMoreMessages(); // when top is reached (because reversed: true)
    }
  }

  void loadMessages() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');

    final result = await Getmessages()
        .loadMessages(token, widget.user['user_id'], offset);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      messages = result ?? [];
      offset += 15;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
  }

  void fetchMoreMessages() async {
    setState(() => _isFetchingMore = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');

    final result = await Getmessages()
        .loadMessages(token, widget.user['user_id'], offset);

    if (!mounted) return;

    if (result != null && result.isNotEmpty) {
      setState(() {
        messages.addAll(result); // append at the end (top visually)
        offset += 15;
      });
    }

    setState(() => _isFetchingMore = false);
  }

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 0),
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

    return Stack(

      children: [

        ListView.builder(
          reverse: true,
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          itemCount: messages.length + (_isFetchingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (_isFetchingMore && index == messages.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.green),
                ),
              );
            }

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
        ),


      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
