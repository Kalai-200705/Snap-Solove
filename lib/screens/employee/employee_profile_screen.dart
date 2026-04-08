import 'package:flutter/material.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});

  @override
  State<EmployeeProfileScreen> createState() =>
      _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {

  bool isAvailable = true;
  bool locationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔥 PROFILE HEADER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        size: 40, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Sagar Sharma",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Field Officer",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 15),

                  // 🔥 STATUS TOGGLE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Status: ",
                          style: TextStyle(color: Colors.white)),
                      Switch(
                        value: isAvailable,
                        onChanged: (value) {
                          setState(() {
                            isAvailable = value;
                          });
                        },
                      ),
                      Text(
                        isAvailable ? "Available" : "Busy",
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 TASK STATS
            Row(
              children: [
                statCard("Assigned", "12", Colors.blue),
                statCard("Pending", "5", Colors.orange),
                statCard("Completed", "40", Colors.green),
              ],
            ),

            const SizedBox(height: 20),

            // 🔥 PERSONAL INFO
            sectionTitle("Personal Info"),
            profileTile(Icons.badge, "Employee ID", "EMP1023"),
            profileTile(Icons.email, "Email", "sagar@gmail.com"),
            profileTile(Icons.phone, "Phone", "+91 9876543210"),
            profileTile(Icons.location_on, "Location", "Chennai"),

            const SizedBox(height: 20),

            // 🔥 WORK INFO
            sectionTitle("Work Info"),
            profileTile(Icons.work, "Department", "Public Works"),
            profileTile(Icons.map, "Zone", "Zone 3"),
            profileTile(Icons.access_time, "Shift", "9 AM - 5 PM"),

            const SizedBox(height: 20),

            // 🔥 SETTINGS / ACTIONS
            sectionTitle("Settings"),

            switchTile(
              Icons.location_on,
              "Enable Location Tracking",
              locationEnabled,
              (val) {
                setState(() {
                  locationEnabled = val;
                });
              },
            ),

            actionTile(
              Icons.edit,
              "Edit Profile",
              Colors.blue,
              () {
                showSnack("Edit Profile Clicked");
              },
            ),

            actionTile(
              Icons.lock,
              "Change Password",
              Colors.orange,
              () {
                showSnack("Change Password Clicked");
              },
            ),

            actionTile(
              Icons.logout,
              "Logout",
              Colors.red,
              () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 STAT CARD
  Widget statCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 5),
            Text(title),
          ],
        ),
      ),
    );
  }

  // 🔥 PROFILE TILE
  Widget profileTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  // 🔥 SWITCH TILE
  Widget switchTile(IconData icon, String title, bool value,
      Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 15),
          Expanded(child: Text(title)),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  // 🔥 ACTION TILE
  Widget actionTile(
      IconData icon, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 15),
            Expanded(child: Text(title)),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  // 🔥 SECTION TITLE
  Widget sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}