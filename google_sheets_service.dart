import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/load_state.dart';
import '../models/ad_model.dart';
import '../models/emergency_model.dart';
import '../models/lost_found_model.dart';
import '../models/pharmacy_model.dart';
import '../models/water_model.dart';

class GoogleSheetsService {
  GoogleSheetsService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  // Replace ONLY these URLs with your real Google Apps Script/API endpoints.
  static const waterUrl = 'https://example.com/api/water';
  static const pharmaciesUrl = 'https://example.com/api/pharmacies';
  static const emergencyUrl = 'https://example.com/api/emergency';
  static const adsUrl = 'https://example.com/api/ads';
  static const lostFoundUrl = 'https://example.com/api/lost-found';

  Future<LoadState<List<WaterModel>>> fetchWater() => _fetchList(url: waterUrl, cacheKey: 'cache_water', parser: WaterModel.fromJson);
  Future<LoadState<List<PharmacyModel>>> fetchPharmacies() => _fetchList(url: pharmaciesUrl, cacheKey: 'cache_pharmacies', parser: PharmacyModel.fromJson);
  Future<LoadState<List<EmergencyModel>>> fetchEmergency() => _fetchList(url: emergencyUrl, cacheKey: 'cache_emergency', parser: EmergencyModel.fromJson);
  Future<LoadState<List<AdModel>>> fetchAds() => _fetchList(url: adsUrl, cacheKey: 'cache_ads', parser: AdModel.fromJson);
  Future<LoadState<List<LostFoundModel>>> fetchLostFound() async {
    final result = await _fetchList(url: lostFoundUrl, cacheKey: 'cache_lost_found', parser: LostFoundModel.fromJson);
    final data = result.data;
    if (data != null) data.sort((a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)).compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)));
    return result;
  }

  Future<LoadState<List<T>>> _fetchList<T>({required String url, required String cacheKey, required T Function(Map<String, dynamic>) parser}) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await _client.get(Uri.parse(url)).timeout(const Duration(seconds: 12));
      if (response.statusCode < 200 || response.statusCode >= 300) throw Exception('HTTP ${response.statusCode}');
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      final rawList = decoded is List ? decoded : (decoded is Map<String, dynamic> && decoded['data'] is List ? decoded['data'] as List : null);
      if (rawList == null) throw const FormatException('Expected a JSON array or {data: []}.');
      final normalized = rawList.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
      final items = normalized.map(parser).toList();
      await prefs.setString(cacheKey, jsonEncode(normalized));
      return items.isEmpty ? LoadState.empty() : LoadState.success(items);
    } catch (_) {
      final cached = prefs.getString(cacheKey);
      if (cached != null && cached.isNotEmpty) {
        try {
          final list = (jsonDecode(cached) as List).whereType<Map>().map((e) => parser(Map<String, dynamic>.from(e))).toList();
          return list.isEmpty ? LoadState.empty(isCached: true) : LoadState.success(list, isCached: true);
        } catch (_) {}
      }
      return LoadState.error('تعذر جلب البيانات. تحقق من الاتصال ثم أعد المحاولة.');
    }
  }

  Future<String?> getSavedNeighborhood() async => (await SharedPreferences.getInstance()).getString('selected_neighborhood');
  Future<void> saveNeighborhood(String value) async => (await SharedPreferences.getInstance()).setString('selected_neighborhood', value);
}
