import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();
  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async =>
      _notifications.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledDate, tz.local),
          await _notificationDetails(),
          payload: payload,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);

  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails("1", "reminder_add_entry"),
        iOS: DarwinNotificationDetails());
  }

  static Future init({bool initScheduled = false}) async {
    tz.initializeTimeZones();

    final androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosSetting = DarwinInitializationSettings();
    final settings =
        InitializationSettings(android: androidSetting, iOS: iosSetting);
    await _notifications.initialize(settings);
  }
}
