import 'dart:async';
import 'package:ezan_vakitleri/models/prayertime.dart';
import 'package:ezan_vakitleri/models/time_model.dart';
import 'package:ezan_vakitleri/services/db_services.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../components/drawer_menu.dart';
import '../components/label_label_time.dart';
import '../components/label_remaining_time.dart';
import '../services/api_services.dart';
import '../services/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final box = GetStorage();
  final apiServices = ApiServices();
  final dbServices = DbServices();
  final services = Services();
  final timeModelStr = TimeModelStr();
  final timeModelInt = TimeModelInt();
  Timer? timer;
  List<Prayertime> prayertimeList = [];
  int todayIndex = 0;
  int townId = 0;
  String townName = '';
  String savedDay = '';
  List<bool> isVisible = [false, false, false, false, false, false];
  String remainingTime = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (box.read('townId') != null) {
      townId = box.read('townId');
    }
    if (box.read('townName') != null) {
      townName = box.read('townName');
    }
    if (box.read('savedDay') != null) {
      savedDay = box.read('savedDay');
      if (savedDay == DateTime.now().toString().substring(0, 10)) {
        getLocalData();
      } else {
        getApiData();
      }
    } else {
      getApiData();
    }
    initTimer();
  }

  void getApiData() async {
    setState(() {
      isLoading = true;
    });
    prayertimeList = await apiServices.getPrayerTimes(townId);
    await services.saveLocalData(prayertimeList);
    box.write('savedDay', DateTime.now().toString().substring(0, 10));
    findTodayIndex();
    setTimeModel();
    findRemainingTime();
    setState(() {
      isLoading = false;
    });
  }

  void getLocalData() async {
    setState(() {
      isLoading = true;
    });
    prayertimeList = await services.getLocalData();
    findTodayIndex();
    setTimeModel();
    findRemainingTime();
    setState(() {
      isLoading = false;
    });
  }

  void setTimeModel() {
    timeModelStr.time0 = prayertimeList[todayIndex].fajr.toString();
    timeModelStr.time1 = prayertimeList[todayIndex].sunrise.toString();
    timeModelStr.time2 = prayertimeList[todayIndex].dhuhr.toString();
    timeModelStr.time3 = prayertimeList[todayIndex].asr.toString();
    timeModelStr.time4 = prayertimeList[todayIndex].maghrib.toString();
    timeModelStr.time5 = prayertimeList[todayIndex].isha.toString();
    timeModelInt.time0 = int.parse(timeModelStr.time0!.substring(0, 2)) * 60 +
        int.parse(timeModelStr.time0!.substring(3, 5));
    timeModelInt.time1 = int.parse(timeModelStr.time1!.substring(0, 2)) * 60 +
        int.parse(timeModelStr.time1!.substring(3, 5));
    timeModelInt.time2 = int.parse(timeModelStr.time2!.substring(0, 2)) * 60 +
        int.parse(timeModelStr.time2!.substring(3, 5));
    timeModelInt.time3 = int.parse(timeModelStr.time3!.substring(0, 2)) * 60 +
        int.parse(timeModelStr.time3!.substring(3, 5));
    timeModelInt.time4 = int.parse(timeModelStr.time4!.substring(0, 2)) * 60 +
        int.parse(timeModelStr.time4!.substring(3, 5));
    timeModelInt.time5 = int.parse(timeModelStr.time5!.substring(0, 2)) * 60 +
        int.parse(timeModelStr.time5!.substring(3, 5));
  }

  void initTimer() {
    if (timer != null && timer!.isActive) return;
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      checkToday();
      findTodayIndex();
      findRemainingTime();
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void checkToday() {
    savedDay = box.read('savedDay');
    if (savedDay != DateTime.now().toString().substring(0, 10)) {
      getApiData();
    }
  }

  void findTodayIndex() {
    bool isDayIndex = true;
    String dt1 = DateTime.now().toString().substring(0, 10);
    String dt2 = '';
    todayIndex = 0;
    do {
      dt2 =
          prayertimeList[todayIndex].gregorianDateLongIso8601.toString().substring(0, 10);
      if (dt1 != dt2) {
        todayIndex++;
      } else {
        isDayIndex = false;
      }
    } while (isDayIndex);
  }

  void findRemainingTime() {
    String timeNowStr = DateTime.now().toString().substring(11, 16);
    int timeNowInt = int.parse(timeNowStr.substring(0, 2)) * 60 +
        int.parse(timeNowStr.substring(3, 5));

    if (timeNowInt > timeModelInt.time5! || timeNowInt < timeModelInt.time0!) {
      isVisible = [true, false, false, false, false, false];
      if (timeNowInt > timeModelInt.time5!) {
        remainingTime =
            services.calcHoursMinutes((1440 - timeNowInt) + timeModelInt.time0!);
      } else {
        remainingTime = services.calcHoursMinutes(timeModelInt.time0! - timeNowInt);
      }
    }
    if (timeNowInt > timeModelInt.time0! && timeNowInt < timeModelInt.time1!) {
      isVisible = [false, true, false, false, false, false];
      remainingTime = services.calcHoursMinutes(timeModelInt.time1! - timeNowInt);
    }
    if (timeNowInt > timeModelInt.time1! && timeNowInt < timeModelInt.time2!) {
      isVisible = [false, false, true, false, false, false];
      remainingTime = services.calcHoursMinutes(timeModelInt.time2! - timeNowInt);
    }
    if (timeNowInt > timeModelInt.time2! && timeNowInt < timeModelInt.time3!) {
      isVisible = [false, false, false, true, false, false];
      remainingTime = services.calcHoursMinutes(timeModelInt.time3! - timeNowInt);
    }
    if (timeNowInt > timeModelInt.time3! && timeNowInt < timeModelInt.time4!) {
      isVisible = [false, false, false, false, true, false];
      remainingTime = services.calcHoursMinutes(timeModelInt.time4! - timeNowInt);
    }
    if (timeNowInt > timeModelInt.time4! && timeNowInt < timeModelInt.time5!) {
      isVisible = [false, false, false, false, false, true];
      remainingTime = services.calcHoursMinutes(timeModelInt.time5! - timeNowInt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ezan Vakitleri'),
      ),
      drawer: const DrawerMenu(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(townName, style: const TextStyle(fontSize: 18)),
                        Text(prayertimeList[todayIndex].gregorianDateLong.toString(),
                            style: const TextStyle(fontSize: 18)),
                        Text(prayertimeList[todayIndex].hijriDateLong.toString(),
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        LabelRemainingTime(
                            isVisible: isVisible[0],
                            label: 'İmsaka kalan ',
                            remainingTime: remainingTime),
                        LabelLabelTime(
                          label: 'İMSAK :',
                          time: prayertimeList[todayIndex].fajr,
                        ),
                        LabelRemainingTime(
                            isVisible: isVisible[1],
                            label: 'Güneşe kalan ',
                            remainingTime: remainingTime),
                        LabelLabelTime(
                          label: 'GÜNEŞ :',
                          time: prayertimeList[todayIndex].sunrise,
                        ),
                        LabelRemainingTime(
                            isVisible: isVisible[2],
                            label: 'Öğlene kalan ',
                            remainingTime: remainingTime),
                        LabelLabelTime(
                          label: 'ÖĞLEN :',
                          time: prayertimeList[todayIndex].dhuhr,
                        ),
                        LabelRemainingTime(
                            isVisible: isVisible[3],
                            label: 'İkindine kalan ',
                            remainingTime: remainingTime),
                        LabelLabelTime(
                          label: 'İKİNDİ :',
                          time: prayertimeList[todayIndex].asr,
                        ),
                        LabelRemainingTime(
                            isVisible: isVisible[4],
                            label: 'Akşama kalan ',
                            remainingTime: remainingTime),
                        LabelLabelTime(
                          label: 'AKŞAM :',
                          time: prayertimeList[todayIndex].maghrib,
                        ),
                        LabelRemainingTime(
                            isVisible: isVisible[5],
                            label: 'Yatsıya kalan ',
                            remainingTime: remainingTime),
                        LabelLabelTime(
                          label: 'YATSI :',
                          time: prayertimeList[todayIndex].isha,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
