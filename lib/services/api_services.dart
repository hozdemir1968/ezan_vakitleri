import 'dart:convert';
import '../models/mycountry.dart';
import '../models/mystate.dart';
import '../models/mytown.dart';
import '../models/prayertime.dart';
import '../statics/static_values.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  Future<List<MyCountry>> getCountries() async {
    final response = await http.get(Uri.parse(StaticValues.countriesUrl));
    if (response.statusCode == 200) {
      final List result = json.decode(utf8.decode(response.bodyBytes));
      return result.map((e) => MyCountry.fromJson(e)).toList();
    } else {
      throw ('Bir sorun oluştu ${response.statusCode}');
    }
  }

  Future<List<MyState>> getStates(int countryId) async {
    final response = await http.post(
      Uri.parse(StaticValues.statesUrl),
      body: json.encode({'countryId': countryId.toString()}),
    );
    if (response.statusCode == 200) {
      final List result = json.decode(utf8.decode(response.bodyBytes));
      return result.map((e) => MyState.fromJson(e)).toList();
    } else {
      throw ('Bir sorun oluştu ${response.statusCode}');
    }
  }

  Future<List<MyTown>> getTowns(int stateId) async {
    final response = await http.post(
      Uri.parse(StaticValues.townsUrl),
      body: json.encode({'stateId': stateId.toString()}),
    );
    if (response.statusCode == 200) {
      final List result = json.decode(utf8.decode(response.bodyBytes));
      return result.map((e) => MyTown.fromJson(e)).toList();
    } else {
      throw ('Bir sorun oluştu ${response.statusCode}');
    }
  }

  Future<List<PrayerTime>> getPrayerTimes(int townId) async {
    final response = await http.post(
      Uri.parse(StaticValues.prayertimeUrl),
      body: json.encode({'townId': townId.toString()}),
    );
    if (response.statusCode == 200) {
      final List result = json.decode(utf8.decode(response.bodyBytes));
      return result.map((e) => PrayerTime.fromJson(e)).toList();
    } else {
      throw ('Bir sorun oluştu ${response.statusCode}');
    }
  }
}
