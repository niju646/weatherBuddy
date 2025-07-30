import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weather_buddy/providers/auth_providers.dart';
import 'package:weather_buddy/router/router_constants.dart';
// import 'package:weather_buddy/screens/dashboard_screen.dart';
// import 'package:weather_buddy/screens/signup_screen.dart';
import 'dart:ui';

import 'package:weather_buddy/widgets/common_button.dart';
import 'package:weather_buddy/widgets/common_textfield.dart'; // Import for ImageFilter

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usernamecontroller = TextEditingController();
    final passwordcontroller = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3A8A), // Darker blue
              Color(0xFF1E40AF),
              Color(0xFF3B82F6),
              Color(0xFF60A5FA),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25), // 10% opacity
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withAlpha(51), // 20% opacity
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontFamily: 'PermanentMarker',
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Login to your account',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withAlpha(204), // 80% opacity
                          ),
                        ),
                        const SizedBox(height: 32),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'username',
                            style: TextStyle(
                              color: Colors.white.withAlpha(204), // 80% opacity
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        CommonWidget(
                          name: "username",
                          controller: usernamecontroller,
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.white.withAlpha(204), // 80% opacity
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        CommonWidget(
                          name: "Password",
                          controller: passwordcontroller,
                          isbool: true,
                        ),
                        const SizedBox(height: 32),
                        CommonButton(
                          buttonname: 'Login',
                          onPressed: () {
                            // Replace with your actual login logic
                            // if (passwordcontroller.text.isNotEmpty &&
                            //     emailcontroller.text.isNotEmpty) {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => DashboardScreen(),
                            //   ),
                            // );
                            context
                                .read<AuthProvider>()
                                .loginAuth(
                                  usernamecontroller.text.trim(),
                                  passwordcontroller.text.trim(),
                                )
                                .then((success) {
                                  if (success) {
                                    GoRouter.of(
                                      context,
                                    ).pushNamed(MyAppConstants().homeRoute);
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
                                        content: Text("Login Successfull"),
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          93,
                                          163,
                                          95,
                                        ).withAlpha(204),
                                      ),
                                    );
                                  } else {
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
                                        content: Text("Invalid Login"),
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          201,
                                          79,
                                          71,
                                        ).withAlpha(204),
                                      ),
                                    );
                                  }
                                });
                          },
                          // },
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => SignupScreen(),
                            //   ),
                            // );
                            GoRouter.of(
                              context,
                            ).pushNamed(MyAppConstants().signUpRoute);
                          },
                          child: Text.rich(
                            TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.white.withAlpha(
                                  178,
                                ), // 70% opacity
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
