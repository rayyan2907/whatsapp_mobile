import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdatesPage extends StatelessWidget {
  const UpdatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Top Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Updates",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
            const SizedBox(height: 20),

            // My Status Row
            Row(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=1"),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.green,
                        child: const Icon(CupertinoIcons.add, size: 16, color: Colors.white),
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("My status", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                      SizedBox(height: 4),
                      Text("Add to my status", style: TextStyle(color: Colors.white60)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.camera_fill, color: Colors.white,size: 19 ,),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.pencil, color: Colors.white,size: 21,),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Recent Updates Header
            const Text(
              "Recent updates",
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            // No recent updates placeholder
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: const Text(
                "No recent updates",
                style: TextStyle(color: Colors.white38, fontSize: 16),
              ),
            ),

            const SizedBox(height: 30),

            // Channels
            const Text(
              "Channels",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Stay updated on the topics that matters you. Find channels to follow below.",
              style: TextStyle(color: Colors.white38, fontSize: 16),
            ),
            const SizedBox(height: 20),

            const Text(
              "Find channels to follow",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              onPressed: () {},
              child: const Text("Explore more", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
