import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirhal/features/history/ride_history.dart';
import 'package:tirhal/features/home/home_screen.dart';
import 'package:tirhal/features/profile/profile_screen.dart';
import 'package:tirhal/core/provider/navigation_provider.dart';
import 'package:tirhal/widgets/custom_button.dart';

class MainScreen extends StatelessWidget {
  final List<Widget> screens = [
    HomeScreen(),
    RideHistoryScreen(),
    ProfileScreen(),
  ];

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      body: screens[navigationProvider.currentIndex],
      bottomNavigationBar: CustomNavBar(),
    );
  }
}
