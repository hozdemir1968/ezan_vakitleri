import 'package:ezan_vakitleri/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'select_country.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return (StorageService().readIntFromStorage('townId') == -1)
        ? SelectCountry()
        : const HomePage();
  }
}
