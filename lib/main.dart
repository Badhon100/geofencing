import 'package:flutter/material.dart';
import 'package:geofencing/core/services/connectivity_service.dart';
import 'package:geofencing/core/services/notifiations_service.dart';
import 'package:geofencing/features/home/pages/home_page.dart';
import 'core/services/background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeBackgroundService();
  await NotificationService.init();
  InternetMonitor().start();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
