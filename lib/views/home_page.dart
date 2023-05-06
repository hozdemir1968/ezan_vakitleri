import 'dart:async';
import 'package:ezan_vakitleri/models/prayertime.dart';
import 'package:ezan_vakitleri/services/db_services.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../components/drawer_menu.dart';
import '../components/time_label_widget.dart';
import '../components/top_label_widget.dart';
import '../components/remaining_time_label_widget.dart';
import '../services/api_services.dart';
import '../services/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final box = GetStorage();
  var apiServices = ApiServices();
  var dbServices = DbServices();
  var services = Services();
  Timer? timer;
  List<PrayerTime> prayertimeList = [];
  String savedDay = '';
  int todayIndex = 0;
  int townId = 0;
  String townName = '';
  List<bool> isVisible = [false, false, false, false, false, false];
  String remaining = '';
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
    box.write('savedDay', DateTime.now().toString().substring(0, 10));
    prayertimeList = await apiServices.getPrayerTimes(townId);
    await services.saveLocalData(prayertimeList);
    findTodayIndex();
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
    findRemainingTime();
    setState(() {
      isLoading = false;
    });
  }

  void initTimer() {
    if (timer != null && timer!.isActive) return;
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
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

  void findTodayIndex() {
    bool isDayIndex = false;
    String dt1 = DateTime.now().toString().substring(0, 10);
    String dt2 = '';
    todayIndex = 0;
    do {
      dt2 =
          prayertimeList[todayIndex].gregorianDateLongIso8601.toString().substring(0, 10);
      if (dt1 != dt2) {
        todayIndex++;
      } else {
        isDayIndex = true;
      }
    } while (isDayIndex);
  }

  void findRemainingTime() {
    String timeNow = DateTime.now().toString().substring(11, 16);
    String time0 = prayertimeList[todayIndex].fajr.toString();
    String time1 = prayertimeList[todayIndex].sunrise.toString();
    String time2 = prayertimeList[todayIndex].dhuhr.toString();
    String time3 = prayertimeList[todayIndex].asr.toString();
    String time4 = prayertimeList[todayIndex].maghrib.toString();
    String time5 = prayertimeList[todayIndex].isha.toString();
    int timeNowInt =
        int.parse(timeNow.substring(0, 2)) * 60 + int.parse(timeNow.substring(3, 5));
    int time0Int =
        int.parse(time0.substring(0, 2)) * 60 + int.parse(time0.substring(3, 5));
    int time1Int =
        int.parse(time1.substring(0, 2)) * 60 + int.parse(time1.substring(3, 5));
    int time2Int =
        int.parse(time2.substring(0, 2)) * 60 + int.parse(time2.substring(3, 5));
    int time3Int =
        int.parse(time3.substring(0, 2)) * 60 + int.parse(time3.substring(3, 5));
    int time4Int =
        int.parse(time4.substring(0, 2)) * 60 + int.parse(time4.substring(3, 5));
    int time5Int =
        int.parse(time5.substring(0, 2)) * 60 + int.parse(time5.substring(3, 5));
    if (timeNowInt > time5Int || timeNowInt < time0Int) {
      isVisible = [true, false, false, false, false, false];
      if (timeNowInt > time5Int) {
        remaining = services.calcHoursMinutes((1440 - timeNowInt) + time0Int);
      } else {
        remaining = services.calcHoursMinutes(time0Int - timeNowInt);
      }
    }
    if (timeNowInt > time0Int && timeNowInt < time1Int) {
      isVisible = [false, true, false, false, false, false];
      remaining = services.calcHoursMinutes(time1Int - timeNowInt);
    }
    if (timeNowInt > time1Int && timeNowInt < time2Int) {
      isVisible = [false, false, true, false, false, false];
      remaining = services.calcHoursMinutes(time2Int - timeNowInt);
    }
    if (timeNowInt > time2Int && timeNowInt < time3Int) {
      isVisible = [false, false, false, true, false, false];
      remaining = services.calcHoursMinutes(time3Int - timeNowInt);
    }
    if (timeNowInt > time3Int && timeNowInt < time4Int) {
      isVisible = [false, false, false, false, true, false];
      remaining = services.calcHoursMinutes(time4Int - timeNowInt);
    }
    if (timeNowInt > time4Int && timeNowInt < time5Int) {
      isVisible = [false, false, false, false, false, true];
      remaining = services.calcHoursMinutes(time5Int - timeNowInt);
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
                      children: [
                        TopLabel(data: townName),
                        TopLabel(data: prayertimeList[todayIndex].gregorianDateLong),
                        TopLabel(data: prayertimeList[todayIndex].hijriDateLong),
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
                        RemainingTimeLabel(
                            isVisible: isVisible[0],
                            label: 'İmsaka kalan ',
                            remainingTime: remaining),
                        TimeLabel(
                            label: 'İMSAK :', time: prayertimeList[todayIndex].fajr),
                        RemainingTimeLabel(
                            isVisible: isVisible[1],
                            label: 'Güneşe kalan ',
                            remainingTime: remaining),
                        TimeLabel(
                            label: 'GÜNEŞ :', time: prayertimeList[todayIndex].sunrise),
                        RemainingTimeLabel(
                            isVisible: isVisible[2],
                            label: 'Öğlene kalan ',
                            remainingTime: remaining),
                        TimeLabel(
                            label: 'ÖĞLEN :', time: prayertimeList[todayIndex].dhuhr),
                        RemainingTimeLabel(
                            isVisible: isVisible[3],
                            label: 'İkindine kalan ',
                            remainingTime: remaining),
                        TimeLabel(
                            label: 'İKİNDİ :', time: prayertimeList[todayIndex].asr),
                        RemainingTimeLabel(
                            isVisible: isVisible[4],
                            label: 'Akşama kalan ',
                            remainingTime: remaining),
                        TimeLabel(
                            label: 'AKŞAM :', time: prayertimeList[todayIndex].maghrib),
                        RemainingTimeLabel(
                            isVisible: isVisible[5],
                            label: 'Yatsıya kalan ',
                            remainingTime: remaining),
                        TimeLabel(
                            label: 'YATSI :', time: prayertimeList[todayIndex].isha),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
