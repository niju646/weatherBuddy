import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weather_buddy/providers/auth_providers.dart';
import 'package:weather_buddy/router/router_constants.dart';
import 'package:weather_buddy/widgets/common_button.dart';

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
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading profile"));
          }

          final data = snapshot.data!;
          final username = data['username'] ?? 'N/A';
          final email = data['email'] ?? 'N/A';

          return Container(
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
            child: Center(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: SingleChildScrollView(
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
                        SizedBox(height: 20),
                        Text(
                          username,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 30),
                        CommonButton(
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
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                content: Text("Logout successfully"),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
          // ),
        },
        future: _getUserData(),
      ),
      // body: Container(
      //   decoration: const BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topLeft,
      //       end: Alignment.bottomRight,
      //       colors: [
      //         Color(0xFF1E3A8A), // Darker blue
      //         Color(0xFF1E40AF),
      //         Color(0xFF3B82F6),
      //         Color(0xFF60A5FA), // Lighter blue
      //       ],
      //     ),
      //   ),
      //   child: Center(
      //     child: SafeArea(
      //       child: Padding(
      //         padding: EdgeInsets.all(16),
      //         child: SingleChildScrollView(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               CircleAvatar(
      //                 radius: 60,
      //                 backgroundColor: Colors.white.withAlpha(50),
      //                 child: Icon(
      //                   Icons.person,
      //                   size: 60,
      //                   color: Colors.white.withAlpha(200),
      //                 ),
      //               ),
      //               SizedBox(height: 20),
      //               Text(
      //                 'example@gmail.com',
      //                 style: TextStyle(
      //                   color: Colors.white,
      //                   fontWeight: FontWeight.w500,
      //                   fontSize: 20,
      //                 ),
      //               ),
      //               SizedBox(height: 30),
      //               CommonButton(
      //                 buttonname: 'Logout',
      //                 onPressed: () {
      //                   context.read<AuthProvider>().logout();
      //                   GoRouter.of(
      //                     context,
      //                   ).pushNamed(MyAppConstants().loginRoute);
      //                   ScaffoldMessenger.of(context).showSnackBar(
      //                     SnackBar(
      //                       behavior: SnackBarBehavior.floating,
      //                       margin: const EdgeInsets.symmetric(
      //                         horizontal: 20,
      //                         vertical: 10,
      //                       ),
      //                       shape: RoundedRectangleBorder(
      //                         borderRadius: BorderRadius.circular(16),
      //                       ),
      //                       content: Text("Logout successfully"),
      //                       backgroundColor: const Color.fromARGB(
      //                         255,
      //                         93,
      //                         163,
      //                         95,
      //                       ).withAlpha(204),
      //                     ),
      //                   );
      //                 },
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
