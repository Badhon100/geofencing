import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetMonitor {
  static final InternetMonitor _instance = InternetMonitor._internal();
  factory InternetMonitor() => _instance;
  InternetMonitor._internal();

  StreamSubscription? _connectivitySub;
  bool _wasOffline = false;

  void start() {
    _connectivitySub = Connectivity().onConnectivityChanged.listen(
      (_) => _checkInternet(),
    );

    // Initial check on app start
    _checkInternet();
  }

  Future<void> _checkInternet() async {
    final hasInternet = await InternetConnection().hasInternetAccess;

    if (!hasInternet && !_wasOffline) {
      _wasOffline = true;

      Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }

    if (hasInternet && _wasOffline) {
      _wasOffline = false;

      Fluttertoast.showToast(
        msg: "Back Online",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void dispose() {
    _connectivitySub?.cancel();
  }
}
