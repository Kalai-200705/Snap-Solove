import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;

  // 📍 Fixed Issue Location (Chennai)
  final LatLng issueLocation = const LatLng(13.0827, 80.2707);

  // 🟢 Employee starting position
  LatLng employeeLocation = const LatLng(13.0674, 80.2376);

  Timer? timer;

  @override
  void initState() {
    super.initState();
    startFakeTracking();
  }

  void startFakeTracking() {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        // 👇 little movement simulation
        employeeLocation = LatLng(
          employeeLocation.latitude + 0.0005,
          employeeLocation.longitude + 0.0005,
        );
      });

      mapController?.animateCamera(
        CameraUpdate.newLatLng(employeeLocation),
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Track Issue")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: issueLocation,
          zoom: 13,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },

        // ❌ remove blue dot
        myLocationEnabled: false,

        markers: {
          // 🔴 Issue marker
          Marker(
            markerId: const MarkerId("issue"),
            position: issueLocation,
          ),

          // 🟢 Employee moving marker
          Marker(
            markerId: const MarkerId("employee"),
            position: employeeLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        },
      ),
    );
  }
}