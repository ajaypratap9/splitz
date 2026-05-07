import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../core/config/supabase_config.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  // Handle background message
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);
    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _local.initialize(settings, onDidReceiveNotificationResponse: _onNotificationTap);

    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_handleForeground);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);
  }

  static void _handleForeground(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    _local.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails('splitz_channel', 'Splitz Notifications', channelDescription: 'Expense and group notifications', importance: Importance.high, priority: Priority.high, icon: '@mipmap/ic_launcher'),
        iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
      ),
      payload: message.data['route'],
    );
  }

  static void _handleTap(RemoteMessage message) {
    // Navigate based on message.data
  }

  static void _onNotificationTap(NotificationResponse response) {
    // Navigate based on response.payload
  }

  static Future<void> registerToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      final userId = SupabaseConfig.client.auth.currentUser?.id;
      if (userId != null) {
        await SupabaseConfig.client.from('profiles').update({'fcm_token': token}).eq('id', userId);
      }
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      final uid = SupabaseConfig.client.auth.currentUser?.id;
      if (uid != null) {
        await SupabaseConfig.client.from('profiles').update({'fcm_token': newToken}).eq('id', uid);
      }
    });
  }
}
