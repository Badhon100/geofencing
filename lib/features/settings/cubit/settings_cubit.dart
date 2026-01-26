import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsCubit extends Cubit<bool> {
  SettingsCubit() : super(false) {
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final box = await Hive.openBox('settings');
    final value = box.get('allow_cache', defaultValue: false);
    emit(value);
  }

  Future<void> toggleCache(bool value) async {
    final box = await Hive.openBox('settings');
    await box.put('allow_cache', value);

    if (!value) {
      final cacheBox = await Hive.openBox('historical_places_box');
      await cacheBox.clear(); // ✅ DO NOT delete box
    }

    emit(value);
  }

  /// 🔥 IMPORTANT: repository/usecase reads from here
  static Future<bool> getCachePreference() async {
    final box = await Hive.openBox('settings');
    return box.get('allow_cache', defaultValue: false);
  }
}
