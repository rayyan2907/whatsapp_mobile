import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:whatsapp_mobile/screens/mobile_chat_screen.dart';
import 'package:whatsapp_mobile/services/contacts.dart';
import 'package:whatsapp_mobile/widgets/mainPages/searchBar.dart';

import '../../services/RegAndLogin/logOutService.dart';
import '../../services/getUser.dart';
import '../players/imageViewer.dart';

class Contactlist extends StatefulWidget {
  const Contactlist({super.key});

  @override
  State<Contactlist> createState() => _ContactlistState();
}


class _ContactlistState extends State<Contactlist> {
  bool _isLoading = false;
  List contacts = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadContacts();
    connectToSignalR();

  }
  void loadContacts()async{
    setState(() {
      _isLoading=true;
    });
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt');

      final result = await GetContacts().loadContacts(token);
    if (!mounted) return;
      setState(() {
        _isLoading=false;
        contacts=result;
      });
  }
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final localPic = prefs.getString('profile_pic_url');
    final user = await GetUser.getLoggedInUser();
    print(user);

  }
  Future<void> connectToSignalR() async {
    final user = await GetUser.getLoggedInUser();
    if (user == null) return;

    final userId = user['user_id'].toString();

    final hubConnection = HubConnectionBuilder()
        .withUrl(
      'http://192.168.0.101:5246/statusHub?user_id=$userId',
      HttpConnectionOptions(transport: HttpTransportType.webSockets),
    )
        .build();

    await hubConnection.start();
    print(" Connected to SignalR as $userId");
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: Text(
            'Chats',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [WhatsAppSearchBar(), SizedBox(height: 8)]),
        ),
        if (contacts.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                "No contacts found",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        else
          ...contacts.map((contact) => InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MobileChatScreen(user: contact),
                ),
              );
            },
            child: ListTile(
              title: Text(
                contact['first_name'].toString() + " " + contact['last_name'].toString(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Builder(
                  builder: (_) {
                    final type = contact['last_msg_type']?.toString() ?? '';
                    String displayText;
                    switch (type) {
                      case 'img':
                        displayText = '📷 Photo';
                        break;
                      case 'video':
                        displayText = '🎥 Video';
                        break;
                      case 'voice':
                        displayText = '🎤 Voice message';
                        break;
                      case 'msg':
                        displayText = 'Message';
                        break;
                      default:
                        displayText = 'Message';
                    }

                    return Text(
                      displayText,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                      ),
                    );
                  },
                ),
              ),
              leading: GestureDetector(
                onTap: () {
                  if (contact['profile_pic_url'] != null &&
                      contact['profile_pic_url'].toString().isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ImageViewer(
                          imageUrl: contact['profile_pic_url'].toString(),
                        ),
                      ),
                    );
                  }
                },
                child: Hero(
                  tag: contact['profile_pic_url'] ?? 'default_dp',
                  child: contact['profile_pic_url'] != null &&
                      contact['profile_pic_url'].toString().isNotEmpty
                      ? CircleAvatar(
                    radius: 22.5,
                    backgroundImage: NetworkImage(
                      contact['profile_pic_url'].toString(),
                    ),
                  )
                      : const CircleAvatar(
                    radius: 22.5,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    contact['last_msg_time'].toString(),
                    style: const TextStyle(fontSize: 10, color: Colors.green),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          )),
      ],
    );
  }
}