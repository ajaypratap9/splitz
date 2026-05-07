import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/env.dart';
import 'core/config/supabase_config.dart';
import 'core/config/firebase_config.dart';
import 'shared/services/notification_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Load environment variables
  await Env.load();

  // Initialize Core Services
  await SupabaseConfig.initialize();
  await FirebaseConfig.initialize();
  await NotificationService.initialize();

  // Register for Push Notifications
  await NotificationService.registerToken();

  runApp(
    const ProviderScope(
      child: SplitzApp(),
    ),
  );
}
