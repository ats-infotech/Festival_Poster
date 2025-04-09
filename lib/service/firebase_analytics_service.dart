import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  static final instance = FirebaseAnalyticsService._();
  FirebaseAnalyticsService._();

  Future<void> logEvent(
      {required String name, required Map<String, Object?> parameters}) async {
    await FirebaseAnalytics.instance
        .logEvent(name: name, parameters: parameters);
  }
}
