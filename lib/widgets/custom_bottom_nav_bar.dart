import 'package:flutter/material.dart';
import 'dart:ui'; // Import for ImageFilter

class CustomBottomNavBar extends StatelessWidget {
  final ValueNotifier<int> selectedIndex;
  const CustomBottomNavBar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withAlpha(51), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25), // Subtle shadow
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ValueListenableBuilder(
              valueListenable: selectedIndex,
              builder: (context, currentIndex, _) {
                return BottomNavigationBar(
                  backgroundColor: Colors.transparent, // Already transparent
                  elevation: 0, // Already removed default elevation
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white.withAlpha(153),
                  currentIndex: currentIndex,
                  onTap: (index) => selectedIndex.value = index,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined, size: 26),
                      label: 'Dashboard',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.location_on, size: 26),
                      label: 'Location',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline, size: 26),
                      label: 'Profile',
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
