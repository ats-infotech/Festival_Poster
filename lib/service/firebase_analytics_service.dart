import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';

// class FirebaseAnalyticsService {
//   static final instance = FirebaseAnalyticsService._();
//   FirebaseAnalyticsService._();

//   Future<void> logEvent(
//       {required String name, required Map<String, Object> parameters}) async {
//     await FirebaseAnalytics.instance
//         .logEvent(name: name, parameters: parameters);
//   }
// }

class FirebaseAnalyticsService {
  static final instance = FirebaseAnalyticsService._();
  FirebaseAnalyticsService._();

  Future<void> logEvent({
    required String name,
    required Map<String, Object> parameters,
  }) async {
    try {
      await FirebaseAnalytics.instance
          .logEvent(
        name: name,
        parameters: parameters,
      )
          .then(
        (value) {
          log("✅ Firebase logEvent success: name=$name, parameters=$parameters");
        },
      );
    } catch (e) {
      log("❌ Firebase logEvent FAILED: $e");
    }
  }
}
