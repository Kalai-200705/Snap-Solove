import 'package:flutter/material.dart';
import './assigned_works_screen.dart';
import './my_tasks_screen.dart';
import './issue_details_screen.dart';

// 🌍 Global Data (shared)
List<Map<String, dynamic>> assignedWorks = [
  {
    "title": "Garbage Overflow",
    "desc": "Garbage not collected",
    "status": "Assigned",
  },
];

List<Map<String, dynamic>> myTasks = [];

class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Dashboard"),
        backgroundColor: const Color(0xFF1565C0),
      ),
      drawer: _buildDrawer(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 👋 Welcome
            const Text(
              "Welcome, Employee 👷",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            const Text(
              "Manage assigned issues efficiently",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // 📊 STATS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                    "Assigned", assignedWorks.length.toString(), Colors.blue),
                _buildStatCard(
                    "Tasks", myTasks.length.toString(), Colors.orange),
                _buildStatCard(
                    "Done",
                    myTasks
                        .where((e) => e["status"] == "Completed")
                        .length
                        .toString(),
                    Colors.green),
              ],
            ),

            const SizedBox(height: 25),

            // 📋 QUICK VIEW (Assigned)
            const Text(
              "Recent Assigned Works",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            if (assignedWorks.isEmpty)
              const Text("No assigned works")
            else
              ...assignedWorks.map((issue) => _buildPreviewCard(issue)).toList(),
          ],
        ),
      ),
    );
  }

  // 🔹 STAT CARD
  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(count,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(title),
        ],
      ),
    );
  }

  // 🔹 PREVIEW CARD (CLICK → DETAILS)
  Widget _buildPreviewCard(Map<String, dynamic> issue) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => IssueDetailsScreen(issue: issue),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
            )
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.report_problem, color: Colors.orange),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(issue["title"],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(issue["desc"],
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 14)
          ],
        ),
      ),
    );
  }

  // 🔹 DRAWER
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          UserAccountsDrawerHeader(
            accountName: const Text("Employee"),
            accountEmail: const Text("employee@gmail.com"),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.engineering),
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1565C0),
            ),
          ),

          // 📥 Assigned Works
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text("Assigned Works"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AssignedWorksScreen(
                    assignedWorks: assignedWorks,
                    myTasks: myTasks,
                  ),
                ),
              );
            },
          ),

          // 🛠 My Tasks
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text("My Tasks"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MyTasksScreen(myTasks: myTasks),
                ),
              );
            },
          ),

          const Divider(),

          // 🚪 Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout",
                style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}