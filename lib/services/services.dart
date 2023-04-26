class Services {
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
