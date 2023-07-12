import 'package:ezan_vakitleri/models/prayertime.dart';
import 'db_repository.dart';

class DbController {
  final DbRepository _repository = DbRepository();

  saveData(Prayertime prayertime) async {
    return await _repository.insertData('prayertimes', prayertime.toMap());
  }

  readAllData() async {
    return await _repository.readAllData('prayertimes');
  }

  updateData(Prayertime prayertime) async {
    return await _repository.updateData('prayertimes', prayertime.toMap());
  }

  deleteData(id) async {
    return await _repository.deleteDataById('prayertimes', id);
  }

  deleteAllData() async {
    return await _repository.deleteAllData('prayertimes');
  }
}
