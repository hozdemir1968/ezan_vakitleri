import 'dart:async';
import 'package:ezan_vakitleri/models/prayertime.dart';
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
  Timer? timer;
  int toDayIndex = -1;
  int townId = 9541;
  String townName = 'İSTANBUL';
  List<bool> isVisible = [false, false, false, false, false, false];
  String remaining = '';

  void initTimer() {
    if (timer != null && timer!.isActive) return;
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      //job
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void findLocal() {
    if (box.read('townId') != null) {
      townId = box.read('townId');
    }
    if (box.read('townName') != null) {
      townName = box.read('townName');
    }
  }

  void findDay(AsyncSnapshot snapshot) {
    bool isDayIndex = false;
    String dt1 = DateTime.now().toString();
    if (toDayIndex == -1) {
      toDayIndex++;
      do {
        String dt2 = snapshot.data![toDayIndex].gregorianDateLongIso8601;
        if (dt1.substring(10) != dt2.substring(10)) {
          toDayIndex++;
        } else {
          isDayIndex = true;
        }
      } while (isDayIndex);
    }
  }

  void findRemainingTime(AsyncSnapshot snapshot) {
    String timeNow = DateTime.now().toString().substring(11, 16);
    String time0 = snapshot.data![toDayIndex].fajr;
    String time1 = snapshot.data![toDayIndex].sunrise;
    String time2 = snapshot.data![toDayIndex].dhuhr;
    String time3 = snapshot.data![toDayIndex].asr;
    String time4 = snapshot.data![toDayIndex].maghrib;
    String time5 = snapshot.data![toDayIndex].isha;
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
        remaining = Services().calcHoursMinutes((1440 - timeNowInt) + time0Int);
      } else {
        remaining = Services().calcHoursMinutes(time0Int - timeNowInt);
      }
    }
    if (timeNowInt > time0Int && timeNowInt < time1Int) {
      isVisible = [false, true, false, false, false, false];
      remaining = Services().calcHoursMinutes(time1Int - timeNowInt);
    }
    if (timeNowInt > time1Int && timeNowInt < time2Int) {
      isVisible = [false, false, true, false, false, false];
      remaining = Services().calcHoursMinutes(time2Int - timeNowInt);
    }
    if (timeNowInt > time2Int && timeNowInt < time3Int) {
      isVisible = [false, false, false, true, false, false];
      remaining = Services().calcHoursMinutes(time3Int - timeNowInt);
    }
    if (timeNowInt > time3Int && timeNowInt < time4Int) {
      isVisible = [false, false, false, false, true, false];
      remaining = Services().calcHoursMinutes(time4Int - timeNowInt);
    }
    if (timeNowInt > time4Int && timeNowInt < time5Int) {
      isVisible = [false, false, false, false, false, true];
      remaining = Services().calcHoursMinutes(time5Int - timeNowInt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ezan Vakitleri'),
      ),
      body: FutureBuilder<List<PrayerTime>>(
        future: ApiServices().getPrayerTimes(townId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            initTimer();
            findLocal();
            findDay(snapshot);
            findRemainingTime(snapshot);
            return Column(
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
                        TopLabel(data: snapshot.data![toDayIndex].gregorianDateLong),
                        TopLabel(data: snapshot.data![toDayIndex].hijriDateLong),
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
                            label: 'İMSAK :', time: snapshot.data![toDayIndex].fajr),
                        RemainingTimeLabel(
                            isVisible: isVisible[1],
                            label: 'Güneşe kalan ',
                            remainingTime: remaining),
                        TimeLabel(
                            label: 'GÜNEŞ :', time: snapshot.data![toDayIndex].sunrise),
                        RemainingTimeLabel(
                            isVisible: isVisible[2],
                            label: 'Öğlene kalan ',
                            remainingTime: remaining),
                        TimeLabel(
                            label: 'ÖĞLEN :', time: snapshot.data![toDayIndex].dhuhr),
                        RemainingTimeLabel(
                            isVisible: isVisible[3],
                            label: 'İkindine kalan ',
                            remainingTime: remaining),
                        TimeLabel(
                            label: 'İKİNDİ :', time: snapshot.data![toDayIndex].asr),
                        RemainingTimeLabel(
                            isVisible: isVisible[4],
                            label: 'Akşama kalan ',
                            remainingTime: remaining),
                        TimeLabel(
                            label: 'AKŞAM :', time: snapshot.data![toDayIndex].maghrib),
                        RemainingTimeLabel(
                            isVisible: isVisible[5],
                            label: 'Yatsıya kalan ',
                            remainingTime: remaining),
                        TimeLabel(
                            label: 'YATSI :', time: snapshot.data![toDayIndex].isha),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
