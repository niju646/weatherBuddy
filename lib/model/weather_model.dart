class WeatherData {
  final DateTime? createdAt;
  final String? field1; // Temperature (°C)
  final String? field2; // Humidity (%)
  final String? field3; // Pressure (Pa)
  final String? field4; // Wind Speed (km/h)
  final String? field5; // Rain Level (mm)
  final String? field6; // UV Intensity (mW/cm²)

  WeatherData({
    this.createdAt,
    this.field1,
    this.field2,
    this.field3,
    this.field4,
    this.field5,
    this.field6,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      field1: json['field1']?.toString(),
      field2: json['field2']?.toString(),
      field3: json['field3']?.toString(),
      field4: json['field4']?.toString(),
      field5: json['field5']?.toString(),
      field6: json['field6']?.toString(),
    );
  }
}





// class WeatherData {
//   final double? temperature;
//   final double? humidity;
//   final double? windspeed;
//   final double? rainfall;
//   final double? pressure;
//   final double? uvrays;

//   WeatherData({
//     this.temperature,
//     this.humidity,
//     this.windspeed,
//     this.rainfall,
//     this.pressure,
//     this.uvrays,
//   });

//   factory WeatherData.fromJson(Map<String, dynamic> json) {
//     return WeatherData(
//       temperature: double.tryParse(json['field1'] ?? ''),
//       humidity: double.tryParse(json['field2'] ?? ''),
//       windspeed: double.tryParse(json['field3'] ?? ''),
//       rainfall: double.tryParse(json['field4'] ?? ''),
//       pressure: double.tryParse(json['field5'] ?? ''),
//       uvrays: double.tryParse(json['field6'] ?? ''),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'field1': temperature?.toString(),
//       'field2': humidity?.toString(),
//       'field3': windspeed?.toString(),
//       'field4': rainfall?.toString(),
//       'field5': pressure?.toString(),
//       'field6': uvrays?.toString(),
//     };
//   }
// }



// class WeatherData {
//     late final double? temperature;
//     late final double? humidity;
//     late final double? windspeed;
//     late final double? rainfall;
//     late final double? pressure;
//     late final double? uvrays;

//     WeatherData({
//       this.temperature,
//       this.humidity,
//       this.windspeed,
//       this.rainfall,
//       this.pressure,
//       this.uvrays,
//     });

//       factory WeatherData.fromJson(Map<String, dynamic> json) {
//     return WeatherData(
//       temperature: json['temperature']?.toDouble(),
//       humidity: json['humidity']?.toDouble(),
//       windspeed: json['windSpeed']?.toDouble(),
//       rainfall: json['rainfall']?.toDouble(),
//       pressure: json['pressure']?.toDouble(),
//       uvrays: json['uvRays']?.toDouble(),
//     );
//   }

//    Map<String, dynamic> toJson() {
//     return {
//       'temperature': temperature,
//       'humidity': humidity,
//       'windSpeed': windspeed,
//       'rainfall': rainfall,
//       'pressure': pressure,
//       'uvRays': uvrays,
//     };
//   }
    
// }

