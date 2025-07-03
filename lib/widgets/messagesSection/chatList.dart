import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_mobile/services/GetMessages.dart';
import 'package:whatsapp_mobile/widgets/messagesSection/recievedMessage.dart';
import 'package:whatsapp_mobile/widgets/messagesSection/sentMessage.dart';

class Chatlist extends StatefulWidget {
  final Map<String, dynamic> user;
  final List<Map<String, dynamic>> messages;

  const Chatlist({
    super.key,
    required this.user,
    required this.messages,
  });

  @override
  State<Chatlist> createState() => ChatlistState();
}

class ChatlistState extends State<Chatlist> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  int offset = 0;
  final GlobalKey<ChatlistState> chatListKey = GlobalKey<ChatlistState>();

  List<Map<String, dynamic>> _allMessages = [];

  bool _isLoading = false;
  bool _isFetchingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _allMessages = List.from(widget.messages); // base messages
    loadMessages(); // initial load
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent &&
        !_isFetchingMore &&
        !_isLoading) {
      fetchMoreMessages(); // top reached
    }
  }

  void loadMessages() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');

    final result =
    await Getmessages().loadMessages(token, widget.user['user_id'], offset);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      final newMessages = (result ?? []).cast<Map<String, dynamic>>();
      for (var i = 0; i < newMessages.length; i++) {
        _allMessages.add(newMessages[i]);
        _listKey.currentState?.insertItem(_allMessages.length - 1);
      }
      offset += 15;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
  }

  void fetchMoreMessages() async {
    setState(() => _isFetchingMore = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');

    final result =
    await Getmessages().loadMessages(token, widget.user['user_id'], offset);

    if (!mounted) return;

    if (result != null && result.isNotEmpty) {
      setState(() {
        final newMessages = result.cast<Map<String, dynamic>>();
        for (var i = 0; i < newMessages.length; i++) {
          _allMessages.add(newMessages[i]);
          _listKey.currentState?.insertItem(_allMessages.length - 1);
        }
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

  void addNewMessage(Map<String, dynamic> msg) {
    _allMessages.insert(0, msg);
    _listKey.currentState?.insertItem(0);
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
        AnimatedList(
          key: _listKey,
          reverse: true,
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          initialItemCount: _allMessages.length + (_isFetchingMore ? 1 : 0),
          itemBuilder: (context, index, animation) {
            if (_isFetchingMore && index == _allMessages.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.green),
                ),
              );
            }

            final msg = _allMessages[index];

            final child = msg['is_sent'] == true
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

            return ScaleTransition(
              scale: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
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
