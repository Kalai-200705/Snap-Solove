import 'package:flutter/material.dart';

class AssignedWorksScreen extends StatefulWidget {
  final List<Map<String, dynamic>> assignedWorks;
  final List<Map<String, dynamic>> myTasks;

  const AssignedWorksScreen({
    super.key,
    required this.assignedWorks,
    required this.myTasks,
  });

  @override
  State<AssignedWorksScreen> createState() => _AssignedWorksScreenState();
}

class _AssignedWorksScreenState extends State<AssignedWorksScreen> {
  void acceptWork(int index) {
    setState(() {
      final work = widget.assignedWorks[index];
      work["status"] = "Accepted";

      widget.myTasks.add(work);
      widget.assignedWorks.removeAt(index);
    });
  }

  void rejectWork(int index) {
    setState(() {
      widget.assignedWorks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assigned Works")),
      body: widget.assignedWorks.isEmpty
          ? const Center(child: Text("No assigned works"))
          : ListView.builder(
              itemCount: widget.assignedWorks.length,
              itemBuilder: (context, index) {
                final work = widget.assignedWorks[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(work["title"]),
                    subtitle: Text(work["desc"]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () => acceptWork(index),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: const Text("Accept"),
                        ),
                        const SizedBox(width: 5),
                        ElevatedButton(
                          onPressed: () => rejectWork(index),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text("Reject"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
