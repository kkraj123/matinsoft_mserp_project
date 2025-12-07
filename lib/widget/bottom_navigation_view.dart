import 'package:flutter/material.dart';
import 'package:mserp/customeDesigns/custom_app_bar.dart';
import 'package:mserp/screens/dashboard_screen/dashboard_screen.dart';
import 'package:mserp/themes/app_cololors.dart';

class BottomNavigationView extends StatefulWidget {
  const BottomNavigationView({super.key});

  @override
  State<BottomNavigationView> createState() => _BottomNavExampleState();
}

class _BottomNavExampleState extends State<BottomNavigationView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(),
    const Center(child: Text("Dashboard Screen")),

    const Center(child: Text("Profile Screen")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      appBar: CustomAppBar(),
      body: _pages[_currentIndex],

      bottomNavigationBar:  Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.colorWhite,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
