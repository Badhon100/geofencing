import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geofencing/core/services/background_service.dart';

class HomeCubit extends Cubit<bool> {
  HomeCubit() : super(true) {
    _checkService();
  }

  /// Stop the monitoring
  void stopMonitoring() {
    FlutterBackgroundService().invoke('stopService');
    emit(false);
  }

  Future<void> startMonitoring() async {
    await initializeBackgroundService();
    emit(true);
  }

  Future<void> _checkService() async {
    final isRunning = await FlutterBackgroundService().isRunning();
    emit(isRunning);
  }
}
