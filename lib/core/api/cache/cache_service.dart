// // lib/core/cache/cache_service.dart
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:quotes_app/data/model/quote_model.dart';

// class CacheService {
//   static const String _quotesKey = 'cached_quotes';
//   static const String _lastUpdateKey = 'quotes_last_update';

//   final SharedPreferences _prefs;

//   CacheService(this._prefs);

//   // Save quotes
//   Future<void> cacheQuotes(List<QuoteModel> quotes) async {
//     final jsonList = quotes.map((q) => q.toJson()).toList();
//     await _prefs.setString(_quotesKey, jsonEncode(jsonList));
//     await _prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
//   }

//   // Retrieve cached quotes
//   List<QuoteModel>? getCachedQuotes() {
//     final jsonString = _prefs.getString(_quotesKey);
//     if (jsonString == null) return null;

//     try {
//       final List<dynamic> jsonList = jsonDecode(jsonString);
//       return jsonList.map((json) => QuoteModel.fromJson(json)).toList();
//     } catch (e) {
//       return null;
//     }
//   }

//   // Get last update time
//   DateTime? getLastUpdateTime() {
//     final timeString = _prefs.getString(_lastUpdateKey);
//     if (timeString == null) return null;
//     return DateTime.tryParse(timeString);
//   }

//   // Clear cache
//   Future<void> clearCache() async {
//     await _prefs.remove(_quotesKey);
//     await _prefs.remove(_lastUpdateKey);
//   }
// }
