class SunrisesetM {
  Results? results;
  String? status;

  SunrisesetM({this.results, this.status});

  SunrisesetM.fromJson(Map<String, dynamic> json) {
    results = json['results'] != null ? Results.fromJson(json['results']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class Results {
  String? sunrise;
  String? sunset;
  String? solarNoon;
  int? dayLength;
  String? civilTwilightBegin;
  String? civilTwilightEnd;
  String? nauticalTwilightBegin;
  String? nauticalTwilightEnd;
  String? astronomicalTwilightBegin;
  String? astronomicalTwilightEnd;

  Results(
      {this.sunrise,
      this.sunset,
      this.solarNoon,
      this.dayLength,
      this.civilTwilightBegin,
      this.civilTwilightEnd,
      this.nauticalTwilightBegin,
      this.nauticalTwilightEnd,
      this.astronomicalTwilightBegin,
      this.astronomicalTwilightEnd});

  Results.fromJson(Map<String, dynamic> json) {
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    solarNoon = json['solar_noon'];
    dayLength = json['day_length'];
    civilTwilightBegin = json['civil_twilight_begin'];
    civilTwilightEnd = json['civil_twilight_end'];
    nauticalTwilightBegin = json['nautical_twilight_begin'];
    nauticalTwilightEnd = json['nautical_twilight_end'];
    astronomicalTwilightBegin = json['astronomical_twilight_begin'];
    astronomicalTwilightEnd = json['astronomical_twilight_end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    data['solar_noon'] = solarNoon;
    data['day_length'] = dayLength;
    data['civil_twilight_begin'] = civilTwilightBegin;
    data['civil_twilight_end'] = civilTwilightEnd;
    data['nautical_twilight_begin'] = nauticalTwilightBegin;
    data['nautical_twilight_end'] = nauticalTwilightEnd;
    data['astronomical_twilight_begin'] = astronomicalTwilightBegin;
    data['astronomical_twilight_end'] = astronomicalTwilightEnd;
    return data;
  }
}
