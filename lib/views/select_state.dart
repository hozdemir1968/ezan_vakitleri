import 'package:ezan_vakitleri/views/select_town.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

class SelectState extends ConsumerWidget {
  final int countryId;
  const SelectState({super.key, required this.countryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateData = ref.watch(getStatesProvider(countryId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('ŞEHİR SEÇ'),
      ),
      body: stateData.when(
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
                          builder: (context) => SelectTown(
                                stateId: data[index].id!,
                              )));
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
