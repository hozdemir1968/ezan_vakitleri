import 'geolocator_ctrl.dart';
import '../models/myposition.dart';

class CompassCtrl {
  final geolocatorCtrl = GeolocatorCtrl();
  MyPosition myPositionM = MyPosition(
    hasPermission: false,
    lat: 0,
    lng: 0,
    alt: 0,
    bearing: 0,
  );

  Future<MyPosition> getMyPosition() async {
    myPositionM.hasPermission = await geolocatorCtrl.getLocationPermission();
    if (myPositionM.hasPermission) {
      myPositionM = await geolocatorCtrl.getPosition();
    }
    return myPositionM;
  }
}
