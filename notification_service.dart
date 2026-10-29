import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings();
    await _plugin.initialize(settings: const InitializationSettings(android: android, iOS: darwin));
    await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    await _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<bool> scheduleWaterReminder({required String neighborhood, required DateTime arrivalAt}) async {
    final notifyAt = arrivalAt.subtract(const Duration(hours: 8));
    if (!notifyAt.isAfter(DateTime.now())) return false;
    const details = NotificationDetails(
      android: AndroidNotificationDetails('water_reminders', 'تنبيهات المياه', channelDescription: 'تنبيه قبل وصول المياه بثماني ساعات', importance: Importance.high, priority: Priority.high),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.zonedSchedule(
      id: neighborhood.hashCode & 0x7fffffff,
      title: 'موعد المياه في جيرود',
      body: 'متبقي 8 ساعات على الموعد المسجل لحي $neighborhood.',
      scheduledDate: tz.TZDateTime.from(notifyAt, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: neighborhood,
    );
    return true;
  }
}
