import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geofencing/core/services/background_service.dart';

class HomeCubit extends Cubit<bool> {
  StreamSubscription<ServiceStatus>? _gpsStatusSubscription;

  HomeCubit() : super(false) {
    _checkService();
    _listenToGpsStatus();
  }

  /// Stop the monitoring
  void stopMonitoring() {
    FlutterBackgroundService().invoke('stopService');
    emit(false);
  }

  /// Start monitoring - returns true if successful, false if GPS is disabled
  Future<bool> startMonitoring() async {
    // Check if GPS is enabled first
    final isGpsEnabled = await Geolocator.isLocationServiceEnabled();
    
    if (!isGpsEnabled) {
      return false;
    }

    await initializeBackgroundService();
    emit(true);
    return true;
  }

  Future<void> _checkService() async {
    // Check both background service and GPS status
    final isRunning = await FlutterBackgroundService().isRunning();
    final isGpsEnabled = await Geolocator.isLocationServiceEnabled();
    
    // Only emit true if both service is running AND GPS is enabled
    emit(isRunning && isGpsEnabled);
  }

  /// Listen to GPS status changes and auto-disable monitoring when GPS turns off
  void _listenToGpsStatus() {
    _gpsStatusSubscription = Geolocator.getServiceStatusStream().listen((status) {
      if (status == ServiceStatus.disabled) {
        // GPS was turned off, automatically stop monitoring
        if (state) {
          stopMonitoring();
        }
      }
    });
  }

  @override
  Future<void> close() {
    _gpsStatusSubscription?.cancel();
    return super.close();
  }
}
