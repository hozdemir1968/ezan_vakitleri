import 'package:ezan_vakitleri/models/mycountry.dart';
import 'package:ezan_vakitleri/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../services/db_services.dart';
import 'select_state.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry({super.key});

  @override
  State<SelectCountry> createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  var apiServices = ApiServices();

  late Future<MyCountry> futureCountry;
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    DbServices().deleteAllData();
    box.erase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ÜLKE SEÇ'),
      ),
      body: FutureBuilder<List<MyCountry>>(
        future: apiServices.getCountries(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].name.toString()),
                    onTap: () {
                      box.write('countryId', snapshot.data![index].id);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const SelectState()));
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
