// CommonWidget (TextField)
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_buddy/providers/auth_providers.dart';

class CommonWidget extends StatelessWidget {
  final String name;
  final bool isbool;
  final TextEditingController controller;
  const CommonWidget({
    super.key,
    required this.name,
    required this.controller,
    this.isbool = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, visiblityprovider, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: TextFormField(
              controller: controller,
              obscureText: isbool ? !visiblityprovider.isVisible : false,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: name,
                hintStyle: TextStyle(color: Colors.white.withAlpha(153)),
                filled: true,
                fillColor: Colors.white.withAlpha(25),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white.withAlpha(51),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white.withAlpha(204),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixIcon: isbool
                    ? IconButton(
                        onPressed: () {
                          Provider.of<AuthProvider>(
                            context,
                            listen: false,
                          ).visiblity();
                        },
                        icon: Icon(
                          visiblityprovider.isVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white.withAlpha(204),
                        ),
                      )
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
