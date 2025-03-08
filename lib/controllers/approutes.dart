import 'package:flutter/material.dart';
import '../views/compass_page.dart';
import '../views/language_page.dart';
import '../views/praytime_page.dart';
import '../views/praytimes_page.dart';
import '../views/saved_towns_page.dart';
import '../views/suntimes_page.dart';
import '../views/select_country.dart';
import '../views/select_state.dart';
import '../views/select_town.dart';
import '../views/splash_page.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Splash());

      case '/selectcountry':
        return MaterialPageRoute(builder: (_) => const SelectCountry());

      case '/selectstate':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => SelectState(countryId: args?['countryId']),
        );

      case '/selecttown':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => SelectTown(stateId: args?['stateId']));

      case '/praytimepage':
        return MaterialPageRoute(builder: (_) => const PraytimePage());

      case '/praytimespage':
        return MaterialPageRoute(builder: (_) => const PraytimesPage());

      case '/savedtownspage':
        return MaterialPageRoute(builder: (_) => const SavedTownsPage());

      case '/suntimespage':
        return MaterialPageRoute(builder: (_) => const SuntimesPage());

      case '/compasspage':
        return MaterialPageRoute(builder: (_) => const CompassPage());

      case '/languagepage':
        return MaterialPageRoute(builder: (_) => const LanguagePage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text("Sayfa Bulunamadı"))),
        );
    }
  }
}
