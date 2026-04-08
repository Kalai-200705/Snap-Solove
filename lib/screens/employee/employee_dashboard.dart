import 'package:flutter/material.dart';
import 'assigned_tasks_screen.dart';
import 'map_screen.dart';
import 'employee_profile_screen.dart';
import 'pending_tasks_screen.dart' as pending;
import 'completed_tasks_screen.dart';

// 🔹 TEMP SCREENS (so navigation works)

class TaskListScreen extends StatelessWidget {
  final String title;

  const TaskListScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.task),
            title: Text("Task ${index + 1}"),
            subtitle: const Text("Task description"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      TaskDetailScreen(taskName: "Task ${index + 1}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  final String taskName;

  const TaskDetailScreen({super.key, required this.taskName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(taskName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.image, size: 100),
            const SizedBox(height: 20),
            const Text("Task full details here"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Marked as Completed")),
                );
              },
              child: const Text("Mark as Completed"),
            )
          ],
        ),
      ),
    );
  }
}

// 🔥 MAIN DASHBOARD
class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: const DashboardHome(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const EmployeeMapView()));
          } else if (index == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const EmployeeProfileScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// 🔥 HOME PAGE (your UI improved + clickable)
class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text("SS", style: TextStyle(color: Colors.blue)),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Sagar Sharma",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    const Icon(Icons.notifications, color: Colors.white),
                    Positioned(
                      right: 0,
                      child: Container(
                        height: 8,
                        width: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          // 🔹 BODY
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tuesday, 24 October 2023",
                      style: TextStyle(color: Colors.grey)),

                  const SizedBox(height: 10),

                  const Text(
                    "Welcome Back, Sagar!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const Text("Here is your dashboard overview.",
                      style: TextStyle(color: Colors.grey)),

                  const SizedBox(height: 20),

                  // 🔥 CLICKABLE CARDS
                  Row(
                    children: [
                      assignedTasksCard(context),
                      pendingTasksCard(context),
                      completedTasksCard(context),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔹 HISTORY
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("History",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.green),
                          title: Text("Task Completed: Q3 Report"),
                          subtitle: Text("2 hours ago"),
                        ),
                        ListTile(
                          leading: Icon(Icons.assignment, color: Colors.orange),
                          title: Text("Task Reassigned: Site Visit"),
                          subtitle: Text("1 day ago"),
                        ),
                        ListTile(
                          leading: Icon(Icons.description, color: Colors.blue),
                          title: Text("New Task Added: Inventory Audit"),
                          subtitle: Text("2 days ago"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // 🔥 CLICKABLE CARD FUNCTION
  Widget dashboardCard(BuildContext context, IconData icon, String title,
      String count, Color color, String screenTitle) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TaskListScreen(title: screenTitle),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 10),
              Text(title),
              const SizedBox(height: 5),
              Text(count,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 ASSIGNED TASKS CARD
  Widget assignedTasksCard(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AssignedTasksScreen(),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(Icons.assignment, color: Colors.blue, size: 30),
              const SizedBox(height: 10),
              const Text("Assigned Tasks"),
              const SizedBox(height: 5),
              const Text("14",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 PENDING TASKS CARD
  Widget pendingTasksCard(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => pending.PendingTasksScreen(
                pendingTasks: [
                  pending.Task(
                    title: "Drainage Cleaning",
                    instruction:
                        "Clean the blocked drainage area near Sector 12.",
                    amount: "₹500",
                  ),
                  pending.Task(
                    title: "Streetlight Repair",
                    instruction:
                        "Inspect and repair the damaged streetlight on MG Road.",
                    amount: "₹700",
                  ),
                  pending.Task(
                    title: "Garbage Pickup",
                    instruction:
                        "Collect unprocessed garbage from Block C market.",
                    amount: "₹400",
                  ),
                  pending.Task(
                    title: "Pothole Filling",
                    instruction: "Fill potholes reported near the bus stand.",
                    amount: "₹900",
                  ),
                  pending.Task(
                    title: "Water Leakage Check",
                    instruction:
                        "Verify and resolve pipeline leakage near Green Park.",
                    amount: "₹650",
                  ),
                  pending.Task(
                    title: "Park Cleaning",
                    instruction:
                        "Complete general cleaning at Central Park entrance.",
                    amount: "₹550",
                  ),
                ],
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(Icons.pending_actions, color: Colors.orange, size: 30),
              const SizedBox(height: 10),
              const Text("Pending Tasks"),
              const SizedBox(height: 5),
              const Text("06",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 COMPLETED TASKS CARD
  Widget completedTasksCard(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CompletedTasksScreen(
                completedTasks: [],
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              const SizedBox(height: 10),
              const Text("Completed Tasks"),
              const SizedBox(height: 5),
              const Text("45",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
