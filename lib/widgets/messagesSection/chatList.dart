import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_mobile/services/GetMessages.dart';
import 'package:whatsapp_mobile/widgets/messagesSection/recievedMessage.dart';
import 'package:whatsapp_mobile/widgets/messagesSection/sentMessage.dart';

import '../../services/getUser.dart';

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
  String pic_url='';

  @override
  void initState() {
    super.initState();
    _allMessages = List.from(widget.messages); // base messages
    loadMessages(); // initial load
    _scrollController.addListener(_handleScroll);
    loadData();
  }
  Future<void> loadData() async {
    final user = await GetUser.getLoggedInUser();
pic_url=user?['profile_pic_url'];

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
      // ✅ First time loading spinner
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }
    return Stack(
      children: [
        Column(
          children: [

            if (_isFetchingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.green,strokeWidth: 2,),
                ),
              ),

            Expanded(
              child: AnimatedList(
                key: _listKey,
                reverse: true,
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                initialItemCount: _allMessages.length,
                itemBuilder: (context, index, animation) {
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
                    pic_url: pic_url,
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
                    user: widget.user,
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
            ),
          ],
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
