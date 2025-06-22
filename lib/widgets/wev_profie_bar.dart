import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:whatsapp_mobile/services/login.dart';
class WebProfileBar extends StatelessWidget {
  const WebProfileBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.077,
      width: MediaQuery.of(context).size.width * 0.25,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            color: dividerColor,
          ),
        ),
        color: webAppBarColor
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          User[0]['profile_pic'] != null &&
              User[0]['profile_pic'].toString().isNotEmpty
              ? CircleAvatar(
            radius: 22.5,
            backgroundImage: NetworkImage(
              User[0]['profile_pic'].toString(),
            ),
          )
              : const CircleAvatar(
            radius: 22.5,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width:  MediaQuery.of(context).size.height * 0.1,),
          Row(
            children: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.comment, color: Colors.white,)),
              IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert, color: Colors.white,))

            ],

          ),

        ],
      ),
    );
  }
}
