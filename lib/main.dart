import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workmanager/workmanager.dart';
import 'components/messages.dart';
import 'controllers/approutes.dart';
import 'controllers/notification_ctrl.dart';
import 'services/notification_service.dart';
import 'components/custom_theme.dart';
import 'controllers/language_ctrl.dart';
import 'controllers/theme_ctrl.dart';
import 'package:timezone/data/latest.dart' as tz;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await NotificationCtrl().setNotifications();
      return Future.value(true);
    } catch (error) {
      return Future.error(error);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();
  await GetStorage.init();
  DateTime thisDate = DateTime.now();
  thisDate = DateTime(thisDate.year, thisDate.month, thisDate.day, thisDate.hour);
  DateTime nextDate = DateTime(thisDate.year, thisDate.month, thisDate.day, 1);
  if (thisDate.isAfter(nextDate)) {
    nextDate = nextDate.add(Duration(days: 1));
  }
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager().registerPeriodicTask(
    "dailyEzanUpdate",
    "fetchEzanTimes",
    frequency: const Duration(hours: 24),
    initialDelay: nextDate.difference(thisDate),
    constraints: Constraints(networkType: NetworkType.connected),
  );
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
