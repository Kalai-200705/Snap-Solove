import 'package:flutter/material.dart';

class IssueDetailScreen extends StatelessWidget {
  final String issueType;

  const IssueDetailScreen({super.key, required this.issueType});

  @override
  Widget build(BuildContext context) {
    String displayName = "";
    String description = "";

    switch (issueType) {
      case "road":
        displayName = "Road";
        description = "Report potholes, road damage, traffic issues.";
        break;
      case "water":
        displayName = "Water";
        description = "Report water leakage, drainage, supply issues.";
        break;
      case "electricity":
        displayName = "Electricity";
        description = "Report power cuts, faulty wires, street lights.";
        break;
      case "garbage":
        displayName = "Garbage";
        description = "Report waste overflow, garbage collection issues.";
        break;
    }

    return Scaffold(
      appBar: AppBar(title: Text(displayName)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          description,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
