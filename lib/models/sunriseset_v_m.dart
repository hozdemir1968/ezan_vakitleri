class SunrisesetVM {
  bool? hasPermission;
  String? lat;
  String? lng;
  DateTime? date;
  String? formatted;
  int? dayLength;
  List<DateTime>? suntimes = [];

  SunrisesetVM({
    this.hasPermission,
    this.lat,
    this.lng,
    this.date,
    this.formatted,
    this.dayLength,
    this.suntimes,
  });
}
