import 'package:flutter/material.dart';
import '../../routes/route_names.dart';
import 'package:snap_solve/screens/auth/role_selection_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDark =
    Theme.of(context).brightness == Brightness.dark;
    String userName = "Citizen";

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            /// 🔷 HEADER
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A5AE0), Color(0xFF8E7CFF)],
                ),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Welcome User",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),

            /// 🔹 MENU ITEMS (TOP)
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Profile"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, RouteNames.profile);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.track_changes, color: Colors.green),
                    title: Text("Track Issue"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, RouteNames.trackIssue);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text("Notifications"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, RouteNames.notifications);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.feedback),
                    title: Text("Feedback"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, RouteNames.feedback);
                    },
                  ),
                ],
              ),
            ),

            /// 🔻 DIVIDER
            const Divider(),

            /// ⚙️ SETTINGS (BOTTOM HIGHLIGHT)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A5AE0), Color(0xFF8E7CFF)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white),
                 title: Text(
  "Settings",
  style: TextStyle(
    color: Theme.of(context).colorScheme.onSurface,
  ),
),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, RouteNames.settings);
                  },
                ),
              ),
            ),

            /// 🚪 LOGOUT (BOTTOM)
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => RoleSelectionScreen()),
    (route) => false,
  );
},
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white), // ☰ three lines
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),

        //Notification Icon
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.notifications);
                },
              ),

              // 🔴 Badge
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: const Text(
                    '3', // 👈 unread count (change later dynamic)
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 👋 Welcome
            Text(
              "Welcome, $userName",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            /// 🏆 Citizen Score Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6A5AE0),
                    Color(0xFF8E7CFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Citizen Score",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text(
                        "120 Points",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                  Icon(Icons.emoji_events, color: Colors.amber, size: 40),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🚨 BIG REPORT BUTTON
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withAlpha(50),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB71C1C),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.reportIssue);
                },
                icon: const Icon(Icons.warning, size: 28, color: Colors.yellow),
                label: const Text(
                  "REPORT ISSUE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

           

            /// 📌 Recent Activity
             Text(
  "Recent Activity",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface, // 🔥 add this
  ),
),

            const SizedBox(height: 10),

            activityTile("Garbage issue reported", isDark),
            activityTile("Street light fixed", isDark),

            const SizedBox(height: 20),

            /// 📊 Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                statCard("3", "Total", isDark),
                statCard("1", "Pending", isDark),
                statCard("1", "Done", isDark),
              ],
            ),

            const SizedBox(height: 20),

            /// 📋 Issues
            const Text("Your Issues",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            issueTile("Garbage Overflow", "Pending", Colors.orange),
            issueTile("Street Light Not Working", "In Progress", Colors.blue),
            issueTile("Water Leakage", "Completed", Colors.green),
          ],
        ),
      ),
    );
  }

  /// 🔘 Quick Button
  Widget quickBtn(IconData icon, String text) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(height: 5),
        Text(text),
      ],
    );
  }

  /// 📌 Activity Tile
 Widget activityTile(String text, bool isDark) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      color: isDark
          ? const Color.fromARGB(20, 255, 255, 255)
          : const Color.fromARGB(240, 255, 255, 255),
      border: Border.all(
        color: isDark
            ? const Color.fromARGB(25, 255, 255, 255)
            : Colors.grey.shade300,
      ),
    ),
    child: Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 26),
        const SizedBox(width: 12),

        Text(
          text,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black, // ✅ FIX
            fontSize: 15,
          ),
        ),
      ],
    ),
  );
}

  /// 📊 Stat Card
  Widget statCard(String value, String title, bool isDark) {
  return Container(
    width: 100,
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
  color: isDark
      ? Colors.white.withAlpha(13)
      : Theme.of(context).cardColor,
  borderRadius: BorderRadius.circular(12),
  boxShadow: isDark
      ? [
          BoxShadow(
            color: Colors.blue.withAlpha(77),
            blurRadius: 10,
          )
        ]
      : [],
),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.7),
          ),
        ),
      ],
    ),
  );
}

  /// 📋 Issue Tile
  Widget issueTile(String title, String status, Color color) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.grey[200], // 👈 background fix
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(
          blurRadius: 5,
          color: Colors.black12,
        )
      ],
    ),
    child: Row(
      children: [
        Icon(Icons.check_circle, color: color, size: 30),
        const SizedBox(width: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black, // 👈 முக்கியம்
              ),
            ),

            Text(
              status,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}}
