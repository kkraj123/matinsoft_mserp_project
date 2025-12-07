import 'package:flutter/material.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/strings.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkPrimaryColor : AppColors.colorWhite,
      body:const Center(
        child: Text("Dashboard Screen"),
      )
    );
  }
}

