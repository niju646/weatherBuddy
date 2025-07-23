import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_buddy/model/weather_model.dart';
import 'package:weather_buddy/services/weather_service.dart';
// import 'weather_model.dart';
// import 'weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  List<WeatherData> dataList = [];
  bool isLoading = false;
  Timer? _timer;

  final Map<String, Map<DateTime, double>> _graphData = {
    'temperature': {},
    'humidity': {},
    'pressure': {},
    'windSpeed': {},
    'rainfall': {},
    'uvRays': {},
  };

  Map<String, Map<DateTime, double>> get graphData => _graphData;

  WeatherProvider() {
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      fetchData();
    });
    fetchData(); // Initial fetch
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchData({DateTime? selectedDate}) async {
    developer.log(
      "Provider fetchData() called${selectedDate != null ? ' for ${DateFormat('yyyy-MM-dd').format(selectedDate)}' : ''}",
      name: 'WeatherProvider',
    );

    isLoading = true;
    notifyListeners();

    try {
      // If selectedDate is provided, fetch data for that day
      DateTime? startDate;
      DateTime? endDate;
      if (selectedDate != null) {
        startDate = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        );
        endDate = startDate.add(const Duration(days: 1));
      }

      dataList = await WeatherService.fetchWeather(
        startDate: startDate,
        endDate: endDate,
      );
      developer.log(
        "Weather data fetched: ${dataList.length} entries",
        name: 'WeatherProvider',
      );

      if (dataList.isNotEmpty) {
        // Clear previous graph data for each metric
        _graphData.forEach((key, value) => value.clear());

        for (var data in dataList) {
          if (data.createdAt != null) {
            DateTime timestamp = data.createdAt!;
            // Validate and parse each field
            double? temp = double.tryParse(data.field1 ?? '0');
            double? humidity = double.tryParse(data.field2 ?? '0');
            double? pressure = double.tryParse(data.field3 ?? '0');
            double? windSpeed = double.tryParse(data.field4 ?? '0');
            double? rainfall = double.tryParse(data.field5 ?? '0');
            double? uvRays = double.tryParse(data.field6 ?? '0');

            if (temp != null && temp.isFinite) {
              _graphData['temperature'] = _appendToMap(
                _graphData['temperature']!,
                timestamp,
                temp,
              );
            }
            if (humidity != null && humidity.isFinite) {
              _graphData['humidity'] = _appendToMap(
                _graphData['humidity']!,
                timestamp,
                humidity.clamp(0, 100), // Clamp humidity to 0-100%
              );
            }
            if (pressure != null && pressure.isFinite) {
              _graphData['pressure'] = _appendToMap(
                _graphData['pressure']!,
                timestamp,
                pressure / 100, // Convert Pa to hPa
              );
            }
            if (windSpeed != null && windSpeed.isFinite) {
              _graphData['windSpeed'] = _appendToMap(
                _graphData['windSpeed']!,
                timestamp,
                windSpeed,
              );
            }
            if (rainfall != null && rainfall.isFinite) {
              _graphData['rainfall'] = _appendToMap(
                _graphData['rainfall']!,
                timestamp,
                rainfall,
              );
            }
            if (uvRays != null && uvRays.isFinite) {
              _graphData['uvRays'] = _appendToMap(
                _graphData['uvRays']!,
                timestamp,
                uvRays,
              );
            }
          }
        }
        developer.log(
          "Graph data updated: ${_graphData['temperature']}",
          name: 'WeatherProvider',
        );
      } else {
        developer.log("No valid data available", name: 'WeatherProvider');
      }
    } catch (e, stackTrace) {
      developer.log(
        "Error fetching weather data: $e\n$stackTrace",
        name: 'WeatherProvider',
      );
    }

    isLoading = false;
    notifyListeners();
  }

  Map<String, Map<DateTime, double>> getGraphDataForDate(DateTime date) {
    final filteredData = <String, Map<DateTime, double>>{};
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    for (var key in _graphData.keys) {
      filteredData[key] = Map<DateTime, double>.fromEntries(
        _graphData[key]!.entries.where(
          (entry) =>
              entry.key.isAfter(startOfDay) && entry.key.isBefore(endOfDay),
        ),
      );
      developer.log(
        "Filtered data for $key on ${DateFormat('yyyy-MM-dd').format(date)}: ${filteredData[key]}",
        name: 'WeatherProvider',
      );
    }
    return filteredData;
  }

  Map<DateTime, double> _appendToMap(
    Map<DateTime, double> map,
    DateTime timestamp,
    double value,
  ) {
    final result = Map<DateTime, double>.from(map);
    if (value.isFinite) {
      result[timestamp] = value;
      if (result.length > 10) {
        var oldest = result.keys.reduce((a, b) => a.isBefore(b) ? a : b);
        result.remove(oldest);
      }
    } else {
      developer.log(
        "Invalid value $value for timestamp $timestamp skipped",
        name: 'WeatherProvider',
      );
    }
    return result;
  }
}
