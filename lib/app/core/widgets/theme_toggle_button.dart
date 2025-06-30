import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return RotationTransition(
              turns: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },
          child: IconButton(
            key: ValueKey(controller.isDarkMode),
            onPressed: () {
              controller.toggleTheme();
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                controller.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                key: ValueKey(controller.isDarkMode),
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
            tooltip: controller.isDarkMode ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
          ),
        );
      },
    );
  }
} 