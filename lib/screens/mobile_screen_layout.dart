import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:whatsapp_mobile/widgets/contactList.dart';
import 'package:whatsapp_mobile/widgets/searchBar.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Contactlist(),

    Center(child: Text('Update Pannel Comming Soon')),
    Center(child: Text('Calls Pannel Comming Soon')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "WhatsApp",
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: const WhatsAppSearchBar(),
        ),
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
          onPressed: (){},
        backgroundColor: tabColor,
        child: const Icon(Icons.comment,color: Colors.white,),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Prevents shifting
          backgroundColor: appBarColor,
          selectedItemColor: tabColor,
          unselectedItemColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
            BottomNavigationBarItem(
              icon: Icon(Icons.donut_large),
              label: 'Updates',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'),
          ],
        ),
      ),
    );
  }
}
