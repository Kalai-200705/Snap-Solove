import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class CitizenReportIssueScreen extends StatefulWidget {
  const CitizenReportIssueScreen({super.key});

  @override
  State<CitizenReportIssueScreen> createState() =>
      _CitizenReportIssueScreenState();
}

class _CitizenReportIssueScreenState extends State<CitizenReportIssueScreen> {
  int currentStep = 1;

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final addressController = TextEditingController(); // 🔥 NEW

  String? selectedCategory;
  Position? location;

  File? imageFile;
  final picker = ImagePicker();

  final steps = ["Image", "Title", "Desc", "Category", "Location"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Report Issue"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildStepper(),
            const SizedBox(height: 25),
            if (currentStep >= 1) _imageStep(),
            if (currentStep >= 2) _titleStep(),
            if (currentStep >= 3) _descStep(),
            if (currentStep >= 4) _categoryStep(),
            if (currentStep >= 5) _locationStep(),
            const SizedBox(height: 30),
            if (_isReady())
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Submit Report"),
              )
          ],
        ),
      ),
    );
  }

  // 🔥 STEPPER (UNCHANGED)
  Widget _buildStepper() {
    return Column(
      children: [
        Row(
          children: List.generate(steps.length, (index) {
            int step = index + 1;

            return Expanded(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor:
                        currentStep >= step ? Colors.blue : Colors.grey[300],
                    child: currentStep > step
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : Text("$step"),
                  ),
                  const SizedBox(height: 4),
                  Text(steps[index], style: const TextStyle(fontSize: 10))
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: currentStep / steps.length,
          minHeight: 6,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }

  // 🔥 IMAGE STEP (CAPTURE LOCATION ALSO)
  Widget _imageStep() {
    return _card(
      "Upload Image",
      onTap: _pickImage,
      child: imageFile == null
          ? Column(
              children: const [
                Icon(Icons.camera_alt, size: 40),
                SizedBox(height: 10),
                Text("Tap to capture image"),
              ],
            )
          : Column(
              children: [
                Image.file(imageFile!, height: 120),
                const SizedBox(height: 8),
                const Text("Image + Location Captured"),
              ],
            ),
    );
  }

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      // 🔥 Capture location immediately
      Position pos = await Geolocator.getCurrentPosition();
      location = pos;

      // 🔥 Convert to address
      List<geocoding.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      geocoding.Placemark place = placemarks.first;

      String address =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

      setState(() {
        imageFile = File(picked.path);
        addressController.text = address;
        currentStep = 2;
      });
    }
  }

  // 🔹 TITLE
  Widget _titleStep() {
    return _inputCard(
      "Title",
      controller: titleController,
      onChanged: (v) {
        if (v.isNotEmpty && currentStep == 2) {
          setState(() => currentStep = 3);
        }
      },
    );
  }

  // 🔹 DESC
  Widget _descStep() {
    return _inputCard(
      "Description",
      controller: descController,
      maxLines: 3,
      onChanged: (v) {
        if (v.isNotEmpty && currentStep == 3) {
          setState(() => currentStep = 4);
        }
      },
    );
  }

  // 🔹 CATEGORY
  Widget _categoryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title("Category"),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: [
            _chip("Road"),
            _chip("Water"),
            _chip("Electricity"),
            _chip("Garbage"),
          ],
        ),
      ],
    );
  }

  Widget _chip(String name) {
    return ChoiceChip(
      label: Text(name),
      selected: selectedCategory == name,
      onSelected: (val) {
        setState(() {
          selectedCategory = name;
          currentStep = 5;
        });
      },
    );
  }

  // 🔥 LOCATION STEP (WITH ADDRESS FIELD)
  Widget _locationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title("Location"),
        const SizedBox(height: 10),
        Container(
          height: 200,
          child: (location == null)
              ? const Center(
                  child: Text("Click below to load location"),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        location!.latitude,
                        location!.longitude,
                      ),
                      zoom: 16,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("issue"),
                        position: LatLng(
                          location!.latitude,
                          location!.longitude,
                        ),
                      )
                    },
                  ),
                ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () async {
            try {
              await _getLocation();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Location not available"),
                ),
              );
            }
          },
          icon: const Icon(Icons.my_location),
          label: const Text("Use Current Location"),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: addressController,
          decoration: InputDecoration(
            labelText: "Address",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      Position pos = await Geolocator.getCurrentPosition();

      List<geocoding.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      geocoding.Placemark place = placemarks.first;

      String address = "${place.street}, ${place.locality}, ${place.country}";

      setState(() {
        location = pos;
        addressController.text = address;
      });
    } catch (e) {
      debugPrint("Location error: $e");
    }
  }

  // 🔹 HELPERS
  Widget _card(String title,
      {required Widget child, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(title),
        const SizedBox(height: 10),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: child),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _inputCard(String title,
      {required TextEditingController controller,
      int maxLines = 1,
      required Function(String) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(title),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: "Enter $title",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _title(String text) {
    return Text(text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600));
  }

  bool _isReady() {
    return imageFile != null &&
        titleController.text.isNotEmpty &&
        descController.text.isNotEmpty &&
        selectedCategory != null &&
        location != null &&
        addressController.text.isNotEmpty;
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Your issue was submitted successfully"),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }
}
