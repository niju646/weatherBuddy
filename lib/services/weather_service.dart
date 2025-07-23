import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import 'package:weather_buddy/model/weather_model.dart';
// import 'weather_model.dart';

class WeatherService {
  static final Dio dio = Dio();
  static final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  static Future<List<WeatherData>> fetchWeather({DateTime? startDate, DateTime? endDate}) async {
    try {
      developer.log(
        "fetchWeather() called${startDate != null ? ' for ${dateFormat.format(startDate)} to ${dateFormat.format(endDate!)}' : ''}",
        name: 'WeatherService',
      );

      final queryParameters = {
        'api_key': 'HBDRBS3B3PDAHTLU',
        'results': 100,
        if (startDate != null && endDate != null) ...{
          'start': dateFormat.format(startDate),
          'end': dateFormat.format(endDate),
        },
      };

      final response = await dio.get(
        'https://api.thingspeak.com/channels/2929062/feeds.json',
        queryParameters: queryParameters,
      );

      developer.log("Response received: ${response.data['feeds'].length} entries", name: 'WeatherService');

      final List<dynamic> feeds = response.data['feeds'] ?? [];
      if (feeds.isNotEmpty) {
        return feeds
            .map((entry) => WeatherData.fromJson(entry as Map<String, dynamic>))
            .where((data) => data.createdAt != null)
            .toList();
      } else {
        developer.log("No weather data available", name: 'WeatherService');
        return [];
      }
    } catch (e, stackTrace) {
      developer.log("fetchWeather() error: $e\n$stackTrace", name: 'WeatherService');
      return [];
    }
  }
}



// import 'package:dio/dio.dart';
// import 'package:weather_buddy/model/weather_model.dart';

// class WeatherService {
//   static final Dio dio = Dio(
//     BaseOptions(
//       baseUrl: "https://",
//     )
//   );

//    static Future<WeatherData> fetchWeather(String date) async {
//     final response = await dio.get("/weather", queryParameters: {"date": date});
//     return WeatherData.fromJson(response.data);
//   }

// static Future<Map<String, List<Map<String, dynamic>>>> fetchGraphData(String date) async {
//   final response = await dio.get("/grap", queryParameters: {"date": date});
//   final Map<String, dynamic> rawData = response.data;

//   return rawData.map((key, value) {
//     return MapEntry(
//       key,
//       List<Map<String, dynamic>>.from(value),
//     );
//   });
// }

  
// }