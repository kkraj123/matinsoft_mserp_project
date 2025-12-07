import 'package:flutter/material.dart';
import 'package:mserp/customeDesigns/custom_app_bar.dart';
import 'package:mserp/screens/dashboard_screen/dashboard_screen.dart';
import 'package:mserp/screens/home_screen/home_screen.dart';
import 'package:mserp/screens/seetings_screen/setting_screen.dart';
import 'package:mserp/supports/DialogManager.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:mserp/widget/drawer_widget.dart';
import 'package:provider/provider.dart';

class CircularBottomNavBar extends StatefulWidget {
  const CircularBottomNavBar({super.key});

  @override
  State<CircularBottomNavBar> createState() => _CircularBottomNavBarState();
}

class _CircularBottomNavBarState extends State<CircularBottomNavBar> {
  int _selectedIndex = 2;
  final GlobalKey<HomeScreenState> homeKey = GlobalKey<HomeScreenState>();
  late List<Widget> _pages;

  final List<String> iconPath = [
    "assets/icons/dashboard.png",
    "assets/icons/calendar.png",
    "assets/icons/matinsoft_logo.png",
    "assets/icons/notification.png",
    "assets/icons/profile.png",
  ];


  @override
  void initState() {
    super.initState();
    _pages = [
      const DashboardScreen(),
      const Center(child: Text("Calender Screen")),
      HomeScreen(key: homeKey),
      const Center(child: Text("Notification Screen")),
      const SettingView(),
    ];

  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return WillPopScope(
      onWillPop: () => DialogManager.showExitDialog(context, themeProvider),
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        drawer: getDrawerView(context, themeProvider),
        appBar:CustomAppBar(
          onClick: () {
            if (_selectedIndex == 2) {
              homeKey.currentState?.onAppBarButtonClick();
            }
          },
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            color: themeProvider.isDarkMode ? AppColors.darkPrimaryLightColor : AppColors.colorWhite,
            boxShadow:const [
               BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset:  Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(iconPath.length, (index) {
              final bool isSelected = _selectedIndex == index;
              final bool isHome = index == 2;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isHome
                        ? (isSelected ? Theme.of(context).primaryColor.withAlpha(75) : Colors.transparent)
                        : (isSelected ? Theme.of(context).primaryColor : Colors.transparent),
                  ),
                  child: Image.asset(
                    iconPath[index],
                    color: isHome
                        ? null
                        : (isSelected ? Colors.white : themeProvider.isDarkMode ? AppColors.colorWhite.withAlpha(75) : Colors.black.withAlpha(200)),
                    width:index == 4 ? 35 : 28,
                    height:index == 4 ? 35 : 28,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
