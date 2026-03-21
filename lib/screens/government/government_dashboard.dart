import 'package:flutter/material.dart';

/// 🎨 COLOR SYSTEM
class AppColors {
  static const primary = Color(0xFF0D47A1);
  static const secondary = Color(0xFF1976D2);
  static const background = Color(0xFFF5F7FA);

  static const success = Colors.green;
  static const warning = Colors.orange;
  static const danger = Colors.red;

  static const textDark = Colors.black87;
  static const textLight = Colors.white;
}

class GovernmentDashboard extends StatefulWidget {
  const GovernmentDashboard({super.key});

  @override
  State<GovernmentDashboard> createState() => _GovernmentDashboardState();
}

class _GovernmentDashboardState extends State<GovernmentDashboard> {
  String selectedMenu = "Dashboard";

  List<Map<String, dynamic>> issues = [
    {
      "title": "Garbage Overflow",
      "desc": "Garbage issue",
      "status": "Assigned",
      "assignedTo": "Employee 1",
      "proof": null,
      "location": "Lat: 11.2, Lng: 79.7",
      "isSelected": false,
      "isAccepted": false,
      "employeeStatus": "Not Started",
    },
    {
      "title": "Water Leakage",
      "desc": "Pipe broken",
      "status": "Pending",
      "assignedTo": null,
      "proof": null,
      "location": null,
      "isSelected": false,
      "isAccepted": false,
      "employeeStatus": "Not Started",
    },
  ];

  List<String> employees = ["Employee 1", "Employee 2"];

  List<Map<String, String>> _dummyCitizens = [
    {"name": "Citizen A", "id": "CIT001"},
    {"name": "Citizen B", "id": "CIT002"},
    {"name": "Citizen C", "id": "CIT003"},
  ];

  int get pending => issues.where((e) => e["status"] == "Pending").length;
  int get assigned => issues.where((e) => e["status"] == "Assigned").length;
  int get completed => issues.where((e) => e["status"] == "Completed").length;

  void assignEmployee(int index, String employee) {
    setState(() {
      issues[index]["assignedTo"] = employee;
      issues[index]["status"] = "Assigned";
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return width > 800 ? _buildWebLayout() : _buildMobileLayout();
  }

  // 📱 MOBILE
  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedMenu),
        backgroundColor: AppColors.primary,
      ),
      drawer: _buildDrawer(),
      body: Container(
        color: AppColors.background,
        child: _buildContent(),
      ),
    );
  }

  // 💻 WEB
  Widget _buildWebLayout() {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  // 🔵 SIDEBAR (WEB)
  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: AppColors.primary,
      child: ListView(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.admin_panel_settings, color: Colors.white, size: 50),
          const SizedBox(height: 10),
          const Center(
            child: Text("Government",
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          const Divider(color: Colors.white),
          _menuItem(Icons.dashboard, "Dashboard"),
          const Divider(color: Colors.white),
          _menuItem(Icons.assignment, "Assigned Issues"),
          _menuItem(Icons.pending, "Pending Issues"),
          _menuItem(Icons.check_circle, "Completed Issues"),
          const Divider(color: Colors.white),
          _menuItem(Icons.map, "Map View"),
          _menuItem(Icons.track_changes, "Live Tracking"),
          const Divider(color: Colors.white),
          _menuItem(Icons.bar_chart, "Reports & Charts"),
          _menuItem(Icons.people, "Employee Performance"),
          const Divider(color: Colors.white),
          _menuItem(Icons.notifications, "Notifications"),
          _menuItem(Icons.settings, "Settings"),
          _menuItem(Icons.logout, "Logout"),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.primary, // 🔥 ADD THIS LINE
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Text(
              "Government",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          _menuItem(Icons.dashboard, "Dashboard"),
          _menuItem(Icons.assignment, "Assigned Issues"),
          _menuItem(Icons.pending, "Pending Issues"),
          _menuItem(Icons.check_circle, "Completed Issues"),
          _menuItem(Icons.map, "Map View"),
          _menuItem(Icons.bar_chart, "Reports & Charts"),
          _menuItem(Icons.notifications, "Notifications"),
          _menuItem(Icons.settings, "Settings"),
          _menuItem(Icons.logout, "Logout"),
        ],
      ),
    );
  }

  // 🔹 MENU ITEM
  Widget _menuItem(IconData icon, String title) {
  return ListTile(
    leading: Icon(icon, color: Colors.white),
    title: Text(title, style: const TextStyle(color: Colors.white)),
    onTap: () {

      Navigator.pop(context); // close sidebar first

      // 🔥 ADD THIS CONDITION
      if (title == "Map View") {
        Navigator.pushNamed(context, '/map-view');
      }

    },
  );
}

  // 🔥 CONTENT SWITCH
  Widget _buildContent() {
    switch (selectedMenu) {
      case "Dashboard":
      case "Reports & Charts":
        return _buildDashboard();

      case "All Issues":
        return _buildIssueList(issues);

      case "Pending Issues":
        return _buildIssueList(
            issues.where((e) => e["status"] == "Pending").toList());

      case "Assigned Issues":
        return _buildIssueList(
            issues.where((e) => e["status"] == "Assigned").toList());

      case "Completed Issues":
        return _buildIssueList(
            issues.where((e) => e["status"] == "Completed").toList());

      default:
        return const Center(child: Text("Coming Soon"));
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏛 HEADER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome to Admin Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Here you can monitor citizen reports, manage employees, assign tasks, and verify completed works.",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 👷 EMPLOYEE LIST
          const Text(
            "Employee List",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          ...employees
              .map((e) => _buildUserCard(e, "EMP${employees.indexOf(e) + 1}")),

          const SizedBox(height: 20),

          // 👤 CITIZEN LIST
          const Text(
            "Citizen List",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          ..._dummyCitizens
              .map((c) => _buildUserCard(c["name"] ?? "", c["id"] ?? "")),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;

    switch (status) {
      case "Not Started":
        color = Colors.grey;
        break;
      case "In Progress":
        color = Colors.orange;
        break;
      case "Completed":
        color = Colors.green;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildUserCard(String name, String id) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(name),
        subtitle: Text("ID: $id"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  // 📋 ISSUE LIST
  Widget _buildIssueList(List<Map<String, dynamic>> list) {
    return Column(
      children: [
        // 🔥 ASSIGN BUTTON (TOP)
        ElevatedButton(
          onPressed: _assignSelectedIssues,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          child: const Text("Assign Selected Issues"),
        ),

        const SizedBox(height: 10),

        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final issue = list[index];

              return Card(
                child: Column(
                  children: [
                    CheckboxListTile(
                      value: issue["isSelected"],
                      onChanged: (value) {
                        setState(() {
                          issue["isSelected"] = value;
                        });
                      },
                      title: Text(issue["title"]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(issue["desc"]),
                          Text("Status: ${issue["status"]}"),
                          if (issue["status"] == "Assigned")
                            issue["isAccepted"]
                                ? const Text("🔒 Already Accepted")
                                : ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (!issue["isAccepted"]) {
                                          issue["isAccepted"] = true;
                                          issue["status"] = "Accepted";
                                          issue["employeeStatus"] =
                                              "Not Started";
                                        }
                                      });
                                    },
                                    child: const Text("Accept"),
                                  ),
                          if (issue["status"] == "Accepted")
                            DropdownButton<String>(
                              value: issue["employeeStatus"],
                              items: ["Not Started", "In Progress", "Completed"]
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  issue["status"] = value!;
                                  issue["employeeStatus"] = value;
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                    if (issue["assignedTo"] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          // 👷 Employee Name
                          Text(
                            "👷 Employee: ${issue["assignedTo"]}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 5),
                          // 📊 Employee Status
                          Row(
                            children: [
                              const Text("Status: "),
                              _buildStatusChip(issue["employeeStatus"]),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _assignSelectedIssues() {
    List selected = issues.where((e) => e["isSelected"] == true).toList();

    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No issues selected")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) {
        String? selectedEmployee;

        return AlertDialog(
          title: const Text("Assign to Employee"),
          content: DropdownButtonFormField<String>(
            items: employees
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              selectedEmployee = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedEmployee != null) {
                  setState(() {
                    for (var issue in selected) {
                      issue["assignedTo"] = selectedEmployee;
                      issue["status"] = "Assigned";
                      issue["isSelected"] = false;
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Assign"),
            ),
          ],
        );
      },
    );
  }

  // 🎨 STATUS COLORS
  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return AppColors.danger;
      case "Assigned":
        return AppColors.warning;
      case "Completed":
        return AppColors.success;
      case "Verified":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
