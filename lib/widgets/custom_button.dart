import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/provider/navigation_provider.dart';
import '../core/localization/localization_extension.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    int currentIndex = navigationProvider.currentIndex;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 5,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(context, Icons.home, context.l10n.home, 0, currentIndex,
                navigationProvider),
            _navItem(context, Icons.history, context.l10n.rideHistory, 1,
                currentIndex, navigationProvider),
            _navItem(context, Icons.person, context.l10n.profile, 2,
                currentIndex, navigationProvider),
          ],
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, int index,
      int currentIndex, NavigationProvider provider) {
    bool isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => provider.changeIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive
                ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                : Theme.of(context)
                    .bottomNavigationBarTheme
                    .unselectedItemColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                  : Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
