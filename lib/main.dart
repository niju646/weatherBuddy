import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_buddy/providers/auth_providers.dart';
// import 'package:weather_buddy/screens/dashboard_screen.dart';
import 'package:weather_buddy/providers/weather_provider.dart';
import 'package:weather_buddy/router/router_config.dart';
// import 'package:weather_buddy/screens/onboarding.dart';

main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // home: DashboardScreen(),
      // home: StartupPage(),
      routerConfig: MyAppRouter().router,
    );
  }
}
