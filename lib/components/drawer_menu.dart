import 'package:ezan_vakitleri/controllers/first_page_notifier.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_ctrl.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    final isFirstPage = FirstPageNotifier();

    return Scaffold(
      appBar: AppBar(title: Text('menu'.tr), centerTitle: true),
      body: Drawer(
        elevation: 4,
        child: ListView(
          children: [
            ValueListenableBuilder(
              valueListenable: isFirstPage,
              builder: (context, value, child) {
                return ListTile(
                  leading: const Icon(Icons.home),
                  title: Text('gunluk'.tr),
                  trailing: value ? Text('varsayilan'.tr) : const Text('-'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/praytimepage');
                  },
                  onLongPress: () {
                    isFirstPage.toggle();
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/praytimepage');
                  },
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: isFirstPage,
              builder: (context, value, child) {
                return ListTile(
                  leading: const Icon(Icons.home),
                  title: Text('aylik'.tr),
                  trailing: !value ? Text('varsayilan'.tr) : const Text('-'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/praytimespage');
                  },
                  onLongPress: () {
                    isFirstPage.toggle();
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/praytimespage');
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_location_alt_outlined),
              title: Text('konum_degistir'.tr),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/savedtownspage');
              },
            ),
            ListTile(
              leading: const Icon(Icons.sunny),
              title: Text('gunes_dogus_batis'.tr),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/suntimespage');
              },
            ),
            ListTile(
              leading: const Icon(Icons.north),
              title: Text('pusula'.tr),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/compasspage');
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text('dil'.tr),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/languagepage');
              },
            ),
            GetBuilder<ThemeCtrl>(
              builder: (controller) {
                return ListTile(
                  leading:
                      controller.isDark
                          ? const Icon(Icons.dark_mode)
                          : const Icon(Icons.light_mode),
                  title: Text('aydinlik_karanlik'.tr),
                  trailing: Transform.scale(
                    scale: 0.80,
                    child: Switch(
                      value: controller.isDark,
                      onChanged: (val) {
                        controller.changeTheme(val);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
