import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'praytime_page.dart';
import 'praytimes_page.dart';
import '../views/select_country.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    int townId = box.read("townId") ?? -1;
    bool isFirstPage = box.read("isFirstPage") ?? false;

    return townId == -1
        ? const SelectCountry()
        : isFirstPage
        ? const PraytimePage()
        : const PraytimesPage();
  }
}
