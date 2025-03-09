import '../models/myposition.dart';
import '../models/sunriseset_v_m.dart';
import '../models/sunriseset_m.dart';
import '../services/api_service.dart';
import 'geolocator_ctrl.dart';

class SuntimeCtrl {
  final apiService = ApiService();
  final geolocatorCtrl = GeolocatorCtrl();
  SunrisesetM sunriseSunsetM = SunrisesetM();
  SunrisesetVM sunriseSunsetVM = SunrisesetVM(
    lat: "0",
    lng: "0",
    date: DateTime.now(),
    formatted: "0",
    dayLength: 0,
    suntimes: [
      DateTime.now(),
      DateTime.now(),
      DateTime.now(),
      DateTime.now(),
      DateTime.now(),
    ],
  );

  Future<SunrisesetVM> getSunriseSunset() async {
    MyPosition myPosition = await geolocatorCtrl.getPosition();
    if (myPosition.lat != 0 && myPosition.lng != 0) {
      sunriseSunsetVM.lat = myPosition.lat.toString();
      sunriseSunsetVM.lng = myPosition.lng.toString();
      sunriseSunsetVM.date = DateTime.now();
      sunriseSunsetVM.formatted = "0";
      sunriseSunsetM = await apiService.getSunriseSunset(sunriseSunsetVM);
      sunriseSunsetVM.suntimes = [
        DateTime.parse(sunriseSunsetM.results!.astronomicalTwilightBegin!),
        DateTime.parse(sunriseSunsetM.results!.sunrise!),
        DateTime.parse(sunriseSunsetM.results!.solarNoon!),
        DateTime.parse(sunriseSunsetM.results!.sunset!),
        DateTime.parse(sunriseSunsetM.results!.astronomicalTwilightEnd!),
      ];
      sunriseSunsetVM.dayLength = sunriseSunsetM.results!.dayLength;
    }
    return sunriseSunsetVM;
  }
}
