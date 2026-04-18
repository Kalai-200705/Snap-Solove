import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackIssueScreen extends StatefulWidget {
  const TrackIssueScreen({super.key});

  @override
  State<TrackIssueScreen> createState() => _TrackIssueScreenState();
}

class _TrackIssueScreenState extends State<TrackIssueScreen> {
  GoogleMapController? mapController;

  // 📍 Issue location
  final LatLng issueLocation = const LatLng(13.0827, 80.2707); // Chennai

  // 👨‍🔧 Employee location (moving)
  LatLng employeeLocation = const LatLng(13.0827, 80.2707);

  String status = "Pending";

  Timer? timer;

  @override
  void initState() {
    super.initState();

    // 🔄 Status Flow
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => status = "Accepted");
      startTracking();
    });

    Future.delayed(const Duration(seconds: 8), () {
      if (!mounted) return;
      setState(() => status = "In Progress");
    });

    Future.delayed(const Duration(seconds: 15), () {
      if (!mounted) return;
      setState(() => status = "Completed");
      timer?.cancel();
    });
  }

  void startTracking() {
    timer = Timer.periodic(const Duration(seconds: 2), (t) {
      if (!mounted) return;
      setState(() {
        employeeLocation = LatLng(
          employeeLocation.latitude + 0.0005,
          employeeLocation.longitude + 0.0005,
        );
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // 🔴 CRASH FIX
    super.dispose();
  }

  // 🔢 Step logic
  int getCurrentStep() {
    switch (status) {
      case "Pending":
        return 1;
      case "Accepted":
        return 2;
      case "In Progress":
        return 3;
      case "Completed":
        return 4;
      default:
        return 1;
    }
  }

  // 🔵 Stepper UI
  Widget buildStepper() {
    int currentStep = getCurrentStep();

    List<String> steps = [
      "Submitted",
      "Accepted",
      "In Progress",
      "Completed"
    ];

    return Column(
      children: [
        Row(
          children: List.generate(steps.length, (index) {
            int step = index + 1;

            return Expanded(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: currentStep >= step
                        ? Colors.blue
                        : Colors.grey[300],
                    child: currentStep > step
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 16)
                        : Text("$step"),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    steps[index],
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: getCurrentStep() / 4,
          minHeight: 6,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }

  // 🎨 Status color
  Color getStatusColor() {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Accepted":
        return Colors.blue;
      case "In Progress":
        return Colors.indigo;
      case "Completed":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // 🧾 Complaint Details
 Widget complaintDetails(BuildContext context) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: isDark
          ? const Color.fromARGB(30, 255, 255, 255) // dark glass
          : Colors.grey.shade200, // light mode
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Complaint ID: #12345",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          "Issue: Garbage not collected",
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          "Location: Chennai",
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          "Description: Dustbin overflow for 3 days",
          style: TextStyle(
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
      ],
    ),
  );
}

  // 🔶 Status bar
  Widget statusBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: getStatusColor(),
      child: Text(
        "Status: $status",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Track Issue")),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // 🔵 Stepper
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: buildStepper(),
          ),

          const SizedBox(height: 10),

          // 🔶 Status
          statusBar(),

          // 🧾 Complaint Details
          complaintDetails(context),

          // 🗺️ Map
      Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: issueLocation,
                zoom: 14,
              ),
              onMapCreated: (controller) {
                mapController = controller;
              },
              markers: {
                Marker(
                  markerId: const MarkerId("issue"),
                  position: issueLocation,
                  infoWindow: const InfoWindow(title: "Issue Location"),
                ),
                Marker(
                  markerId: const MarkerId("employee"),
                  position: employeeLocation,
                  infoWindow: const InfoWindow(title: "Employee"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue,
                  ),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }}