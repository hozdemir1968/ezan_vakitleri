import 'dart:async';
import 'package:flutter/material.dart';
import '../components/drawer_menu.dart';
import '../components/label_label_time.dart';
import '../components/label_remaining_time.dart';
import '../models/prayertime.dart';
import '../models/time_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apiService = ApiService();
  final storageService = StorageService();
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
    townId = storageService.readIntFromStorage('townId');
    townName = storageService.readStrFromStorage('townName');
    savedDay = storageService.readStrFromStorage('savedDay');
    if (savedDay == DateTime.now().toString().substring(0, 10)) {
      getData("LOCAL");
    } else {
      getData("API");
    }
    initTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void initTimer() {
    if (timer != null && timer!.isActive) return;
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      checkToday();
      findTodayIndex();
      setState(() {});
    });
  }

  void getData(String where) async {
    setState(() {
      isLoading = true;
    });
    if (where == "API") {
      prayertimeList = await apiService.getPrayerTimes(townId);
      await storageService.saveLocalData(prayertimeList);
      storageService.writeToStorage(
          'savedDay', DateTime.now().toString().substring(0, 10));
    }
    if (where == "LOCAL") {
      prayertimeList = await storageService.getLocalData();
    }
    setTimeModel();
    checkToday();
    findTodayIndex();
    setState(() {
      isLoading = false;
    });
  }

  void checkToday() {
    savedDay = storageService.readStrFromStorage('savedDay');
    if (savedDay != DateTime.now().toString().substring(0, 10)) {
      getData("API");
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
        remainingTime = calcHoursMinutes((1440 - timeNowInt) + timeModelInt.time0!);
      } else {
        remainingTime = calcHoursMinutes(timeModelInt.time0! - timeNowInt);
      }
    }
    if (timeNowInt > timeModelInt.time0! && timeNowInt < timeModelInt.time1!) {
      isVisible = [false, true, false, false, false, false];
      remainingTime = calcHoursMinutes(timeModelInt.time1! - timeNowInt);
    }
    if (timeNowInt > timeModelInt.time1! && timeNowInt < timeModelInt.time2!) {
      isVisible = [false, false, true, false, false, false];
      remainingTime = calcHoursMinutes(timeModelInt.time2! - timeNowInt);
    }
    if (timeNowInt > timeModelInt.time2! && timeNowInt < timeModelInt.time3!) {
      isVisible = [false, false, false, true, false, false];
      remainingTime = calcHoursMinutes(timeModelInt.time3! - timeNowInt);
    }
    if (timeNowInt > timeModelInt.time3! && timeNowInt < timeModelInt.time4!) {
      isVisible = [false, false, false, false, true, false];
      remainingTime = calcHoursMinutes(timeModelInt.time4! - timeNowInt);
    }
    if (timeNowInt > timeModelInt.time4! && timeNowInt < timeModelInt.time5!) {
      isVisible = [false, false, false, false, false, true];
      remainingTime = calcHoursMinutes(timeModelInt.time5! - timeNowInt);
    }
  }

  String calcHoursMinutes(int number) {
    String sonuc = '';
    int hours = 0;
    int minutes = 0;
    if (number > 60) {
      hours = number ~/ 60;
      minutes = number - (hours * 60);
    } else {
      hours = 0;
      minutes = number;
    }
    if (hours > 0) {
      if (minutes > 0) {
        sonuc = '$hours saat $minutes dakika';
      } else {
        sonuc = '$hours saat';
      }
    } else {
      sonuc = '$minutes dakika';
    }
    return sonuc;
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    prayertimeList.isNotEmpty ? findRemainingTime() : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ezan Vakitleri'),
      ),
      drawer: const DrawerMenu(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : size.height > 750
              ? Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: topData(),
                    ),
                    Expanded(
                      flex: 5,
                      child: bottomData(),
                    ),
                  ],
                )
              : ListView(
                  children: [
                    topData(),
                    bottomData(),
                  ],
                ),
    );
  }

  Container topData() {
    return Container(
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
    );
  }

  Container bottomData() {
    return Container(
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
    );
  }
}
