



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../states/app_controller.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AppController>(
      builder: (app) => AnimatedSwitcher(
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        duration: const Duration(seconds: 1),
        child: IconButton(
            icon: app.isDarkMode.value
                ? const Icon(
                    Icons.dark_mode,
                    key: Key("dark"),
                    color: Colors.grey,
                  )
                : const Icon(
                    Icons.light_mode,
                    key: Key("light"),
                    color: Colors.grey,
                  ),
            onPressed: () {
              app.isDarkMode.value
                  ? app.setDarkMode(false)
                  : app.setDarkMode(true);
            }),
      ),
    );
  }
}
