import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_mobile/color.dart';

import '../../screens/mobile_chat_screen.dart';
import '../../services/getUser.dart';
import '../../services/RegAndLogin/logOutService.dart';
import '../../services/searchBar/searchService.dart';

class WhatsAppSearchBar extends StatefulWidget {
  const WhatsAppSearchBar({super.key});

  @override
  State<WhatsAppSearchBar> createState() => _WhatsAppSearchBarState();
}

class _WhatsAppSearchBarState extends State<WhatsAppSearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  bool _isLoading = false;

  List<dynamic> _users = [];


  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 100), () {
      final trimmedQuery = query.trim();
      if (trimmedQuery.isNotEmpty) {
        _searchUsers(trimmedQuery);
      } else {
        setState(() {
          _users.clear();
        });
      }
    });
  }


  Future<void> _searchUsers(String query) async {
    setState(() {
      _users.clear();
      _isLoading=true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt');
      final results = await SearchService().searchUsers(query, token);

      setState(() {
        _users = results;
      });
    } catch (e) {
      print("Error in SearchService: $e");
    }
    finally{
      setState(() {
        _isLoading=false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 38,
          child: TextField(
            controller: _controller,
            onChanged: _onSearchChanged,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: searchBarColor,
              prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 18),
              hintText: 'Search...',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: Colors.greenAccent,
              strokeWidth: 2,
            ),
          ),
        if (_users.isNotEmpty)
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 300, // Set your desired max height
            ),
            child: Scrollbar(

              radius: const Radius.circular(10),
              thumbVisibility: true,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),

                shrinkWrap: true,
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: InkWell(
                      onTap: () {
                        print("Tapped user: ${user.toString()}");
                        setState(() {
                          FocusScope.of(context).unfocus();
                        });

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MobileChatScreen(user: user),
                          ),

                        );
                        setState(() {
                          _users.clear();
                          _controller.clear();
                          FocusScope.of(context).unfocus();


                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F2C34), // dark background
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ListTile(


                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade500,
                            backgroundImage: (user['profile_pic_url'] != null && user['profile_pic_url'] != "")
                                ? NetworkImage(user['profile_pic_url'])
                                : null,
                            child: (user['profile_pic_url'] == null || user['profile_pic_url'] == "")
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          title: Text(
                            "${user['first_name']} ${user['last_name']}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            user['email'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),


      ],
    );
  }
}
