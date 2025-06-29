import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:whatsapp_mobile/widgets/mainPages/calls.dart';
import 'package:whatsapp_mobile/widgets/mainPages/community.dart';
import 'package:whatsapp_mobile/widgets/mainPages/chatsPage.dart';
import 'package:whatsapp_mobile/widgets/mainPages/searchBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp_mobile/widgets/mainPages/settings.dart';
import 'package:whatsapp_mobile/widgets/mainPages/updates.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _selectedIndex = 3;

  static const List<Widget> _pages = <Widget>[
    UpdatesPage(),
    CallsPage(),
    CommunitiesPage(),
    Contactlist(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Container(
        padding: const EdgeInsets.only(
          top: 40,
          left: 16,
          right: 16,
          bottom: 12,
        ),
        color: backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top icons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF1E1E1E),
                  radius: 16,
                  child: Icon(Icons.more_horiz, color: Colors.white),
                ),
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFF1E1E1E),
                      radius: 16,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 19,
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Fluttertoast.showToast(
                          msg: "Comming Soon",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      },
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 16,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar() as PreferredSizeWidget?,
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 3
          ? FloatingActionButton(
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "Comming Soon",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.comment, color: Colors.white),
            )
          : null,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: appBarColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.circle),
              label: 'Updates',
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.phone),
              label: 'Calls',
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_3_fill),
              label: 'Communities',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(CupertinoIcons.chat_bubble_2_fill, size: 23),
                ],
              ),
              label: 'Chats',
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
