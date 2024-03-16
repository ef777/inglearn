import 'package:shared_preferences/shared_preferences.dart';

class SpinController {
  static const String SPIN_KEY = 'spin_count';
  static const String LAST_SPIN_DATE_KEY = 'last_spin_date';

  Future<int> getSpinCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SPIN_KEY) ?? 0;
  }

  Future<String?> getLastSpinDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(LAST_SPIN_DATE_KEY);
  }

  Future<void> increaseSpinCount() async {
    final prefs = await SharedPreferences.getInstance();
    int currentSpinCount = prefs.getInt(SPIN_KEY) ?? 0;
    String currentDate = DateTime.now().toIso8601String();

    if (currentSpinCount < 2) {
      await prefs.setInt(SPIN_KEY, currentSpinCount + 1);
      await prefs.setString(LAST_SPIN_DATE_KEY, currentDate);
    }
  }

  Future<void> resetSpinCountIfNewDay() async {
    final prefs = await SharedPreferences.getInstance();
    String? lastSpinDateStr = prefs.getString(LAST_SPIN_DATE_KEY);
    if (lastSpinDateStr != null) {
      DateTime lastSpinDate = DateTime.parse(lastSpinDateStr);
      DateTime currentDate = DateTime.now();
      if (lastSpinDate.day != currentDate.day) {
        await prefs.setInt(SPIN_KEY, 0);
      }
    }
  }
}
