import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

class AnalyticsService {
  AnalyticsService._();
  static final instance = AnalyticsService._();
  FirebaseAnalytics? _analytics;

  Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) await Firebase.initializeApp();
      _analytics = FirebaseAnalytics.instance;
    } catch (_) { _analytics = null; }
  }

  Future<void> log(String name, [Map<String, Object>? parameters]) async {
    try { await _analytics?.logEvent(name: name, parameters: parameters); } catch (_) {}
  }

  Future<void> viewWaterSchedule() => log('view_water_schedule');
  Future<void> viewPharmacies() => log('view_pharmacies');
  Future<void> emergencyCall(String department) => log('emergency_call', {'department': department});
  Future<void> adClicked(String advertiser) => log('ad_clicked', {'advertiser': advertiser});
  Future<void> viewLostFound() => log('view_lost_found');
  Future<void> viewLostPost(String id) => log('view_lost_post', {'post_id': id});
  Future<void> viewFoundPost(String id) => log('view_found_post', {'post_id': id});
  Future<void> lostFoundContactClicked(String id) => log('lost_found_contact_clicked', {'post_id': id});
}
