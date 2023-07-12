import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import '../services/dark_light_service.dart';
import '../views/home_page.dart';
import '../views/monthly_page.dart';

class DrawerMenu extends ConsumerWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkMode = ref.watch(darkModeProvider);
    final box = GetStorage();

    return Scaffold(
      appBar: AppBar(
        title: const Text("MENU"),
        centerTitle: true,
      ),
      body: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text("ANASAYFA"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.list),
                    title: const Text("AYLIK LİSTE"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MonthlyPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.add_location_alt_outlined),
                    title: const Text("KONUM SEÇ"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      box.erase();
                      Phoenix.rebirth(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.mode),
                    title: const Text('Aydınlık/Karanlık'),
                    trailing: Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        ref.read(darkModeProvider.notifier).toggle();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
