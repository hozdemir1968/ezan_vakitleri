import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  static const routeName = '/languagepage';

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

var items = ['Türkçe', 'English'];
String selectedItem = '';

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    var selected = box.read('lngCode') ?? 'en';
    selected == 'en' ? selectedItem = 'English' : selectedItem = 'Türkçe';

    return Scaffold(
      appBar: AppBar(title: Text('dil_sec'.tr), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              hint: const Text('Select Language'),
              value: selectedItem,
              items:
                  items.map((String item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedItem = newValue!;
                  if (selectedItem == 'English') {
                    var locale = const Locale('en', 'US');
                    box.write('lngCode', 'en');
                    box.write('lclCode', 'US');
                    Get.updateLocale(locale);
                    initializeDateFormatting('en', '');
                  }
                  if (selectedItem == 'Türkçe') {
                    var locale = const Locale('tr', 'TR');
                    box.write('lngCode', 'tr');
                    box.write('lclCode', 'TR');
                    Get.updateLocale(locale);
                    initializeDateFormatting('tr', '');
                  }
                  Get.back();
                });
              },
            ),
            const SizedBox(height: 75),
          ],
        ),
      ),
    );
  }
}
