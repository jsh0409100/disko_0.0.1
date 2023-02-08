import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';

class LocationItem extends StatelessWidget {
  final String locationImageString;
  final Timestamp timeSent;
  final Coords coordinates;
  const LocationItem({
    Key? key,
    // required this.locationUrl,
    required this.locationImageString,
    required this.timeSent,
    required this.coordinates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<int> codeUnits = locationImageString.codeUnits;
    final Uint8List imageBytes = Uint8List.fromList(codeUnits);
    final DateTime date = timeSent.toDate();
    final timeFormat = DateFormat('aa hh:mm', 'ko');
    final showTime = timeFormat.format(date);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(showTime),
        Container(
          margin: const EdgeInsets.only(top: 15, right: 15, left: 10),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  border: Border.all(
                    width: 1,
                    color: const Color(0xFFECECEC),
                    style: BorderStyle.solid,
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.64,
                height: 200,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.memory(
                    imageBytes,
                    scale: 1,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(15),
                  ),
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width * 0.64,
                height: 54,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    color: Color(0xFFECECEC),
                  ),
                  margin: const EdgeInsets.all(9),
                  width: MediaQuery.of(context).size.width * 0.60,
                  height: 36,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () async {
                      final availableMaps = await MapLauncher.installedMaps;
                      await availableMaps.first.showMarker(
                        coords: coordinates,
                        title: "약속 장소",
                        zoom: 18,
                      );
                    },
                    child: const Text(
                      "장소 보기",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
