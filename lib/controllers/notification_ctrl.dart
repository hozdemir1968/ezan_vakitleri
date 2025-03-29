import '../models/notification_m.dart';
import '../services/db_service.dart';

class NotificationCtrl {
  final DBService dbService = DBService();

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
}
