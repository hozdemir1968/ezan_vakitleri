import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../components/styles.dart';
import '../controllers/geolocator_ctrl.dart';
import '../models/myposition.dart';

class CompassPage extends StatefulWidget {
  const CompassPage({super.key});

  static const routeName = '/compasspage';

  @override
  State<CompassPage> createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  final geolocatorCtrl = GeolocatorCtrl();
  double heading = 0;
  double pressure = 0;
  bool hasLocationPermission = false;
  MyPosition myPosition = MyPosition(lat: 0.0, lng: 0.0, alt: 0.0, bearing: 0.0);
  final streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in streamSubscriptions) {
      subscription.cancel();
    }
  }

  Future<void> getPosition() async {
    hasLocationPermission = await geolocatorCtrl.getLocationPermission();
    if (hasLocationPermission) {
      myPosition = await geolocatorCtrl.getPosition();
      startSubscriptions();
    }
    setState(() {
      isLoading = false;
    });
  }

  void startSubscriptions() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('pusula'.tr), centerTitle: true, elevation: 4),
      body: RefreshIndicator(
        onRefresh: () => getPosition(),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : hasLocationPermission
                ? hasDataWidget(myPosition, heading, pressure)
                : noDataWidget(),
      ),
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

  Widget noDataWidget() {
    return Center(child: Text('Konum Erişimi Kapalı'));
  }
}
