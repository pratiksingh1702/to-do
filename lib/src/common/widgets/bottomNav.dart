import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const CustomBottomNavBar({

    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? Theme.of(context).colorScheme.surface
        : Theme.of(context).scaffoldBackgroundColor;

    return SlidingClippedNavBar(
      backgroundColor: backgroundColor,
      onButtonPressed: onChanged,
      iconSize: 30,
      activeColor: Theme.of(context).colorScheme.primary,
      selectedIndex: selectedIndex,
      barItems: [
        BarItem(icon: Icons.home, title: 'Home'),
        BarItem(icon: Icons.auto_awesome_outlined, title: 'Pixi'),
        BarItem(icon: Icons.task_alt, title: 'Tasks'),
      ],
    );
  }
}
