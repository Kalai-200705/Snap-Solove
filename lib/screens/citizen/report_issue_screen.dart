import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();

  File? image;

  // 📍 Location
  bool useLiveLocation = true;
  String locationText = "Location not captured";
  final TextEditingController manualLocationController =
      TextEditingController();

  // 🎤 Speech
  final SpeechToText speech = SpeechToText();
  bool isListening = false;

  // 📝 Description
  final TextEditingController descriptionController = TextEditingController();

  // 📂 Category
  String selectedCategory = "Garbage Overflow";
  final List<String> categories = [
    "Garbage Overflow",
    "Broken Streetlight",
    "Drainage Problems"
  ];

  // 📷 Capture Image + Location
  Future<void> captureImageAndLocation() async {
    final prefs = await SharedPreferences.getInstance();
    bool dataSaver = prefs.getBool('dataSaver') ?? false;

    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: dataSaver ? 40 : 90,
    );

    if (pickedFile == null) return;

    setState(() {
      image = File(pickedFile.path);
    });

    if (useLiveLocation) {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => locationText = "Location permission denied");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        locationText = "Lat: ${position.latitude}, Lng: ${position.longitude}";
      });
    }
  }

  // 🎤 Mic Toggle
  void toggleRecording() async {
    if (!isListening) {
      bool available = await speech.initialize();

      if (available) {
        setState(() => isListening = true);

        speech.listen(onResult: (result) {
          setState(() {
            descriptionController.text = result.recognizedWords;
          });
        });
      }
    } else {
      speech.stop();
      setState(() => isListening = false);
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    manualLocationController.dispose();
    super.dispose();
  }

  void submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Capture image")),
      );
      return;
    }

    // 🔥 DATA SAVER VALUE
    final prefs = await SharedPreferences.getInstance();
    bool dataSaver = prefs.getBool('dataSaver') ?? false;

    // 🔊 SOUND VALUE
    bool soundOn = prefs.getBool('sound') ?? true;

    // 📳 VIBRATION VALUE
    bool vibrationOn = prefs.getBool('vibration') ?? true;

    // 🔊 SOUND
    if (soundOn) {
      final player = AudioPlayer();
      await player.play(AssetSource('sounds/notify.mp3'));
    }

    // 📳 VIBRATION
    if (vibrationOn) {
      if (await Vibration.hasVibrator() == true) {
        Vibration.vibrate(duration: 200);
      }
    }

    // 🔥 (Future API use)
    print("Data Saver Mode: $dataSaver");

    // ✅ FINAL MESSAGE (LAST)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          dataSaver
              ? "Issue Submitted (Low Data Mode)"
              : "Issue Submitted (Normal Mode)",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Issue"),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📷 Image
              Center(
                child: AnimatedCaptureBox(
                  image: image,
                  onTap: captureImageAndLocation,
                ),
              ),

              const SizedBox(height: 15),

              // 📍 Location Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Use Live Location"),
                  Switch(
                    value: useLiveLocation,
                    onChanged: (val) {
                      setState(() {
                        useLiveLocation = val;
                      });
                    },
                  )
                ],
              ),

              const SizedBox(height: 10),

              // 📍 Location Display / Manual
              useLiveLocation
                  ? Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            locationText,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    )
                  : TextFormField(
                      controller: manualLocationController,
                      validator: (value) =>
                          value!.isEmpty ? "Enter location" : null,
                      decoration: InputDecoration(
                        labelText: "Enter Location",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),

              const SizedBox(height: 20),

              // 📂 Category
              const Text("Category",
                  style: TextStyle(fontWeight: FontWeight.bold)),

              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                items: categories
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),

              const SizedBox(height: 20),

              // 📝 Description + 🎤
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                validator: (value) =>
                    value!.isEmpty ? "Enter description" : null,
                decoration: InputDecoration(
                  hintText: "Description",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color: isListening ? Colors.red : Colors.grey,
                    ),
                    onPressed: toggleRecording,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 🚀 Submit
              AnimatedSubmitButton(onPressed: submit),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedCaptureBox extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;

  const AnimatedCaptureBox({
    super.key,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: image == null
              ? const LinearGradient(
                  colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                )
              : null,
        ),
        child: image == null
            ? const Center(
                child: Text("Tap to Capture Image"),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(image!, fit: BoxFit.cover),
              ),
      ),
    );
  }
}

class AnimatedSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AnimatedSubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Submit Issue",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
