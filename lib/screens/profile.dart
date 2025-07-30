import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weather_buddy/providers/auth_providers.dart';
import 'package:weather_buddy/router/router_constants.dart';
import 'package:weather_buddy/widgets/common_button.dart';
import 'dart:ui'; // Import for ImageFilter

class Profile extends StatelessWidget {
  const Profile({super.key});

  Future<Map<String, String?>> _getUserData() async {
    const storage = FlutterSecureStorage();
    final username = await storage.read(key: 'username');
    final email = await storage.read(key: 'email');
    return {'username': username, 'email': email};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, String?>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading profile",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          final data = snapshot.data!;
          final username = data['username'] ?? 'N/A';
          final email = data['email'] ?? 'N/A';

          return Container(
            constraints:
                const BoxConstraints.expand(), // Fill the entire screen
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E3A8A), // Darker blue
                  Color(0xFF1E40AF),
                  Color(0xFF3B82F6),
                  Color(0xFF60A5FA), // Lighter blue
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 40.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Your Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PermanentMarker',
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        shadows: [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(2, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(25),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.white.withAlpha(51),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white.withAlpha(50),
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white.withAlpha(200),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                email,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 40),
                              SizedBox(
                                width: double.infinity,
                                child: CommonButton(
                                  buttonname: 'Logout',
                                  onPressed: () {
                                    context.read<AuthProvider>().logout();
                                    GoRouter.of(
                                      context,
                                    ).pushNamed(MyAppConstants().loginRoute);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        content: const Text(
                                          "Logout successfully",
                                        ),
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          93,
                                          163,
                                          95,
                                        ).withAlpha(204),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 40),
                              SizedBox(
                                width: double.infinity,
                                child: CommonButton(
                                  buttonname: 'contact us',
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
