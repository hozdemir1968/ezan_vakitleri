import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'home_page.dart';
import 'select_country.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();

    return (box.read('townId') == null) ? const SelectCountry() : const HomePage();
  }
}
