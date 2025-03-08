class MyPosition {
  bool hasPermission;
  double? lat;
  double? lng;
  double? alt;
  double? bearing;

  MyPosition({
    required this.hasPermission,
    this.lat,
    this.lng,
    this.alt,
    this.bearing,
  });
}
