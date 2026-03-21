import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {

  bool showEmployees = true;

  final LatLng center = const LatLng(11.2, 79.7);

  Set<Marker> markers = {};

  // 🔴 Dummy Issue Data
  final List<Map<String, dynamic>> issues = [
    {"title": "Garbage", "lat": 11.21, "lng": 79.71},
    {"title": "Water Leak", "lat": 11.22, "lng": 79.72},
  ];

  // 🔵 Dummy Employee Data
  final List<Map<String, dynamic>> employees = [
    {"name": "Emp 1", "lat": 11.23, "lng": 79.73},
    {"name": "Emp 2", "lat": 11.24, "lng": 79.74},
  ];

  @override
  void initState() {
    super.initState();
    updateMarkers();
  }

  // 🔴 ISSUE MARKERS
  Set<Marker> getIssueMarkers() {
    return issues.map((issue) {
      return Marker(
        markerId: MarkerId(issue["title"]),
        position: LatLng(issue["lat"], issue["lng"]),
        infoWindow: InfoWindow(title: issue["title"]),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    }).toSet();
  }

  // 🔵 EMPLOYEE MARKERS
  Set<Marker> getEmployeeMarkers() {
    return employees.map((emp) {
      return Marker(
        markerId: MarkerId(emp["name"]),
        position: LatLng(emp["lat"], emp["lng"]),
        infoWindow: InfoWindow(title: emp["name"]),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
    }).toSet();
  }

  // 🔄 UPDATE MARKERS
  void updateMarkers() {
    Set<Marker> newMarkers = {};

    newMarkers.addAll(getIssueMarkers());

    if (showEmployees) {
      newMarkers.addAll(getEmployeeMarkers());
    }

    setState(() {
      markers = newMarkers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map View"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [

          // 🔘 TOGGLE
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Show Employee Locations"),
                Switch(
                  value: showEmployees,
                  onChanged: (value) {
                    setState(() {
                      showEmployees = value;
                      updateMarkers();
                    });
                  },
                ),
              ],
            ),
          ),

          // 🗺 MAP
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: center,
                zoom: 14,
              ),
              markers: markers,
            ),
          ),
        ],
      ),
    );
  }
}