import 'package:ezan_vakitleri/models/mycountry.dart';
import 'package:ezan_vakitleri/models/mystate.dart';
import 'package:ezan_vakitleri/models/mytown.dart';
import 'package:ezan_vakitleri/models/prayertime.dart';
import 'package:ezan_vakitleri/services/db_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

final getCountriesProvider = FutureProvider<List<MyCountry>>((ref) async {
  return ref.read(apiServiceProvider).getCountries();
});

final getStatesProvider =
    FutureProvider.family<List<MyState>, int>((ref, countryId) async {
  return ref.read(apiServiceProvider).getStates(countryId);
});

final getTownsProvider = FutureProvider.family<List<MyTown>, int>((ref, stateId) async {
  return ref.read(apiServiceProvider).getTowns(stateId);
});

final getPrayerTimesProvider =
    FutureProvider.family<List<Prayertime>, int>((ref, townId) async {
  return ref.read(apiServiceProvider).getPrayerTimes(townId);
});

final getLocalPrayerTimesProvider = FutureProvider<List<Prayertime>>((ref) async {
  return ref.read(dbServiceProvider).getLocalData();
});
