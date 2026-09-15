import 'package:shared_preferences/shared_preferences.dart';

class TrialService {
  static const int trialDurationDays = 7;
  static const String _firstLaunchKey = 'sathi_trial_first_launch_ms';
  static const String _unlockedKey = 'sathi_premium_unlocked';

  static Future<Map<String, dynamic>> checkTrialStatus() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(_unlockedKey) == true) {
      return {'isTrialActive': true, 'daysRemaining': trialDurationDays, 'isUnlocked': true};
    }

    var firstLaunchMs = prefs.getInt(_firstLaunchKey);
    if (firstLaunchMs == null) {
      firstLaunchMs = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt(_firstLaunchKey, firstLaunchMs);
    }

    final firstLaunch = DateTime.fromMillisecondsSinceEpoch(firstLaunchMs);
    final now = DateTime.now();
    final elapsed = now.difference(firstLaunch);
    final remaining = trialDurationDays - elapsed.inDays;
    final active = remaining > 0;

    return {
      'isTrialActive': active,
      'daysRemaining': active ? remaining : 0,
      'isUnlocked': true,
    };
  }

  static Future<void> unlockPremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_unlockedKey, true);
  }

  static Future<void> resetTrialForDevelopment() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_firstLaunchKey);
    await prefs.remove(_unlockedKey);
  }
}
