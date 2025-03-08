import 'package:geolocator/geolocator.dart';
import '../models/myposition.dart';

class GeolocatorCtrl {
  MyPosition myPositionM = MyPosition(
    hasPermission: false,
    lat: 0,
    lng: 0,
    alt: 0,
    bearing: 0,
  );
  double mekkeLat = 21.422505;
  double mekkeLng = 39.826180;

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
    myPositionM.hasPermission = true;
    myPositionM.lat = position.latitude;
    myPositionM.lng = position.longitude;
    myPositionM.alt = position.altitude;
    myPositionM.bearing = bearing;
    return myPositionM;
  }

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
    }
    hasPermission = true;
    return hasPermission;
  }
}
