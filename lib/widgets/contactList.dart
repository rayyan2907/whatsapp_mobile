import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/services/contacts.dart';

class Contactlist extends StatelessWidget {
  const Contactlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context,index){
              return ListTile(
                 title: Text(contacts[index]['name'].toString(),style: const TextStyle(fontSize: 18),),
                subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(contacts[index]['message'].toString(),style: const TextStyle(fontSize: 15),),
                ),
              );
          },
      ),
    );
  }
}
