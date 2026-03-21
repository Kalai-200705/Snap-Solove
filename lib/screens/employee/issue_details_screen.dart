import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

class IssueDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> issue;

  const IssueDetailsScreen({super.key, required this.issue});

  @override
  State<IssueDetailsScreen> createState() => _IssueDetailsScreenState();
}

class _IssueDetailsScreenState extends State<IssueDetailsScreen> {

  File? beforeImage;
  File? afterImage;

  String locationText = "Location not captured";

  String status = "Accepted";

  // 📷 Capture Image
  Future<File?> captureImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.camera);
    if (file == null) return null;
    return File(file.path);
  }

  // 📍 Get Location
  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        locationText = "Permission denied";
      });
      return;
    }

    Position pos = await Geolocator.getCurrentPosition();
    setState(() {
      locationText = "Lat: ${pos.latitude}, Lng: ${pos.longitude}";
    });
  }

  // ✅ Step validation
  bool get step1Done => beforeImage != null;
  bool get step2Done => status == "In Progress" || status == "Completed";
  bool get step3Done => afterImage != null;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Issue Details"),
        backgroundColor: const Color(0xFF1565C0),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🧾 TITLE
            Text(widget.issue["title"],
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),

            const SizedBox(height: 5),

            Text(widget.issue["desc"],
                style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 20),

            // 🔥 STEP 1
            _buildStepTitle("Step 1: Capture Issue Image", step1Done),

            GestureDetector(
              onTap: () async {
                final img = await captureImage();
                if (img != null) {
                  setState(() {
                    beforeImage = img;
                  });
                }
              },
              child: _buildImageBox(beforeImage),
            ),

            const SizedBox(height: 20),

            // 🔥 STEP 2
            _buildStepTitle("Step 2: Update Status", step2Done),

            DropdownButton<String>(
              value: status,
              items: ["Accepted", "In Progress", "Completed"]
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: step1Done
                  ? (value) {
                      setState(() {
                        status = value!;
                      });
                    }
                  : null,
            ),

            const SizedBox(height: 20),

            // 🔥 STEP 3
            _buildStepTitle("Step 3: Capture Work Proof", step3Done),

            GestureDetector(
              onTap: step2Done
                  ? () async {
                      final img = await captureImage();
                      if (img != null) {
                        await getLocation();
                        setState(() {
                          afterImage = img;
                        });
                      }
                    }
                  : null,
              child: _buildImageBox(afterImage),
            ),

            const SizedBox(height: 10),

            Text(locationText, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 30),

            // 🚀 SUBMIT BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: (step1Done && step2Done && step3Done)
                    ? Colors.green
                    : Colors.grey,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: (step1Done && step2Done && step3Done)
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Work Submitted")),
                      );
                      Navigator.pop(context);
                    }
                  : null,
              child: const Text("Submit Completion"),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Step title with tick
  Widget _buildStepTitle(String title, bool done) {
    return Row(
      children: [
        Icon(done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? Colors.green : Colors.grey),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  // 🔹 Image Box
  Widget _buildImageBox(File? image) {
    return Container(
      height: 150,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: image == null
          ? const Center(
              child: Icon(Icons.camera_alt, size: 40),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(image, fit: BoxFit.cover),
            ),
    );
  }
}