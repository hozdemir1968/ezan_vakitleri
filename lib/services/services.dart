import '../models/prayertime.dart';
import 'db_services.dart';

class Services {
  Future saveLocalData(List prayertimeList) async {
    DbServices().deleteAllData();
    var prayertime = PrayerTime();
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
      await DbServices().saveData(prayertime);
    }
  }

  Future getLocalData() async {
    List<PrayerTime> prayertimeList = [];
    var prayertimes = await DbServices().readAllData();
    int i = 1;
    prayertimes.forEach((prayertime) {
      var prayertimeModel = PrayerTime();
      prayertimeModel.id = i;
      prayertimeModel.asr = prayertime['asr'];
      prayertimeModel.astronomicalSunrise = prayertime['astronomicalSunrise'];
      prayertimeModel.astronomicalSunset = prayertime['astronomicalSunset'];
      prayertimeModel.dhuhr = prayertime['dhuhr'];
      prayertimeModel.fajr = prayertime['fajr'];
      prayertimeModel.greenwichMeanTimeZone = prayertime['greenwichMeanTimeZone'];
      prayertimeModel.gregorianDateLong = prayertime['gregorianDateLong'];
      prayertimeModel.gregorianDateLongIso8601 = prayertime['gregorianDateLongIso8601'];
      prayertimeModel.gregorianDateShort = prayertime['gregorianDateShort'];
      prayertimeModel.gregorianDateShortIso8601 = prayertime['gregorianDateShortIso8601'];
      prayertimeModel.hijriDateLong = prayertime['hijriDateLong'];
      prayertimeModel.hijriDateLongIso8601 = prayertime['hijriDateLongIso8601'];
      prayertimeModel.hijriDateShort = prayertime['hijriDateShort'];
      prayertimeModel.hijriDateShortIso8601 = prayertime['hijriDateShortIso8601'];
      prayertimeModel.isha = prayertime['isha'];
      prayertimeModel.maghrib = prayertime['maghrib'];
      prayertimeModel.qiblaTime = prayertime['qiblaTime'];
      prayertimeModel.shapeMoonUrl = prayertime['shapeMoonUrl'];
      prayertimeModel.sunrise = prayertime['sunrise'];
      prayertimeList.add(prayertimeModel);
      i++;
    });
    return prayertimeList;
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
      sonuc = '$hours saat $minutes dakika';
    } else {
      sonuc = '$minutes dakika';
    }
    return sonuc;
  }
}
