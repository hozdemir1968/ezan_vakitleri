import 'package:geolocator/geolocator.dart';
import '../models/myposition.dart';

class GeolocatorCtrl {
  double mekkeLat = 21.422505;
  double mekkeLng = 39.826180;

  Future<bool> getLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    bool hasPermission = false;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      hasPermission = false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        hasPermission = false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      hasPermission = false;
    } else {
      hasPermission = true;
    }
    return hasPermission;
  }

  Future<MyPosition> getPosition() async {
    Position position;
    double bearing = 0;
    position = await Geolocator.getCurrentPosition();
    bearing = Geolocator.bearingBetween(
      position.latitude,
      position.longitude,
      mekkeLat,
      mekkeLng,
    );
    MyPosition myPosition = MyPosition(
      lat: position.latitude,
      lng: position.longitude,
      alt: position.altitude,
      bearing: bearing,
    );
    return myPosition;
  }
}
