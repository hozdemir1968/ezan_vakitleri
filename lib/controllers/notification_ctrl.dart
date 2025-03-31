import 'package:ezan_vakitleri/controllers/praytimes_ctrl.dart';
import 'package:get/get.dart';
import '../models/notification_m.dart';
import '../models/praytimes_vm.dart';
import '../services/db_service.dart';
import '../services/notification_service.dart';

class NotificationCtrl {
  final DBService dbService = DBService();
  List<NotificationM> notificationList = [];

  Future<List<NotificationM>> loadSettings() async {
    List<NotificationM> savedNotifications = await dbService.getNotifications();
    savedNotifications.isNotEmpty
        ? savedNotifications
        : savedNotifications = List.generate(
          6,
          (i) => NotificationM(id: i, setted: false, timeInMinutes: 0),
        );
    return savedNotifications;
  }

  Future<void> saveSettings(List<NotificationM> notificationList) async {
    await dbService.deleteNotifications();
    for (final notification in notificationList) {
      await dbService.insertNotification(notification);
    }
  }

  Future<void> setNotifications() async {
    final vakits = [
      'imsak'.tr,
      'gunes'.tr,
      'oglen'.tr,
      'ikindi'.tr,
      'aksam'.tr,
      'yatsi'.tr,
    ];
    List<PraytimesVM> praytimesVMList = await PraytimesCtrl().getPraytimesVMList();
    notificationList = await loadSettings();
    NotificationService.cancelNotifications();
    for (var i = 0; i < 6; i++) {
      if (notificationList[i].setted!) {
        DateTime scheduledDate = praytimesVMList[0].praytimes![i].add(
          Duration(minutes: notificationList[i].timeInMinutes!),
        );
        print(scheduledDate.toString());
        NotificationService.scheduleNotification(
          i,
          'Ezan Vakti',
          '${vakits[i]} Vakti Yaklaşıyor!',
          scheduledDate,
        );
      }
    }
  }
}
