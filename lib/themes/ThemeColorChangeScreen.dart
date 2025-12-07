
import 'package:dooz_color_picker/dooz_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:mserp/customeDesigns/custom_toolbar.dart';
import 'package:mserp/screens/seetings_screen/setting_screen.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeColorChangeScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  const ThemeColorChangeScreen({super.key, required this.themeProvider});

  @override
  State<ThemeColorChangeScreen> createState() => _ThemeColorChangeScreenState();
}

class _ThemeColorChangeScreenState extends State<ThemeColorChangeScreen> {
  Color? pickerColor;

  @override
  void initState() {
    super.initState();
    pickerColor = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkPrimaryColor
          : AppColors.colorWhite,
      appBar: const CustomToolbar(title: "Theme Setting"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: widget.themeProvider.currentMode == ThemeMode.dark
                ? AppColors.darkPrimaryLightColor
                : Theme.of(context).primaryColor.withAlpha(90),
          ),
          width: double.infinity,
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Light/Dark Mode",
                      style: TextStyle(
                        color: widget.themeProvider.currentMode == ThemeMode.dark
                            ? AppColors.colorWhite
                            : AppColors.colorBlack,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaler: const TextScaler.linear(1),
                    ),
                    const CustomThemeToggle(),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Choose Your Theme Colour",
                    style: TextStyle(
                      color: widget.themeProvider.currentMode == ThemeMode.dark
                          ? AppColors.colorWhite
                          : AppColors.colorBlack,
                      fontWeight: FontWeight.bold,
                    ),
                    textScaler: const TextScaler.linear(1),
                  ),
                ),
                const SizedBox(height: 10),
                CircleColorPicker(
                  radius: 70,
                  thumbRadius: 15,
                  initialColor: Provider.of<ThemeProvider>(
                    context,
                    listen: false,
                  ).primaryColor,
                  child: Text(
                    pickerColor != null
                        ? '#${pickerColor!.value.toRadixString(16).padLeft(8, '0').toUpperCase()}'
                        : '',
                    style: TextStyle(color: pickerColor ?? Colors.black),
                  ),
                  colorListener: (Color value) {
                    setState(() {
                      pickerColor = value;
                    });
                    Provider.of<ThemeProvider>(
                      context,
                      listen: false,
                    ).setPrimaryColor(value);
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Set Default Theme",
                      style: TextStyle(
                        color: widget.themeProvider.isDarkMode
                            ? AppColors.colorWhite
                            : AppColors.colorBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Provider.of<ThemeProvider>(
                          context,
                          listen: false,
                        ).setPrimaryColor(AppColors.primaryColor);
                      },
                      child: Container(
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.primaryColor,
                        ),
                        child: const Center(
                          child: Text(
                            "0xFF71291D",
                            style: TextStyle(color: AppColors.colorWhite),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
