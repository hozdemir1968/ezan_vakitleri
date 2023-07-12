import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>(
  (ref) => DarkModeNotifier(),
);

class DarkModeNotifier extends StateNotifier<bool> {
  final box = GetStorage();

  DarkModeNotifier() : super(false) {
    initTheme();
  }

  Future initTheme() async {
    var isDarkMode = box.read('isDarkMode');
    state = isDarkMode ?? false;
  }

  void toggle() {
    state = !state;
    box.write('isDarkMode', state);
  }
}
