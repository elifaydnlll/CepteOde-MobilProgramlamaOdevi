import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_screen.dart';
import 'subscription_list_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const SubscriptionListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFFC71626);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF161618),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: brandColor.withValues(alpha: 0.2),
            labelTextStyle: MaterialStateProperty.all(
              GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[400],
              ),
            ),
          ),
          child: NavigationBar(
            height: 70,
            backgroundColor: const Color(0xFF161618),
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            indicatorColor: brandColor,
            elevation: 0,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined, color: Colors.grey),
                selectedIcon: Icon(Icons.dashboard, color: Colors.white),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.list_alt, color: Colors.grey),
                selectedIcon: Icon(Icons.list, color: Colors.white),
                label: 'Subscriptions',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline, color: Colors.grey),
                selectedIcon: Icon(Icons.person, color: Colors.white),
                label: 'User',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
