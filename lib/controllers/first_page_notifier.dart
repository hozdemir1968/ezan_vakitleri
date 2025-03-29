import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class FirstPageNotifier extends ValueNotifier<bool> {
  final box = GetStorage();

  FirstPageNotifier() : super(false) {
    initialize();
  }

  Future initialize() async {
    var isFirstPage = box.read('isFirstPage') ?? false;
    value = isFirstPage ?? false;
  }

  void toggle() {
    value = !value;
    box.write('isFirstPage', value);
  }
}
