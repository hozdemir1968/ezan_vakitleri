import 'package:ezan_vakitleri/models/prayertime.dart';
import 'package:ezan_vakitleri/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonthlyPage extends ConsumerWidget {
  const MonthlyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyData = ref.watch(getLocalPrayerTimesProvider);
    final size = MediaQuery.of(context).size;
    MainAxisAlignment thisAlignment;
    size.width < 750
        ? thisAlignment = MainAxisAlignment.spaceBetween
        : thisAlignment = MainAxisAlignment.spaceEvenly;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aylık Ezan Vakitleri'),
      ),
      body: monthlyData.when(
        data: (data) {
          return showData(data, thisAlignment);
        },
        error: (error, s) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  ListView showData(List<Prayertime> data, MainAxisAlignment thisAlignment) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data[index].gregorianDateLong.toString(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: thisAlignment,
                children: const [
                  Text('İmsak', style: TextStyle(fontSize: 16)),
                  Text('Güneş', style: TextStyle(fontSize: 16)),
                  Text('Öğlen', style: TextStyle(fontSize: 16)),
                  Text('İkindi', style: TextStyle(fontSize: 16)),
                  Text('Akşam', style: TextStyle(fontSize: 16)),
                  Text('Yatsı', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: thisAlignment,
                children: [
                  Text(data[index].fajr.toString(), style: const TextStyle(fontSize: 18)),
                  Text(data[index].sunrise.toString(),
                      style: const TextStyle(fontSize: 18)),
                  Text(data[index].dhuhr.toString(),
                      style: const TextStyle(fontSize: 18)),
                  Text(data[index].asr.toString(), style: const TextStyle(fontSize: 18)),
                  Text(data[index].maghrib.toString(),
                      style: const TextStyle(fontSize: 18)),
                  Text(data[index].isha.toString(), style: const TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
