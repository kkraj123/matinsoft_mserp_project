import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mserp/themes/app_cololors.dart';


class Utility {
  static Future<bool> showExitDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                backgroundColor: AppColors.colorWhite,
                title: Text(
                  'Exit App',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                content: Text(
                  'Do you really want to exit the app?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black45,
                    fontStyle: FontStyle.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('Stay'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      SystemNavigator.pop();
                    },
                    child: Text('Exit'),
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
        ) ??
        false;
  }

  static Future<bool> LogoutDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        backgroundColor: AppColors.colorWhite,
        title: Text(
          'Logout',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontStyle: FontStyle.normal,
          ),
        ),
        content: Text(
          'Do you really want to logout?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black45,
            fontStyle: FontStyle.normal,
          ),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ) ??
        false;
  }
  // static Future<bool> requestNotificationPermission() async {
  //   if (Platform.isAndroid) {
  //     PermissionStatus status = await Permission.notification.request();
  //     return status.isGranted;
  //   }
  //   // iOS permission is handled automatically via FirebaseMessaging.requestPermission()
  //   return true;
  // }
  // static String formatDate(String? dateTime) {
  //   if (dateTime == null || dateTime.isEmpty) {
  //     return "-";
  //   }
  //
  //   try {
  //     DateTime dt = DateTime.parse(dateTime);
  //
  //     // Convert UTC to Nepal Time (UTC+5:45)
  //     DateTime nepalTime = dt.add(const Duration(hours: 5, minutes: 45));
  //
  //     // Format the Nepal time
  //     return DateFormat('dd MMM yyyy, hh:mm a').format(nepalTime);
  //   } catch (e) {
  //     return dateTime; // fallback to original string if parsing fails
  //   }
  // }
  // static Future<String> generateDeviceToken() async {
  //   final deviceInfo = DeviceInfoPlugin();
  //   final androidInfo = await deviceInfo.androidInfo;
  //   return androidInfo.id;
  // }
}
