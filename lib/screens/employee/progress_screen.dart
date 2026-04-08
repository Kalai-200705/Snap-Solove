import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProgressScreen extends StatefulWidget {
  final dynamic task;

  const ProgressScreen({super.key, required this.task});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {

  File? beforeImage;
  File? afterImage;

  final ImagePicker picker = ImagePicker();

  // 🔥 OPEN CAMERA
  Future<void> pickImage(bool isBefore) async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() {
        if (isBefore) {
          beforeImage = File(image.path);
        } else {
          afterImage = File(image.path);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image captured")),
      );
    }
  }

  // 🔥 SUBMIT WORK
  void submitWork() async {
    if (beforeImage == null || afterImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload both images")),
      );
      return;
    }

    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm"),
        content: const Text("Submit completed work?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Submit"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Work submitted successfully")),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task.title)),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔥 BEFORE IMAGE
            GestureDetector(
              onTap: () => pickImage(true),
              child: imageBox(beforeImage, "Tap to capture BEFORE image"),
            ),

            const SizedBox(height: 20),

            // 🔥 AFTER IMAGE
            GestureDetector(
              onTap: () => pickImage(false),
              child: imageBox(afterImage, "Tap to capture AFTER image"),
            ),

            const SizedBox(height: 30),

            // 🔥 SUBMIT BUTTON
            ElevatedButton(
              onPressed: submitWork,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Submit Work"),
            )
          ],
        ),
      ),
    );
  }

  // 🔥 IMAGE PREVIEW BOX
  Widget imageBox(File? image, String text) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[300],
      ),
      child: image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(image, fit: BoxFit.cover),
            )
          : Center(child: Text(text)),
    );
  }
}