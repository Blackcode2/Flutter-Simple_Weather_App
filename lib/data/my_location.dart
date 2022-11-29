import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Mylocation{
  double lat = 0.0;
  double lon = 0.0;
  late BuildContext context;

  Mylocation({required this.context});
  Future<void> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      await getLocation();
    } else {
      await requestPermission();
    }
  }

  Future<void> requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      await getLocation();
    } else if (permission == LocationPermission.denied) {
      await requestPermission();
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('No permission for location'),
              content: const Text(
                  '\nChange the permission in the App settings for service.'),
              actions: [
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  } //requestPermission()

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    lon = position.longitude;
  }
}