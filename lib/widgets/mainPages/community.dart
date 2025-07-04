import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:whatsapp_mobile/color.dart';

class CommunitiesPage extends StatelessWidget {
  const CommunitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with title and plus icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                    child: const Text(
                      "Communities",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Placeholder illustration (you can replace with Image.asset or network image)
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.groups,
                    color: Colors.green,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Title
              const Center(
                child: Text(
                  "Stay connected with a community",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),

              // Description
              const Center(
                child: Text(
                  "Communities bring members together in topic-\nbased groups. Any community you're added to\nwill appear here.",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),

              // See example link
              Center(
                child: GestureDetector(
                  onTap: () {
                    showToast(
                      "Comming soon",
                      duration: Duration(seconds: 2), // Equivalent to LENGTH_SHORT
                      position: ToastPosition.top,
                      backgroundColor: Colors.red,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                      radius: 8.0, // optional, for rounded edges
                    );
                  },
                  child: const Text(
                    "See example communities >",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const Spacer(),

              // Button: New Community
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    showToast(
                      "Comming soon",
                      duration: Duration(seconds: 2), // Equivalent to LENGTH_SHORT
                      position: ToastPosition.top,
                      backgroundColor: Colors.red,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                      radius: 8.0, // optional, for rounded edges
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "New Community",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
