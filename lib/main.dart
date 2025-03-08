import 'package:ezan_vakitleri/components/messages.dart';
import 'package:ezan_vakitleri/controllers/approutes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'components/custom_theme.dart';
import 'controllers/language_ctrl.dart';
import 'controllers/theme_ctrl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String lngCode = initializeLngCode();
    String lclCode = initializeLclCode();
    final ThemeCtrl themeCtrl = Get.put<ThemeCtrl>(ThemeCtrl());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ezan Vakitleri',
      theme: CustomTheme.light,
      darkTheme: CustomTheme.dark,
      themeMode: themeCtrl.isDark ? ThemeMode.dark : ThemeMode.light,
      translations: Messages(),
      locale: Locale(lngCode, lclCode),
      fallbackLocale: Locale('en', 'US'),
      initialRoute: '/',
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
