import 'package:flutter/material.dart';
import 'package:weather_buddy/screens/dashboard_screen.dart';
import 'package:weather_buddy/screens/profile.dart';
import 'package:weather_buddy/screens/searchby_location.dart';
import 'package:weather_buddy/widgets/custom_bottom_Nav_bar.dart';

class HomeScreen extends StatelessWidget {
  final List<Widget> pages = [DashboardScreen(), SearchbyLocation(), Profile()];
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
  
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: selectedIndex,
            builder: (context, index, _) {
              return pages[index];
            },
          ),

          Positioned(
            left: 24,
            right: 24,
            bottom: 20,
            child: CustomBottomNavBar(selectedIndex: selectedIndex),
          ),
        ],
      ),
      // bottomNavigationBar: CustomBottomNavBar(selectedIndex: selectedIndex),
    );
  }
}
