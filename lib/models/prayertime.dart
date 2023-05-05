class PrayerTime {
  int? id;
  String? shapeMoonUrl;
  String? fajr;
  String? sunrise;
  String? dhuhr;
  String? asr;
  String? maghrib;
  String? isha;
  String? astronomicalSunset;
  String? astronomicalSunrise;
  String? hijriDateShort;
  String? hijriDateShortIso8601;
  String? hijriDateLong;
  String? hijriDateLongIso8601;
  String? qiblaTime;
  String? gregorianDateShort;
  String? gregorianDateShortIso8601;
  String? gregorianDateLong;
  String? gregorianDateLongIso8601;
  int? greenwichMeanTimeZone;

  PrayerTime({
    this.id,
    this.shapeMoonUrl,
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.maghrib,
    this.isha,
    this.astronomicalSunset,
    this.astronomicalSunrise,
    this.hijriDateShort,
    this.hijriDateShortIso8601,
    this.hijriDateLong,
    this.hijriDateLongIso8601,
    this.qiblaTime,
    this.gregorianDateShort,
    this.gregorianDateShortIso8601,
    this.gregorianDateLong,
    this.gregorianDateLongIso8601,
    this.greenwichMeanTimeZone,
  });

  PrayerTime.fromJson(Map<String, dynamic> json) {
    shapeMoonUrl = json['shapeMoonUrl'];
    fajr = json['fajr'];
    sunrise = json['sunrise'];
    dhuhr = json['dhuhr'];
    asr = json['asr'];
    maghrib = json['maghrib'];
    isha = json['isha'];
    astronomicalSunset = json['astronomicalSunset'];
    astronomicalSunrise = json['astronomicalSunrise'];
    hijriDateShort = json['hijriDateShort'];
    hijriDateShortIso8601 = json['hijriDateShortIso8601'];
    hijriDateLong = json['hijriDateLong'];
    hijriDateLongIso8601 = json['hijriDateLongIso8601'];
    qiblaTime = json['qiblaTime'];
    gregorianDateShort = json['gregorianDateShort'];
    gregorianDateShortIso8601 = json['gregorianDateShortIso8601'];
    gregorianDateLong = json['gregorianDateLong'];
    gregorianDateLongIso8601 = json['gregorianDateLongIso8601'];
    greenwichMeanTimeZone = json['greenwichMeanTimeZone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shapeMoonUrl'] = shapeMoonUrl;
    data['fajr'] = fajr;
    data['sunrise'] = sunrise;
    data['dhuhr'] = dhuhr;
    data['asr'] = asr;
    data['maghrib'] = maghrib;
    data['isha'] = isha;
    data['astronomicalSunset'] = astronomicalSunset;
    data['astronomicalSunrise'] = astronomicalSunrise;
    data['hijriDateShort'] = hijriDateShort;
    data['hijriDateShortIso8601'] = hijriDateShortIso8601;
    data['hijriDateLong'] = hijriDateLong;
    data['hijriDateLongIso8601'] = hijriDateLongIso8601;
    data['qiblaTime'] = qiblaTime;
    data['gregorianDateShort'] = gregorianDateShort;
    data['gregorianDateShortIso8601'] = gregorianDateShortIso8601;
    data['gregorianDateLong'] = gregorianDateLong;
    data['gregorianDateLongIso8601'] = gregorianDateLongIso8601;
    data['greenwichMeanTimeZone'] = greenwichMeanTimeZone;
    return data;
  }

  PrayerTime.fromMap(Map<String, dynamic> map) {
    shapeMoonUrl = map['shapeMoonUrl'];
    fajr = map['fajr'];
    sunrise = map['sunrise'];
    dhuhr = map['dhuhr'];
    asr = map['asr'];
    maghrib = map['maghrib'];
    isha = map['isha'];
    astronomicalSunset = map['astronomicalSunset'];
    astronomicalSunrise = map['astronomicalSunrise'];
    hijriDateShort = map['hijriDateShort'];
    hijriDateShortIso8601 = map['hijriDateShortIso8601'];
    hijriDateLong = map['hijriDateLong'];
    hijriDateLongIso8601 = map['hijriDateLongIso8601'];
    qiblaTime = map['qiblaTime'];
    gregorianDateShort = map['gregorianDateShort'];
    gregorianDateShortIso8601 = map['gregorianDateShortIso8601'];
    gregorianDateLong = map['gregorianDateLong'];
    gregorianDateLongIso8601 = map['gregorianDateLongIso8601'];
    greenwichMeanTimeZone = map['greenwichMeanTimeZone'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['shapeMoonUrl'] = shapeMoonUrl;
    map['fajr'] = fajr;
    map['sunrise'] = sunrise;
    map['dhuhr'] = dhuhr;
    map['asr'] = asr;
    map['maghrib'] = maghrib;
    map['isha'] = isha;
    map['astronomicalSunset'] = astronomicalSunset;
    map['astronomicalSunrise'] = astronomicalSunrise;
    map['hijriDateShort'] = hijriDateShort;
    map['hijriDateShortIso8601'] = hijriDateShortIso8601;
    map['hijriDateLong'] = hijriDateLong;
    map['hijriDateLongIso8601'] = hijriDateLongIso8601;
    map['qiblaTime'] = qiblaTime;
    map['gregorianDateShort'] = gregorianDateShort;
    map['gregorianDateShortIso8601'] = gregorianDateShortIso8601;
    map['gregorianDateLong'] = gregorianDateLong;
    map['gregorianDateLongIso8601'] = gregorianDateLongIso8601;
    map['greenwichMeanTimeZone'] = greenwichMeanTimeZone;
    return map;
  }
}
