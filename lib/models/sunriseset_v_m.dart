class SunrisesetVM {
  String? lat;
  String? lng;
  DateTime? date;
  String? formatted;
  int? dayLength;
  List<DateTime>? suntimes = [];

  SunrisesetVM({
    this.lat,
    this.lng,
    this.date,
    this.formatted,
    this.dayLength,
    this.suntimes,
  });
}
