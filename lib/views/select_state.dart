import 'package:ezan_vakitleri/models/mystate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class SelectState extends StatefulWidget {
  final int countryId;
  const SelectState({super.key, required this.countryId});

  static const routeName = '/selectstate';

  @override
  State<SelectState> createState() => _SelectStateState();
}

class _SelectStateState extends State<SelectState> {
  final apiService = ApiService();
  List<MyState> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData(widget.countryId);
  }

  Future<void> fetchData(int countryId) async {
    data = await apiService.getStates(countryId);
    setState(() {
      data.isNotEmpty ? isLoading = false : isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('sehir_sec'.tr), centerTitle: true),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index].name.toString()),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/selecttown',
                        arguments: {'stateId': data[index].id!},
                      );
                    },
                  );
                },
              ),
    );
  }
}
