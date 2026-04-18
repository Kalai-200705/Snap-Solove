import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key}); // ✅ important

  @override
  Widget build(BuildContext context) {

    final List<String> notifications = [
      "Employee assigned to your complaint",
      "Employee accepted the complaint",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),

      body: notifications.isEmpty
          ? const Center(
              child: Text("No notifications yet"),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text(notifications[index]),
                );
              },
            ),
    );
  }
}