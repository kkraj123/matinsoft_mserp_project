import 'package:flutter/material.dart';
import 'package:mserp/screens/authentication_view/login_screen/login_screen.dart';
import 'package:mserp/screens/onboarding/onboarding_screen.dart';
import 'package:mserp/supports/NetworkListioner.dart';
import 'package:mserp/supports/share_preference_manager.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/text_sizes.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:mserp/widget/circuler_bottom_navigation.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child:const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<OverlayState> overlayKey = GlobalKey<OverlayState>();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.currentMode,
          home:const SplashScreen(),
          builder: (context, child){
            return Overlay(
              key: overlayKey,
              initialEntries: [
                OverlayEntry(
                  builder: (context) => NetworkListener(
                    child: child!,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _MySplashPageState();
}

class _MySplashPageState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      _checkOnboardingStatus();
    });
  }

  Future<void> _checkOnboardingStatus() async {
    bool hasSeenOnboarding = await SharedPreferenceManager.getFirstCallOnboarding();
    if (!hasSeenOnboarding) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>const OnboardingScreen()),
      );
      return;
    }
    final userOAuth = await SharedPreferenceManager.getOAuth();
    if(userOAuth != null){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>const CircularBottomNavBar()
        ),
      );
    }else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder:
                (context) =>const LoginScreen()
        ),
      );
    }

  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkPrimaryColor : Theme.of(context).primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration:const BoxDecoration(
              color: AppColors.colorWhite
            ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/icons/mserplogo.png", width: 120, height: 50),
              )),
          const Align(
            alignment: Alignment.center,
            child: Text(
              "Welcome to MSERP",
              style: TextStyle(
                fontSize: AppTextSizes.extraLarge,
                color: AppColors.colorWhite,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const CircularProgressIndicator(backgroundColor: Colors.white,),
        ],
      ),
    );
  }
}
