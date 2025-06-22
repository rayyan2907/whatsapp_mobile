import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/services/contacts.dart';

class Contactlist extends StatelessWidget {
  const Contactlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){},
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: ListTile(
                title: Text(
                  contacts[index]['name'].toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    contacts[index]['message'].toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                leading:
                    contacts[index]['profile_pic'] != null &&
                        contacts[index]['profile_pic'].toString().isNotEmpty
                    ? CircleAvatar(
                        radius: 22.5,
                        backgroundImage: NetworkImage(
                          contacts[index]['profile_pic'].toString(),
                        ),
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
                      contacts[index]['time'].toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.green),
                    ),
                    const SizedBox(
                      height: 10,
                    ), // You can adjust this spacing if needed
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
