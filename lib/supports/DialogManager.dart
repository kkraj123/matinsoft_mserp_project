import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';

class DialogManager {
  static void showVerificationWarningDialog({
    String title = "Info",
    String description = "Information",
    required VoidCallback onOkPressed,
  }) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/error_img.png",
                height: 50,
                width: 50,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 15),
              Text(
                title ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.colorWhite,
                ),
              ),
              const SizedBox(height: 15),
              Text(description ?? '', style: Get.textTheme.bodyMedium),
              TextButton(
                onPressed: () {
                  // Navigator.pop(Get.context!);
                  Get.back();
                  onOkPressed();
                  // Navigator.pushNamed(
                  //     NavigationService.navigatorKey.currentContext!,
                  //     RouteConstants.otpVerification);
                },
                child: const Text("ok"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void accessTokenExpiredDialog() {
    showAccessTokenExpiredDialog(
      callback: () {
        /* Get.dialog(const Dialog(
        child: LoginDialog(),
      ));*/
        // Get.offAll(() => LoginScreen());
      },
    );
  }

  void showAccessTokenExpiredDialog({
    String title = "Error",
    String description = "Error found",
    required VoidCallback callback,
  }) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/error_img.png",
                height: 50,
                width: 50,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 15),
              Text(title ?? '', style: Get.textTheme.headlineSmall),
              const SizedBox(height: 15),
              Text(description ?? "", style: Get.textTheme.bodyMedium),
              TextButton(
                onPressed: () {
                  callback();
                  Get.back(); //close the dialog
                },
                child: Text("Ok"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void closeDialog() {
    if (Get.isDialogOpen != null) {
      if (Get.isDialogOpen!) {
        Get.back();
      }
    }
  }

  static showErrorDialog(String message, String title, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: AppColors.colorWhite,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30), // Space for the circle
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.colorBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text(
                            "Yes",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: -32.5,
                child: Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFFFFF), Color(0xFF878484)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: CircleAvatar(
                        radius: 33,
                        backgroundImage: AssetImage(
                          "assets/icons/app_icon.png",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showInternetDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: AppColors.colorWhite,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30), // Space for the circle
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          "Internet Connection",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.colorBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text(
                            "Yes",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: -32.5,
                child: Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFB800), Color(0xFFFFA000)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        "Image",
                        style: TextStyle(color: AppColors.colorWhite),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> doLoginDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Force user to choose
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Please login to continue using all features and save your cart.",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const LoginScreen()),
              // );
            },
            child: const Text("Login", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  static Future<bool> showExitDialog(
    BuildContext context,
    ThemeProvider themeProvider,
  ) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: themeProvider.isDarkMode
                ? AppColors.darkPrimaryLightColor
                : AppColors.colorWhite,
            title: Text(
              'Exit App',
              style: TextStyle(
                fontSize: 20,
                color: themeProvider.isDarkMode
                    ? AppColors.colorWhite
                    : Colors.black,
                fontStyle: FontStyle.normal,
              ),
            ),
            content: Text(
              'Do you really want to exit the app?',
              style: TextStyle(
                fontSize: 16,
                color: themeProvider.isDarkMode
                    ? AppColors.colorWhite
                    : Colors.black45,
                fontStyle: FontStyle.normal,
              ),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Stay',
                  style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? AppColors.colorWhite
                        : AppColors.colorBlack,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  SystemNavigator.pop();
                },
                child: Text(
                  'Exit',
                  style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? AppColors.colorWhite
                        : AppColors.colorBlack,
                  ),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ) ??
        false;
  }

  static Future<bool> logoutDialog(
    BuildContext context,
    ThemeProvider themeProvider,
  ) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: themeProvider.isDarkMode ? AppColors.darkPrimaryLightColor : AppColors.colorWhite,
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 20,
                color: themeProvider.isDarkMode ? AppColors.colorWhite : Colors.black,
                fontStyle: FontStyle.normal,
              ),
            ),
            content: Text(
              'Do you really want to logout?',
              style: TextStyle(
                fontSize: 16,
                color: themeProvider.isDarkMode ? AppColors.colorWhite : Colors.black45,
                fontStyle: FontStyle.normal,
              ),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No', style: TextStyle(color: themeProvider.isDarkMode ? AppColors.colorWhite : AppColors.colorBlack),),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Logout', style: TextStyle(color: themeProvider.isDarkMode ? AppColors.colorWhite : AppColors.colorBlack)),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ) ??
        false;
  }
}
