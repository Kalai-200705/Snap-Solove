import 'dart:io';
import 'package:flutter/material.dart';

// 🔥 COMPLETED TASK MODEL
class CompletedTask {
  String title;
  String instruction;
  String amount;
  File beforeImage;
  File afterImage;
  String completedTime;

  CompletedTask({
    required this.title,
    required this.instruction,
    required this.amount,
    required this.beforeImage,
    required this.afterImage,
    required this.completedTime,
  });
}

class CompletedTasksScreen extends StatelessWidget {
  final List<CompletedTask> completedTasks;

  const CompletedTasksScreen({super.key, required this.completedTasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Completed Tasks"),
        backgroundColor: Colors.green,
      ),

      body: completedTasks.isEmpty
          ? const Center(child: Text("No Completed Tasks"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: completedTasks.length,
              itemBuilder: (context, index) {
                final task = completedTasks[index];
                return completedCard(task);
              },
            ),
    );
  }

  // 🔥 COMPLETED CARD
  Widget completedCard(CompletedTask task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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

          // 🔹 TITLE + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              statusChip(),
            ],
          ),

          const SizedBox(height: 8),

          // 🔹 INSTRUCTION
          Text(task.instruction),

          const SizedBox(height: 10),

          // 🔹 AMOUNT
          Text(
            task.amount,
            style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          // 🔥 IMAGES
          Row(
            children: [
              Expanded(child: imageBox(task.beforeImage, "Before")),
              const SizedBox(width: 10),
              Expanded(child: imageBox(task.afterImage, "After")),
            ],
          ),

          const SizedBox(height: 10),

          // 🔹 TIME
          Text(
            "Completed: ${task.completedTime}",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // 🔹 STATUS CHIP
  Widget statusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        "Completed",
        style: TextStyle(color: Colors.green),
      ),
    );
  }

  // 🔹 IMAGE BOX
  Widget imageBox(File image, String label) {
    return Column(
      children: [
        Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(image, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}