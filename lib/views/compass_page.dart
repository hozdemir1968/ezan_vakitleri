import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../components/styles.dart';
import '../controllers/geolocator_ctrl.dart';
import '../controllers/compass_ctrl.dart';
import '../models/myposition.dart';

class CompassPage extends StatefulWidget {
  const CompassPage({super.key});

  static const routeName = '/compasspage';

  @override
  State<CompassPage> createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  CompassCtrl compassCtrl = CompassCtrl();
  double heading = 0;
  double pressure = 0;
  final geolocatorCtrl = GeolocatorCtrl();
  MyPosition myPositionM = MyPosition(
    hasPermission: false,
    lat: 0.0,
    lng: 0.0,
    alt: 0.0,
    bearing: 0.0,
  );
  final streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    startSubscriptions();
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in streamSubscriptions) {
      subscription.cancel();
    }
  }

  Future<void> fetchData() async {
    myPositionM = await compassCtrl.getMyPosition();
    setState(() {
      myPositionM.hasPermission ? isLoading = false : isLoading = true;
    });
  }

  void startSubscriptions() async {
    bool hasPermission = await geolocatorCtrl.getLocationPermission();
    if (hasPermission) {
      streamSubscriptions.add(
        magnetometerEventStream(samplingPeriod: Duration(milliseconds: 1000)).listen((
          MagnetometerEvent event,
        ) {
          heading = atan2(event.x, event.y);
          heading = heading * 180 / pi;
          if (heading > 0) {
            heading -= 360;
          }
          setState(() {
            heading = -1 * heading;
          });
        }),
      );
      streamSubscriptions.add(
        barometerEventStream(samplingPeriod: Duration(milliseconds: 1000)).listen((
          BarometerEvent event2,
        ) {
          setState(() {
            pressure = event2.pressure;
          });
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('pusula'.tr), centerTitle: true, elevation: 4),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : hasDataWidget(myPositionM, heading, pressure),
    );
  }

  Widget hasDataWidget(MyPosition model, double heading, double pressure) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('${'enlem'.tr} : ${model.lat.toString()}', style: textStyle20()),
            Text(
              '${'boylam'.tr} : ${' ${model.lng.toString()}'.tr}',
              style: textStyle20(),
            ),
            Text(
              '${'rakim'.tr} : ${model.alt!.toStringAsFixed(1)}'.tr,
              style: textStyle20(),
            ),
            Text(
              '${'basinc'.tr} : ${pressure.toStringAsFixed(1)}'.tr,
              style: textStyle20(),
            ),
            Text(
              '${'kabe_acisi'.tr} : ${model.bearing!.toStringAsFixed(1)}'.tr,
              style: textStyle20(),
            ),
            Text(
              '${'yon_acisi'.tr} : ${(heading).toStringAsFixed(1)}'.tr,
              style: textStyle20(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: const Divider(),
            ),
            Center(
              child: Transform.rotate(
                angle: -1 * (pi / 180) * heading,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset('assets/images/compass.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
