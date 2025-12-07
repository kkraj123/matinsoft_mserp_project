import 'package:flutter/material.dart';
import 'package:mserp/customeDesigns/custom_toolbar.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkPrimaryColor
          : AppColors.colorWhite,
      appBar: const CustomToolbar(title: "Default Screen"),
      body: Center(
        child: Text(
          "Default Screen",
          style: TextStyle(
            color: isDark
                ? AppColors.colorWhite
                : Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
