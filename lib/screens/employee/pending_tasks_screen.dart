import 'package:flutter/material.dart';
import 'progress_screen.dart';

// 🔥 TASK MODEL
class Task {
  String title;
  String instruction;
  String amount;

  bool locationShared;

  Task({
    required this.title,
    required this.instruction,
    required this.amount,
    this.locationShared = false,
  });
}

class PendingTasksScreen extends StatefulWidget {
  final List<Task> pendingTasks;

  const PendingTasksScreen({super.key, required this.pendingTasks});

  @override
  State<PendingTasksScreen> createState() => _PendingTasksScreenState();
}

class _PendingTasksScreenState extends State<PendingTasksScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pending Tasks")),

      body: widget.pendingTasks.isEmpty
          ? const Center(child: Text("No Pending Tasks"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.pendingTasks.length,
              itemBuilder: (context, index) {
                final task = widget.pendingTasks[index];
                return taskCard(task, index);
              },
            ),
    );
  }

  Widget taskCard(Task task, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(task.title,
              style: const TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 8),

          Text(task.instruction),

          const SizedBox(height: 10),

          Text(task.amount,
              style: const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold)),

          const SizedBox(height: 15),

          // 🔥 SHARE LOCATION
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                task.locationShared = true;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Location Shared")),
              );
            },
            icon: const Icon(Icons.location_on),
            label: const Text("Share Location"),
          ),

          const SizedBox(height: 10),

          // 🔥 GO TO PROGRESS PAGE
          ElevatedButton(
            onPressed: task.locationShared
                ? () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProgressScreen(task: task),
                      ),
                    );

                    if (result == true) {
                      setState(() {
                        widget.pendingTasks.removeAt(index);
                      });
                    }
                  }
                : null,
            child: const Text("Update Progress"),
          ),
        ],
      ),
    );
  }
}