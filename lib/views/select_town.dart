import 'package:ezan_vakitleri/services/api_services.dart';
import 'package:ezan_vakitleri/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../models/mytown.dart';

class SelectTown extends StatefulWidget {
  const SelectTown({super.key});

  @override
  State<SelectTown> createState() => _SelectTownState();
}

class _SelectTownState extends State<SelectTown> {
  late Future<MyTown> futureCountry;
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    int id = box.read('stateId');

    return Scaffold(
      appBar: AppBar(
        title: const Text('İLÇE SEÇ'),
      ),
      body: FutureBuilder<List<MyTown>>(
        future: ApiServices().getTowns(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].name.toString()),
                    onTap: () {
                      box.write('townId', snapshot.data![index].id);
                      box.write('townName', snapshot.data![index].name);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const HomePage()));
                    },
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
