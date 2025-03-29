import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../components/statics.dart';
import '../models/mycountry.dart';
import '../models/mystate.dart';
import '../models/mytown.dart';
import '../models/mypraytime.dart';
import '../models/praytimes_vm.dart';
import '../models/sunriseset_m.dart';
import '../models/sunriseset_v_m.dart';

class ApiService {
  Future<List<MyCountry>> getCountries() async {
    final response = await http.get(Uri.parse(baseUrl + countriesUrl));
    if (response.statusCode == 200) {
      final List result = json.decode(utf8.decode(response.bodyBytes));
      var data = result.map((e) => MyCountry.fromJson(e)).toList();
      final MyCountry first = data.first;
      data.removeWhere((item) => item.code == "NORTH CYPRUS");
      data.add(first);
      return data;
    } else {
      throw ('Bir sorun oluştu ${response.statusCode}');
    }
  }

  Future<List<MyState>> getStates(int countryId) async {
    final response = await http.post(
      Uri.parse(baseUrl + statesUrl),
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
      Uri.parse(baseUrl + townsUrl),
      body: json.encode({'stateId': stateId.toString()}),
    );
    if (response.statusCode == 200) {
      final List result = json.decode(utf8.decode(response.bodyBytes));
      return result.map((e) => MyTown.fromJson(e)).toList();
    } else {
      throw ('Bir sorun oluştu ${response.statusCode}');
    }
  }

  Future<List<MyPraytime>> getPrayTimes(int townId) async {
    final response = await http.post(
      Uri.parse(baseUrl + prayertimeUrl),
      body: json.encode({'townId': townId.toString()}),
    );
    if (response.statusCode == 200) {
      final List result = json.decode(utf8.decode(response.bodyBytes));
      return result.map((e) => MyPraytime.fromJson(e)).toList();
    } else {
      throw ('Bir sorun oluştu ${response.statusCode}');
    }
  }

  Future<DailyVM> getDaily() async {
    final response = await http.get(Uri.parse(baseUrl + dailyUrl));
    if (response.statusCode == 200) {
      final result = json.decode(utf8.decode(response.bodyBytes));
      final result2 = DailyVM.fromMap(result);
      return result2;
    } else {
      throw ('Bir sorun oluştu ${response.statusCode}');
    }
  }

  //Sunrise sunset
  Future<SunrisesetM> getSunriseSunset(SunrisesetVM model) async {
    Map<String, dynamic> params = {
      'lat': model.lat,
      'lng': model.lng,
      'date': DateFormat.yMd().format(model.date!),
      'formatted': model.formatted,
    };
    var uri = Uri(
      scheme: 'https',
      host: 'api.sunrise-sunset.org',
      path: '/json',
      queryParameters: params,
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return SunrisesetM.fromJson(result);
    } else {
      throw ('Bir sorun oluştu ${response.statusCode}');
    }
  }
}
