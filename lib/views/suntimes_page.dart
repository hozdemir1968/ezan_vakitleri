import 'package:ezan_vakitleri/controllers/suntime_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/styles.dart';
import '../controllers/geolocator_ctrl.dart';
import '../models/sunriseset_v_m.dart';

class SuntimesPage extends StatefulWidget {
  const SuntimesPage({super.key});

  static const routeName = '/suntimepages';

  @override
  State<SuntimesPage> createState() => _SuntimesPageState();
}

class _SuntimesPageState extends State<SuntimesPage> {
  final geolocatorCtrl = GeolocatorCtrl();
  final suntimeCtrl = SuntimeCtrl();
  SunrisesetVM sunrisesetVM = SunrisesetVM();
  bool hasLocationPermission = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    hasLocationPermission = await geolocatorCtrl.getLocationPermission();
    if (hasLocationPermission) {
      sunrisesetVM = await suntimeCtrl.getSunriseSunset();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('gunes_dogus_batis'.tr),
        centerTitle: true,
        elevation: 4,
      ),
      body: RefreshIndicator(
        onRefresh: () => fetchData(),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : hasLocationPermission
                ? hasDataWidget(sunrisesetVM)
                : noDataWidget(),
      ),
    );
  }

  Widget hasDataWidget(SunrisesetVM model) {
    List<String> vakitler = [
      'alaca_bas'.tr,
      'gunes_dogus'.tr,
      'gun_ortasi'.tr,
      'gunes_batis'.tr,
      'alaca_bit'.tr,
      'gun_uzunluk'.tr,
    ];
    final duration = Duration(seconds: model.dayLength!);
    final zero = DateTime(2020, 01, 01, 0, 0, 0);
    final dateTime = zero.add(duration);
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat.yMMMMEEEEd('tr').format(model.date!),
                style: textStyle18B(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${'enlem'.tr} : ${model.lat}', style: textStyle18B()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${'boylam'.tr} : ${model.lng}', style: textStyle18B()),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: const Divider(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(vakitler[0], style: textStyle18()),
                  Text(
                    DateFormat('Hm').format(model.suntimes![0].toLocal()),
                    style: textStyle18B(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(vakitler[1], style: textStyle18()),
                  Text(
                    DateFormat('Hm').format(model.suntimes![1].toLocal()),
                    style: textStyle18B(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(vakitler[2], style: textStyle18()),
                  Text(
                    DateFormat('Hm').format(model.suntimes![2].toLocal()),
                    style: textStyle18B(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(vakitler[3], style: textStyle18()),
                  Text(
                    DateFormat('Hm').format(model.suntimes![3].toLocal()),
                    style: textStyle18B(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(vakitler[4], style: textStyle18()),
                  Text(
                    DateFormat('Hm').format(model.suntimes![4].toLocal()),
                    style: textStyle18B(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(vakitler[5], style: textStyle18()),
                  Text(DateFormat('Hm').format(dateTime), style: textStyle18B()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Data from : "),
                  InkWell(
                    onTap: () => launchUrl(Uri.parse('https://sunrise-sunset.org/')),
                    child: Text("https://sunrise-sunset.org/", style: textStyle16B()),
                  ),
                ],
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
