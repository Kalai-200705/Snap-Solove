import 'package:flutter/material.dart';
import '../../routes/route_names.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [

      // 🔵 HEADER
      UserAccountsDrawerHeader(
        accountName: const Text("Citizen"),
        accountEmail: const Text("test@gmail.com"),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.person, size: 40, color: Colors.blue),
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF1565C0),
        ),
      ),

      // 🏠 Dashboard
      ListTile(
        leading: const Icon(Icons.dashboard),
        title: const Text("Dashboard"),
        onTap: () {
          Navigator.pop(context);
        },
      ),

      // 📸 Report Issue
      ListTile(
        leading: const Icon(Icons.report_problem),
        title: const Text("Report Issue"),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/report');
        },
      ),

      // 📄 My Reports
      ListTile(
        leading: const Icon(Icons.list_alt),
        title: const Text("My Reports"),
        onTap: () {
          Navigator.pop(context);
        },
      ),

      // 🗺 Map View
      ListTile(
        leading: const Icon(Icons.map),
        title: const Text("Map View"),
        onTap: () {
          Navigator.pop(context);
        },
      ),

      const Divider(),

      // ⚙️ Settings
      ListTile(
        leading: const Icon(Icons.settings),
        title: const Text("Settings"),
        onTap: () {
          Navigator.pop(context);
        },
      ),

      // 🚪 Logout
      ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text(
          "Logout",
          style: TextStyle(color: Colors.red),
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/');
        },
      ),
    ],
  ),
),
      appBar: AppBar(
        title: const Text("Citizen Dashboard"),
        backgroundColor: const Color(0xFF1565C0),
        actions: const [
          Icon(Icons.notifications),
          SizedBox(width: 15),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 👋 Welcome Text
            const Text(
              "Welcome, Citizen 👋",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Report and track civic issues easily",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // 🚀 Quick Action Button
            SizedBox(
              width: double.infinity,
              child: AnimatedActionButton(
  text: "Report New Issue",
  icon: Icons.add,
  onPressed: () {
    Navigator.pushNamed(context, RouteNames.reportIssue);
  },
),
            ),

            const SizedBox(height: 20),

            // 📋 Section Title
            const Text(
              "Your Reported Issues",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // 📦 Issue List
            Expanded(
              child: ListView(
                children: const [

                  IssueCard(
                    title: "Garbage Overflow",
                    status: "Pending",
                    color: Colors.orange,
                  ),

                  IssueCard(
                    title: "Street Light Not Working",
                    status: "In Progress",
                    color: Colors.blue,
                  ),

                  IssueCard(
                    title: "Water Leakage",
                    status: "Completed",
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 📦 Issue Card Widget
class IssueCard extends StatelessWidget {
  final String title;
  final String status;
  final Color color;

  const IssueCard({
    super.key,
    required this.title,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: const Icon(Icons.report_problem, color: Colors.red),
        title: Text(title),
        subtitle: Text("Status: $status"),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
class AnimatedActionButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const AnimatedActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<AnimatedActionButton> {
  double scale = 1.0;

  void _onTapDown(_) => setState(() => scale = 0.95);
  void _onTapUp(_) => setState(() => scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => scale = 1.0),
      onTap: widget.onPressed,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: scale,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}