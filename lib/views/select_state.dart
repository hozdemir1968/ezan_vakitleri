import 'package:ezan_vakitleri/services/api_services.dart';
import 'package:ezan_vakitleri/views/select_town.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../models/mystate.dart';

class SelectState extends StatefulWidget {
  const SelectState({super.key});

  @override
  State<SelectState> createState() => _SelectStateState();
}

class _SelectStateState extends State<SelectState> {
  late Future<MyState> futureCountry;
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    int id = box.read('countryId');

    return Scaffold(
      appBar: AppBar(
        title: const Text('ŞEHİR SEÇ'),
      ),
      body: FutureBuilder<List<MyState>>(
        future: ApiServices().getStates(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].name.toString()),
                    onTap: () {
                      box.write('stateId', snapshot.data![index].id);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const SelectTown()));
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
