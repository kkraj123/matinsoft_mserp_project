import 'package:flutter/material.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomToolbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomToolbar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkPrimaryColor : AppColors.colorWhite,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 25,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: isDark
                            ? AppColors.colorWhite
                            : Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 20,
                        color: isDark
                            ? AppColors.colorWhite
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20, width: 20),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.colorWhite
                    : Theme.of(context).primaryColor,
              ),
              textScaler:const TextScaler.linear(1),
            ),
          ],
        ),
      ),
    );
  }
}
