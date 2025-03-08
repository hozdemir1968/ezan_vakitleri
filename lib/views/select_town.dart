import 'package:ezan_vakitleri/models/mytown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/mylocation.dart';
import '../services/api_service.dart';
import '../services/db_service.dart';

class SelectTown extends StatefulWidget {
  final int stateId;
  const SelectTown({super.key, required this.stateId});

  static const routeName = '/selecttown';

  @override
  State<SelectTown> createState() => _SelectTownState();
}

class _SelectTownState extends State<SelectTown> {
  final apiService = ApiService();
  List<MyTown> data = [];
  bool isLoading = true;
  final box = GetStorage();
  final dbService = DBService();

  @override
  void initState() {
    super.initState();
    fetchData(widget.stateId);
  }

  Future<void> fetchData(int stateId) async {
    data = await apiService.getTowns(stateId);
    setState(() {
      data.isNotEmpty ? isLoading = false : isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('bolge_sec'.tr), centerTitle: true),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index].name.toString()),
                    onTap: () async {
                      await box.write('townId', data[index].id);
                      await box.write('townName', data[index].name);
                      await box.write('saveDate', '');
                      MyLocation model = MyLocation(
                        townId: data[index].id,
                        townName: data[index].name,
                      );
                      await dbService.deleteLocationsBy(model.townId!);
                      await dbService.deletePrayTimesBy(model.townId!);
                      await dbService.insertLocation(model);
                      if (!context.mounted) return;
                      Navigator.pushNamed(context, '/');
                    },
                  );
                },
              ),
    );
  }
}
