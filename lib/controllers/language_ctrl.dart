import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

String initializeLngCode() {
  final box = GetStorage();
  String lngCode = '';
  if (box.read('lngCode') != null) {
    lngCode = box.read('lngCode');
  } else {
    lngCode = Get.deviceLocale != null ? Get.deviceLocale!.languageCode : 'en';
  }
  initializeDateFormatting(lngCode, '');
  return lngCode;
}

String initializeLclCode() {
  final box = GetStorage();
  String lclCode = '';
  if (box.read('lclCode') != null) {
    lclCode = box.read('lclCode');
  } else {
    lclCode = Get.deviceLocale != null ? Get.deviceLocale!.countryCode.toString() : 'US';
  }
  return lclCode;
}
