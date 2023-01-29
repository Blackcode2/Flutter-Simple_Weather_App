import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';



class Mylocation{
  double lat = 0.0;
  double lon = 0.0;
  //late LocationSettings locationSettings;
  late BuildContext context; // for dialog
  // final streamController = StreamController<Stream>();

  Mylocation({required this.context});

  // Stream get positionStream => streamController.stream;
  // streamController.add(Geolocator.getPositionStream(locationSettings: locationSettings));

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

  //update latter
  // void updateLocationSetting() {
  //   if (defaultTargetPlatform == TargetPlatform.android) {
  //     locationSettings = AndroidSettings(
  //         accuracy: LocationAccuracy.high,
  //         distanceFilter: 100,
  //         forceLocationManager: true,
  //         intervalDuration: const Duration(seconds: 100),
  //         //(Optional) Set foreground notification config to keep the app alive
  //         //when going to the background
  //         foregroundNotificationConfig: const ForegroundNotificationConfig(
  //           notificationText:
  //           "This app will continue to receive your location even when you aren't using it",
  //           notificationTitle: "Running in Background",
  //           enableWakeLock: true,
  //         )
  //     );
  //   } else if (defaultTargetPlatform == TargetPlatform.iOS ||
  //       defaultTargetPlatform == TargetPlatform.macOS) {
  //     locationSettings = AppleSettings(
  //       accuracy: LocationAccuracy.high,
  //       activityType: ActivityType.fitness,
  //       distanceFilter: 100,
  //       pauseLocationUpdatesAutomatically: true,
  //       // Only set to true if our app will be started up in the background.
  //       showBackgroundLocationIndicator: false,
  //     );
  //   } else {
  //     locationSettings = const LocationSettings(
  //       accuracy: LocationAccuracy.high,
  //       distanceFilter: 100,
  //     );
  //   }
  //   // streamController.add(Geolocator.getPositionStream(locationSettings: locationSettings));
  // }

    // StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
    //         (Position? position) {
    //           if(position != null) {
    //             lat = position.latitude;
    //             lon = position.longitude;
    //
    //           }
    //     });

}