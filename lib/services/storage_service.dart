import 'package:get_storage/get_storage.dart';
import '../db_helper/db_controller.dart';
import '../models/prayertime.dart';

class StorageService {
  final box = GetStorage();
  final dbController = DbController();

  void writeToStorage(String key, dynamic value) {
    box.write(key, value);
  }

  int readIntFromStorage(String key) {
    if (box.read(key) != null) {
      return box.read(key);
    } else {
      return -1;
    }
  }

  String readStrFromStorage(String key) {
    if (box.read(key) != null) {
      return box.read(key);
    } else {
      return '';
    }
  }

  Future saveLocalData(List prayertimeList) async {
    dbController.deleteAllData();
    var prayertime = Prayertime();
    for (int i = 0; i < prayertimeList.length; i++) {
      prayertime.asr = prayertimeList[i].asr;
      prayertime.astronomicalSunrise = prayertimeList[i].astronomicalSunrise;
      prayertime.astronomicalSunset = prayertimeList[i].astronomicalSunset;
      prayertime.dhuhr = prayertimeList[i].dhuhr;
      prayertime.fajr = prayertimeList[i].fajr;
      prayertime.greenwichMeanTimeZone = prayertimeList[i].greenwichMeanTimeZone;
      prayertime.gregorianDateLong = prayertimeList[i].gregorianDateLong;
      prayertime.gregorianDateLongIso8601 = prayertimeList[i].gregorianDateLongIso8601;
      prayertime.gregorianDateShort = prayertimeList[i].gregorianDateShort;
      prayertime.gregorianDateShortIso8601 = prayertimeList[i].gregorianDateShortIso8601;
      prayertime.hijriDateLong = prayertimeList[i].hijriDateLong;
      prayertime.hijriDateLongIso8601 = prayertimeList[i].hijriDateLongIso8601;
      prayertime.hijriDateShort = prayertimeList[i].hijriDateShort;
      prayertime.hijriDateShortIso8601 = prayertimeList[i].hijriDateShortIso8601;
      prayertime.isha = prayertimeList[i].isha;
      prayertime.maghrib = prayertimeList[i].maghrib;
      prayertime.qiblaTime = prayertimeList[i].qiblaTime;
      prayertime.shapeMoonUrl = prayertimeList[i].shapeMoonUrl;
      prayertime.sunrise = prayertimeList[i].sunrise;
      await dbController.saveData(prayertime);
    }
  }

  Future<List<Prayertime>> getLocalData() async {
    List<Prayertime> prayertimeList = [];
    var prayertimes = await dbController.readAllData();
    int i = 0;
    prayertimes.forEach((prayertime) {
      var prayertimeModel = Prayertime(
        id: i++,
        asr: prayertime['asr'],
        astronomicalSunrise: prayertime['astronomicalSunrise'],
        astronomicalSunset: prayertime['astronomicalSunset'],
        dhuhr: prayertime['dhuhr'],
        fajr: prayertime['fajr'],
        greenwichMeanTimeZone: prayertime['greenwichMeanTimeZone'],
        gregorianDateLong: prayertime['gregorianDateLong'],
        gregorianDateLongIso8601: prayertime['gregorianDateLongIso8601'],
        gregorianDateShort: prayertime['gregorianDateShort'],
        gregorianDateShortIso8601: prayertime['gregorianDateShortIso8601'],
        hijriDateLong: prayertime['hijriDateLong'],
        hijriDateLongIso8601: prayertime['hijriDateLongIso8601'],
        hijriDateShort: prayertime['hijriDateShort'],
        hijriDateShortIso8601: prayertime['hijriDateShortIso8601'],
        isha: prayertime['isha'],
        maghrib: prayertime['maghrib'],
        qiblaTime: prayertime['qiblaTime'],
        shapeMoonUrl: prayertime['shapeMoonUrl'],
        sunrise: prayertime['sunrise'],
      );
      prayertimeList.add(prayertimeModel);
    });
    return prayertimeList;
  }
}
