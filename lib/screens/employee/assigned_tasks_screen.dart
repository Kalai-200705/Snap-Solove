import 'package:flutter/material.dart';
import 'employee_dashboard.dart';

// 🔥 UPDATED TASK MODEL
class Task {
  String title;
  String instruction;
  String amount;
  String status;

  Task({
    required this.title,
    required this.instruction,
    required this.amount,
    required this.status,
  });
}

class AssignedTasksScreen extends StatefulWidget {
  const AssignedTasksScreen({super.key});

  @override
  State<AssignedTasksScreen> createState() => _AssignedTasksScreenState();
}

class _AssignedTasksScreenState extends State<AssignedTasksScreen> {
  final List<Task> assignedTasks = [
    Task(
      title: "Street Light Repair",
      instruction: "Fix street light in Zone 2",
      amount: "₹500",
      status: "Assigned",
    ),
    Task(
      title: "Garbage Cleaning",
      instruction: "Clean waste near market",
      amount: "₹300",
      status: "Assigned",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 HEADER
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text("SS", style: TextStyle(color: Colors.blue)),
                  ),
                  SizedBox(width: 10),
                  Text("Sagar Sharma", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    "Assigned Tasks",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ...assignedTasks.map((task) {
                    return taskCard(context, task);
                  }).toList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 🔥 TASK CARD (UPDATED)
  Widget taskCard(BuildContext context, Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Text(
            task.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          // ADMIN INSTRUCTION
          Text(
            task.instruction,
            style: const TextStyle(color: Colors.black87),
          ),

          const SizedBox(height: 10),

          // AMOUNT + BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                task.amount,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaskDetailScreen(task: task),
                    ),
                  );
                },
                child: const Text("View Details"),
              )
            ],
          )
        ],
      ),
    );
  }
}

// 🔥 DETAIL SCREEN (FORMAT SAME, DATA CHANGES)
class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(task.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                infoCard(
                  title: "Complaint Address",
                  child: const Text("Dynamic address here"),
                ),
                const SizedBox(height: 15),
                infoCard(
                  title: "Uploaded Images",
                  child: Row(
                    children: const [
                      Icon(Icons.image),
                      SizedBox(width: 10),
                      Icon(Icons.image),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                infoCard(
                  title: "Interactive Map",
                  child: Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: const Center(child: Text("Map Preview")),
                  ),
                ),
                const SizedBox(height: 15),
                infoCard(
                  title: "Admin Notes",
                  child: Text(task.instruction), // 🔥 dynamic
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // 🔥 ACCEPT BUTTON
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ElevatedButton(
              onPressed: () async {
                // 🔥 CONFIRMATION
                final confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Confirm"),
                    content: const Text("Accept this task?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Confirm"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Your task has been accepted"),
                    ),
                  );

                  // 🔥 GO TO DASHBOARD
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (_) => const EmployeeDashboard()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Accept Task"),
            ),
          )
        ],
      ),
    );
  }

  Widget infoCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
