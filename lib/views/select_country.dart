import 'package:ezan_vakitleri/db_helper/db_controller.dart';
import 'package:ezan_vakitleri/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'select_state.dart';

class SelectCountry extends ConsumerWidget {
  SelectCountry({super.key});
  final dbController = DbController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dbController.deleteAllData();
    final countryData = ref.watch(getCountriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ÜLKE SEÇ'),
      ),
      body: countryData.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index].name.toString()),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectState(countryId: data[index].id!)));
                },
              );
            },
          );
        },
        error: (error, s) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
