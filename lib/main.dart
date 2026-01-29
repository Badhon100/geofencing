import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geofencing/core/di/injection_container.dart';
import 'package:geofencing/core/providers.dart/bloc_providers.dart';
import 'package:geofencing/core/services/connectivity_service.dart';
import 'package:geofencing/core/services/notifications_service.dart';
import 'package:geofencing/features/home/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/services/background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Dependency.init();
  await initializeBackgroundService();
  await NotificationService.init();
  InternetMonitor().start();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: BlocProviders.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          textTheme: TextTheme(
            headlineLarge: GoogleFonts.merriweather(
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: GoogleFonts.inter(),
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}
