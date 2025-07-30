import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weather_buddy/providers/auth_providers.dart';
import 'package:weather_buddy/router/router_constants.dart';
// import 'package:weather_buddy/screens/dashboard_screen.dart';
// import 'package:weather_buddy/screens/login_screen.dart';
import 'package:weather_buddy/widgets/common_button.dart';
import 'package:weather_buddy/widgets/common_textfield.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final namecontroller = TextEditingController();
    final emailcontroller = TextEditingController();
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
                          ' Lets go!',
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
                          'Create an account',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withAlpha(204), // 80% opacity
                          ),
                        ),
                        const SizedBox(height: 32),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Username',
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
                          controller: namecontroller,
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.white.withAlpha(204), // 80% opacity
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        CommonWidget(
                          name: "Email",
                          controller: emailcontroller,
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
                          buttonname: 'SignUp',
                          onPressed: () async {
                            final authProvider = context.read<AuthProvider>();

                            await authProvider.signupAuth(
                              namecontroller.text.trim(),
                              emailcontroller.text.trim(),
                              passwordcontroller.text.trim(),
                            );

                            if (authProvider.isLoggedin) {
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
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  content: Text("Signup Successful"),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    93,
                                    163,
                                    95,
                                  ).withAlpha(204),
                                ),
                              );
                            } else {
                              final error =
                                  authProvider.error ?? "Signup failed";
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  content: Text(error),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    201,
                                    79,
                                    71,
                                  ).withAlpha(204),
                                ),
                              );
                            }
                          },
                          // onPressed: () async {
                          //   // Replace with your actual login logic
                          //   // if (passwordcontroller.text.isNotEmpty &&
                          //   //     namecontroller.text.isNotEmpty &&
                          //   //     emailcontroller.text.isNotEmpty) {
                          //   context.read<AuthProvider>().signupAuth(
                          //     namecontroller.text.trim(),
                          //     emailcontroller.text.trim(),
                          //     passwordcontroller.text.trim(),
                          //   );
                          //   final isLoggedIn = context
                          //       .read<AuthProvider>()
                          //       .isLoggedin;
                          //   if (isLoggedIn) {
                          //     GoRouter.of(
                          //       context,
                          //     ).pushNamed(MyAppConstants().homeRoute);
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       SnackBar(
                          //         behavior: SnackBarBehavior.floating,
                          //         margin: const EdgeInsets.symmetric(
                          //           horizontal: 20,
                          //           vertical: 10,
                          //         ),
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(16),
                          //         ),
                          //         content: Text("Login Successfull"),
                          //         backgroundColor: Color.fromARGB(
                          //           255,
                          //           93,
                          //           163,
                          //           95,
                          //         ).withAlpha(204),
                          //       ),
                          //     );
                          //   } else {
                          //     final error =
                          //         context.read<AuthProvider>().error ??
                          //         "Signup failed";
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       SnackBar(
                          //         behavior: SnackBarBehavior.floating,
                          //         margin: const EdgeInsets.symmetric(
                          //           horizontal: 20,
                          //           vertical: 10,
                          //         ),
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(16),
                          //         ),
                          //         content: Text(error),
                          //         backgroundColor: Color.fromARGB(
                          //           255,
                          //           201,
                          //           79,
                          //           71,
                          //         ).withAlpha(204),
                          //       ),
                          //     );
                          //   }
                          //   // }
                          // },
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => LoginScreen(),
                            //   ),
                            // );

                            GoRouter.of(
                              context,
                            ).pushNamed(MyAppConstants().loginRoute);
                          },
                          child: Text.rich(
                            TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                color: Colors.white.withAlpha(
                                  178,
                                ), // 70% opacity
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: "Login",
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
