import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeCtrl extends GetxController {
  final box = GetStorage();
  bool isDark = false;

  @override
  void onInit() {
    super.onInit();
    isDark = box.read('isDarkMode') ?? false;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void changeTheme(bool isDarkMode) async {
    isDark = isDarkMode;
    await box.write('isDarkMode', isDark);
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
