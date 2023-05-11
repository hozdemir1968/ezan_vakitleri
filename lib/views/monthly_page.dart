import 'package:flutter/material.dart';
import '../services/services.dart';

class MonthlyPage extends StatelessWidget {
  const MonthlyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aylık Ezan Vakitleri'),
      ),
      body: FutureBuilder(
        future: Services().getLocalData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(snapshot.data![index].gregorianDateLong.toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(snapshot.data![index].fajr.toString(),
                              style: const TextStyle(fontSize: 16)),
                          Text(snapshot.data![index].sunrise.toString(),
                              style: const TextStyle(fontSize: 16)),
                          Text(snapshot.data![index].dhuhr.toString(),
                              style: const TextStyle(fontSize: 16)),
                          Text(snapshot.data![index].asr.toString(),
                              style: const TextStyle(fontSize: 16)),
                          Text(snapshot.data![index].maghrib.toString(),
                              style: const TextStyle(fontSize: 16)),
                          Text(snapshot.data![index].isha.toString(),
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
