
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mserp/screens/leave_request_screen/MyLeaveStatusScreen.dart';
import 'package:mserp/screens/leave_request_screen/leave_request_screen.dart';
import 'package:mserp/screens/time_leave_request/time_leave_request_screen.dart';
import 'package:mserp/screens/time_leave_request/time_leave_scree.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';

Widget getDrawerView(BuildContext context, ThemeProvider themeProvider) {
  final isDark = themeProvider.isDarkMode;
  return Drawer(
    backgroundColor: isDark ? AppColors.darkPrimaryLightColor : AppColors.colorWhite,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    child: SafeArea(
      child: Column(
        children: [
          Stack(
            children: [
              Container(height: 200, width: double.infinity, color: Theme.of(context).primaryColor.withOpacity(0.9)),
              const Positioned(
                top: 30,
                left: 20,
                child: Column(
                  children: [
                     ClipRRect(
                      child: CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person, color: AppColors.colorWhite, size: 40,),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "MSERP",
                      style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                      textScaler: TextScaler.linear(1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),


          const SizedBox(height: 30),

          const Align(
            alignment: Alignment.center,
            child: Center(
              child: Text(
                "App Version : 1.0.1",
                style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                textScaler: TextScaler.linear(1),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}