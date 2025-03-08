import 'package:ezan_vakitleri/models/mycountry.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry({super.key});

  static const routeName = '/selectcountry';

  @override
  State<SelectCountry> createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  final apiService = ApiService();
  List<MyCountry> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    data = await apiService.getCountries();
    setState(() {
      data.isNotEmpty ? isLoading = false : isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ulke_sec'.tr), centerTitle: true),
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
                        '/selectstate',
                        arguments: {'countryId': data[index].id!},
                      );
                    },
                  );
                },
              ),
    );
  }
}
