import 'package:flutter/material.dart';
import 'issue_details_screen.dart';

class MyTasksScreen extends StatelessWidget {
  final List<Map<String, dynamic>> myTasks;

  const MyTasksScreen({super.key, required this.myTasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Tasks")),
      body: myTasks.isEmpty
          ? const Center(child: Text("No tasks assigned yet."))
          : ListView.builder(
              itemCount: myTasks.length,
              itemBuilder: (context, index) {
                final task = myTasks[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(task["title"]),
                    subtitle: Text("Status: ${task["status"]}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => IssueDetailsScreen(issue: task),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
