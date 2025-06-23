import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/screens/mobile_chat_screen.dart';
import 'package:whatsapp_mobile/services/contacts.dart';
import 'package:whatsapp_mobile/widgets/searchBar.dart';

class Contactlist extends StatelessWidget {
  const Contactlist({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: contacts.length + 2, // +2 for title and search bar
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(16, 5, 16, 10),
            child: Text(
              'Chats',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        } else if (index == 1) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                WhatsAppSearchBar(),
                SizedBox(height: 8,)
              ],
            ),
          );
        }

        final contact = contacts[index - 2];
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MobileChatScreen(user: contact)),
            );
          },
          child: ListTile(
            title: Text(
              contact['name'].toString(),
              style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                contact['message'].toString(),
                style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w300),
              ),
            ),
            leading: contact['profile_pic'] != null && contact['profile_pic'].toString().isNotEmpty
                ? CircleAvatar(
              radius: 22.5,
              backgroundImage: NetworkImage(contact['profile_pic'].toString()),
            )
                : const CircleAvatar(
              radius: 22.5,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  contact['time'].toString(),
                  style: const TextStyle(fontSize: 10, color: Colors.green),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
