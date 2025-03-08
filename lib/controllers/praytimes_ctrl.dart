import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../models/praytimes_vm.dart';
import '../services/api_service.dart';
import '../services/db_service.dart';
import '../models/mypraytime.dart';

class PraytimesCtrl {
  final ApiService apiService = ApiService();
  final DBService dbService = DBService();
  final box = GetStorage();
  List<MyPraytime> praytimeList = [];
  DailyVM dailyVM = DailyVM();

  Future<List<PraytimesVM>> getPraytimesVMList() async {
    int townId = box.read("townId") ?? -1;
    String townName = box.read("townName") ?? "";
    DateTime tday = DateTime.now().toLocal();
    DateTime today = parseTime("00:00", tday.year, tday.month, tday.day);
    List<PraytimesVM> praytimesVMList = [];
    praytimeList = await getPraytimes(townId, today);
    for (var i = 0; i < praytimeList.length; i++) {
      DateTime date = DateTime.parse(praytimeList[i].gregorianDateLongIso8601!).toLocal();
      date = parseTime("00:00", date.year, date.month, date.day);
      final praytimes = [
        parseTime(praytimeList[i].fajr.toString(), date.year, date.month, date.day),
        parseTime(praytimeList[i].sunrise.toString(), date.year, date.month, date.day),
        parseTime(praytimeList[i].dhuhr.toString(), date.year, date.month, date.day),
        parseTime(praytimeList[i].asr.toString(), date.year, date.month, date.day),
        parseTime(praytimeList[i].maghrib.toString(), date.year, date.month, date.day),
        parseTime(praytimeList[i].isha.toString(), date.year, date.month, date.day),
      ];
      final model = PraytimesVM(
        townId: townId,
        townName: townName,
        hijriDate: praytimeList[i].hijriDateLong,
        gregorianDate: date,
        praytimes: praytimes,
      );
      if (date.isAtSameMomentAs(today) || date.isAfter(today)) {
        praytimesVMList.add(model);
      }
    }
    dailyVM = await getDaily();
    praytimesVMList[0].dailyVM = dailyVM;
    return praytimesVMList;
  }

  Future<List<MyPraytime>> getPraytimes(int townId, DateTime today) async {
    List<MyPraytime> praytime2List = [];
    DateTime saveDate;
    if (box.read("saveDate") == "") {
      saveDate = today.subtract(const Duration(days: 1));
    } else {
      saveDate = DateTime.parse(box.read("saveDate"));
    }
    try {
      if (saveDate.month == today.month && saveDate.day == today.day) {
        debugPrint("DB");
        praytimeList = await dbService.getPrayTimes(townId);
      } else {
        debugPrint("API");
        praytimeList = await apiService.getPrayTimes(townId);
        await savePraytimesToDB(praytimeList, today, townId);
        dailyVM = await apiService.getDaily();
        await saveDailyToDB(dailyVM);
      }
    } catch (e) {
      praytimeList = [];
      rethrow;
    }
    for (int i = 0; i < praytimeList.length; i++) {
      DateTime date = DateTime.parse(praytimeList[i].gregorianDateLongIso8601!).toLocal();
      date = parseTime("00:00", date.year, date.month, date.day);
      if (date.isAtSameMomentAs(today) || date.isAfter(today)) {
        praytime2List.add(praytimeList[i]);
      }
    }
    return praytime2List;
  }

  DateTime parseTime(String time, int year, int month, int day) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(year, month, day, hour, minute);
  }

  Future<DailyVM> getDaily() async {
    DailyVM dailyVM;
    try {
      dailyVM = await dbService.getDaily();
    } catch (e) {
      rethrow;
    }
    return dailyVM;
  }

  Future<void> savePraytimesToDB(List praytimeList, DateTime today, int townId) async {
    await box.write('saveDate', today.toString());
    await dbService.deletePrayTimesBy(townId);
    for (int i = 0; i < praytimeList.length; i++) {
      MyPraytime praytime = MyPraytime(
        id: i,
        townId: townId,
        fajr: praytimeList[i].fajr,
        sunrise: praytimeList[i].sunrise,
        dhuhr: praytimeList[i].dhuhr,
        asr: praytimeList[i].asr,
        maghrib: praytimeList[i].maghrib,
        isha: praytimeList[i].isha,
        shapeMoonUrl: praytimeList[i].shapeMoonUrl,
        astronomicalSunset: praytimeList[i].astronomicalSunset,
        astronomicalSunrise: praytimeList[i].astronomicalSunrise,
        hijriDateShort: praytimeList[i].hijriDateShort,
        hijriDateShortIso8601: praytimeList[i].hijriDateShortIso8601,
        hijriDateLong: praytimeList[i].hijriDateLong,
        hijriDateLongIso8601: praytimeList[i].hijriDateLongIso8601,
        qiblaTime: praytimeList[i].qiblaTime,
        gregorianDateShort: praytimeList[i].gregorianDateShort,
        gregorianDateShortIso8601: praytimeList[i].gregorianDateShortIso8601,
        gregorianDateLong: praytimeList[i].gregorianDateLong,
        gregorianDateLongIso8601: praytimeList[i].gregorianDateLongIso8601,
        greenwichMeanTimeZone: praytimeList[i].greenwichMeanTimeZone,
      );
      await dbService.insertPrayTime(praytime);
    }
  }

  Future<void> saveDailyToDB(DailyVM model) async {
    await dbService.deleteDailies();
    await dbService.insertDaily(model);
  }
}
