// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PraytimesVM {
  int? townId;
  String? townName;
  String? hijriDate;
  DateTime? gregorianDate;
  List<DateTime>? praytimes;
  DailyVM? dailyVM;

  PraytimesVM({
    this.townId,
    this.townName,
    this.hijriDate,
    this.gregorianDate,
    this.praytimes,
    this.dailyVM,
  });

  PraytimesVM copyWith({
    int? townId,
    String? townName,
    String? hijriDate,
    DateTime? gregorianDate,
    List<DateTime>? praytimes,
    DailyVM? dailyVM,
  }) {
    return PraytimesVM(
      townId: townId ?? this.townId,
      townName: townName ?? this.townName,
      hijriDate: hijriDate ?? this.hijriDate,
      gregorianDate: gregorianDate ?? this.gregorianDate,
      praytimes: praytimes ?? this.praytimes,
      dailyVM: dailyVM ?? this.dailyVM,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'townId': townId,
      'townName': townName,
      'hijriDate': hijriDate,
      'gregorianDate': gregorianDate?.millisecondsSinceEpoch,
      'praytimes': praytimes!.map((x) => x.millisecondsSinceEpoch).toList(),
      'dailyVM': dailyVM?.toMap(),
    };
  }

  factory PraytimesVM.fromMap(Map<String, dynamic> map) {
    return PraytimesVM(
      townId: map['townId'] != null ? map['townId'] as int : null,
      townName: map['townName'] != null ? map['townName'] as String : null,
      hijriDate: map['hijriDate'] != null ? map['hijriDate'] as String : null,
      gregorianDate:
          map['gregorianDate'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['gregorianDate'] as int)
              : null,
      praytimes:
          map['praytimes'] != null
              ? List<DateTime>.from(
                (map['praytimes'] as List<int>).map<DateTime?>(
                  (x) => DateTime.fromMillisecondsSinceEpoch(x),
                ),
              )
              : null,
      dailyVM:
          map['dailyVM'] != null
              ? DailyVM.fromMap(map['dailyVM'] as Map<String, dynamic>)
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PraytimesVM.fromJson(String source) =>
      PraytimesVM.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PraytimesVM(townId: $townId, townName: $townName, hijriDate: $hijriDate, gregorianDate: $gregorianDate, praytimes: $praytimes, dailyVM: $dailyVM)';
  }
}

class DailyVM {
  String? verse;
  String? verseSource;
  String? hadith;
  String? hadithSource;
  String? pray;
  String? praySource;

  DailyVM({
    this.verse,
    this.verseSource,
    this.hadith,
    this.hadithSource,
    this.pray,
    this.praySource,
  });

  DailyVM copyWith({
    String? verse,
    String? verseSource,
    String? hadith,
    String? hadithSource,
    String? pray,
    String? praySource,
  }) {
    return DailyVM(
      verse: verse ?? this.verse,
      verseSource: verseSource ?? this.verseSource,
      hadith: hadith ?? this.hadith,
      hadithSource: hadithSource ?? this.hadithSource,
      pray: pray ?? this.pray,
      praySource: praySource ?? this.praySource,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'verse': verse,
      'verseSource': verseSource,
      'hadith': hadith,
      'hadithSource': hadithSource,
      'pray': pray,
      'praySource': praySource,
    };
  }

  factory DailyVM.fromMap(Map<String, dynamic> map) {
    return DailyVM(
      verse: map['verse'] != null ? map['verse'] as String : null,
      verseSource: map['verseSource'] != null ? map['verseSource'] as String : null,
      hadith: map['hadith'] != null ? map['hadith'] as String : null,
      hadithSource: map['hadithSource'] != null ? map['hadithSource'] as String : null,
      pray: map['pray'] != null ? map['pray'] as String : null,
      praySource: map['praySource'] != null ? map['praySource'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DailyVM.fromJson(String source) =>
      DailyVM.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Daily(verse: $verse, verseSource: $verseSource, hadith: $hadith, hadithSource: $hadithSource, pray: $pray, praySource: $praySource)';
  }
}
