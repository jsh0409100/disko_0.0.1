import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../common/enums/message_enum.dart';
import '../controller/chat_controller.dart';

class SendLocationMapScreen extends ConsumerStatefulWidget {
  final String receiverUid;
  const SendLocationMapScreen({
    Key? key,
    required this.receiverUid,
  }) : super(key: key);

  @override
  ConsumerState<SendLocationMapScreen> createState() =>
      _SendLocationMapScreenState();
}

class _SendLocationMapScreenState extends ConsumerState<SendLocationMapScreen> {
  // late GoogleMapController mapController;
  Completer<GoogleMapController> mapController = Completer();

  final LatLng _center = const LatLng(36.103422, 129.389222);
  final List<Marker> _markers = <Marker>[];
  bool isLocationSelected = false;

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  void sendLocationMessage(
    File file,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.receiverUid,
          MessageEnum.location,
        );
  }

  void updateMarker(LatLng position) {
    print(position);
    _markers.clear();
    _markers.add(Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      markerId: const MarkerId("1"),
      position: position,
      infoWindow: const InfoWindow(
        title: '현재 위치',
        snippet: '주소: ',
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
        body: Column(
          children: [
            Expanded(
              child: GoogleMap(
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                markers: Set<Marker>.of(_markers),
                onMapCreated: (GoogleMapController controller) {
                  mapController.complete(controller);
                },
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 17.0,
                ),
                onTap: updateMarker,
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 14),
              backgroundColor: isLocationSelected
                  ? Theme.of(context).colorScheme.primary
                  : Color(0xFFECECEC), // Background color
            ),
            onPressed: () async {
              final GoogleMapController controller = await mapController.future;
              final imageBytes = await controller.takeSnapshot();
              setState(() {
                // _imageBytes = imageBytes;
              });
            },
            child: Text(
              '이 위치 공유하기',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: isLocationSelected ? Colors.white : Colors.black12,
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          onPressed: () async {
            getUserCurrentLocation().then((value) async {
              print(
                  value.latitude.toString() + " " + value.longitude.toString());
              updateMarker(LatLng(value.latitude, value.longitude));
              // specified current users location
              CameraPosition cameraPosition = CameraPosition(
                target: LatLng(value.latitude, value.longitude),
                zoom: 18,
              );

              final GoogleMapController controller = await mapController.future;
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition));
              setState(() {
                isLocationSelected = true;
              });
            });
          },
          child: const Icon(
            Icons.share_location_outlined,
            color: Colors.black,
            size: 40,
          ),
        ),
      ),
    );
  }
}
