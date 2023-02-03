import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class SendLocationMapScreen extends StatefulWidget {
  const SendLocationMapScreen({super.key});

  @override
  State<SendLocationMapScreen> createState() => _SendLocationMapScreenState();
}

class _SendLocationMapScreenState extends State<SendLocationMapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(36.103422, 129.389222);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _currentLocation() async {
    // Create a map controller
    LocationData? currentLocation;
    var location = Location();
    try {
      // Find and store your location in a variable
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    // Move the map camera to the found location using the controller
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation!.latitude!, currentLocation.longitude!),
        zoom: 17.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: const Text(
            '위치 공유하기',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: GoogleMap(
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 17.0,
          ),
        ),
      ),
    );
  }
}
