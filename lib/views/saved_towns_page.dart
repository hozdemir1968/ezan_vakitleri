import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../models/mylocation.dart';
import '../services/db_service.dart';

class SavedTownsPage extends StatefulWidget {
  const SavedTownsPage({super.key});

  static const routeName = '/savedtownspage';

  @override
  State<SavedTownsPage> createState() => _SavedTownsPageState();
}

class _SavedTownsPageState extends State<SavedTownsPage> {
  final GetStorage box = GetStorage();
  final dbService = DBService();
  List<MyLocation> myLocationList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    myLocationList = await dbService.getLocations();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıtlı Bölgeler'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () => fetchData(),
        child:
            myLocationList.isEmpty
                ? const Center(child: Text('Kayıtlı bölge yok'))
                : ListView.builder(
                  itemCount: myLocationList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () async {
                          await box.write('townId', myLocationList[index].townId);
                          await box.write('townName', myLocationList[index].townName);
                          await box.write('saveDate', '');
                          if (!context.mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (Route<dynamic> route) => false,
                          );
                        },
                        onLongPress:
                            () => showDialog(
                              context: context,
                              builder:
                                  (BuildContext context) => AlertDialog(
                                    title: const Text('Dikkat !'),
                                    content: const Text('Silinsinmi !'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('HAYIR'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          if (index > 0) {
                                            await dbService.deleteLocationsBy(
                                              myLocationList[index].townId!,
                                            );
                                            myLocationList.removeAt(index);
                                            setState(() {});
                                            if (!context.mounted) return;
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text('EVET'),
                                      ),
                                    ],
                                  ),
                            ),
                        leading: Text(myLocationList[index].id.toString()),
                        title: Text(myLocationList[index].townName.toString()),
                        trailing: Text(myLocationList[index].townId.toString()),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await box.write('townId', -1);
          await box.write('townName', '');
          await box.write('saveDate', '');
          if (!context.mounted) return;
          Navigator.pushNamed(context, '/');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
