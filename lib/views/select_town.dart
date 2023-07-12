import 'package:ezan_vakitleri/providers/providers.dart';
import 'package:ezan_vakitleri/views/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

class SelectTown extends ConsumerWidget {
  final int stateId;
  SelectTown({super.key, required this.stateId});
  final storageService = StorageService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final townData = ref.watch(getTownsProvider(stateId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('İLÇE SEÇ'),
      ),
      body: townData.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index].name.toString()),
                onTap: () {
                  storageService.writeToStorage('townId', data[index].id);
                  storageService.writeToStorage('townName', data[index].name);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const Splash()));
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
