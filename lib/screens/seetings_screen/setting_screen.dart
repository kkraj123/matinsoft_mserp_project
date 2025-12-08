import 'package:dooz_color_picker/dooz_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mserp/customeDesigns/custom_snackbar.dart';
import 'package:mserp/customeDesigns/no_data_found_screen.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/authentication_view/login_screen/login_screen.dart';
import 'package:mserp/screens/profile_screen/bloc/profile_bloc.dart';
import 'package:mserp/screens/profile_screen/model/ProfileResponse.dart';
import 'package:mserp/screens/profile_screen/profile_repo/profile_repository.dart';
import 'package:mserp/supports/DialogManager.dart';
import 'package:mserp/supports/LoadingDialog.dart';
import 'package:mserp/supports/share_preference_manager.dart';
import 'package:mserp/themes/ThemeColorChangeScreen.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ProfileBloc(profileRepository: ProfileRepository()),
          ),
        ],
        child: const SettingScreen(),
      ),
    );
  }
}

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  ProfileData? profileData;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfile());
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.currentMode == ThemeMode.dark
          ? AppColors.darkPrimaryColor
          : AppColors.colorWhite,
      body: SingleChildScrollView(
        reverse: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18, top: 20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: themeProvider.isDarkMode
                        ? AppColors.colorWhite
                        : Theme.of(context).primaryColor.withAlpha(90),
                  ),
                ),
                child: BlocListener<ProfileBloc, GlobalApiResponseState>(
                  listener: (context, state) async{
                    switch (state.status) {
                      case GlobalApiStatus.loading:
                        LoadingDialog.show(
                          context,
                          key: const ObjectKey("Profile loading....."),
                        );
                        break;
                      case GlobalApiStatus.completed:
                        LoadingDialog.hide(context);
                        if (state is ProfileStateSuccess) {
                          setState(() {
                            profileData = state.data.data;
                          });
                        }else if(state is LogoutStateSuccess){
                          showCustomSnackBar(
                            context,
                            backgroundColor: Colors.green,
                            message: state.data.message ?? "Logout",
                            icon: Icons.check,
                          );
                          await SharedPreferenceManager.clear();
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false,);
                        }
                        break;
                      default:
                        LoadingDialog.hide(context);
                    }
                  },
                  child: profileCardView(profileData, themeProvider.isDarkMode),
                ),
              ),
              const SizedBox(height: 20),
              personalInfoCardView(profileData, themeProvider.isDarkMode),
              const SizedBox(height: 20),
              accountCardView(themeProvider.isDarkMode),
              const SizedBox(height: 20),
              preferenceView(themeProvider.isDarkMode, themeProvider),
              const SizedBox(height: 20),
              buttonsView(themeProvider),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileCardView(profile, bool isDarkMode) {
    if (profile == null) {
      return const Center(
        child: SizedBox(
          height: 40,
          width: 40,
          child: CircularProgressIndicator(),
        ),
      );
    }

    final imageUrl = profile.pic ?? '';

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(
            height: 120,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade200,
                    child: ClipOval(
                      child: imageUrl.isEmpty
                          ?const Icon(Icons.person, size: 60,)/*Image.asset(
                              'assets/icons/profile.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )*/
                          : Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person, size: 60,);
                              },
                            ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 200,
                    height: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.name ?? "No Name",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? Colors.white
                                  : AppColors.colorBlack,
                            ),
                            textScaler: const TextScaler.linear(1.2),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            profile.email ?? "No Email",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: isDarkMode
                                  ? Colors.white
                                  : AppColors.colorBlack,
                            ),
                            textScaler: const TextScaler.linear(1),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 150,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                width: 1,
                                color: isDarkMode
                                    ? AppColors.colorWhite
                                    : Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Share Referral Code",
                                style: TextStyle(
                                  color: isDarkMode
                                      ? AppColors.colorWhite
                                      : AppColors.colorBlack,
                                ),
                                textScaler: const TextScaler.linear(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    "assets/icons/edit.png",
                    width: 30,
                    height: 30,
                    color: isDarkMode
                        ? AppColors.colorWhite
                        : Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.darkPrimaryLightColor
                        : AppColors.colorGray.withAlpha(100),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "42",
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.colorWhite
                              : AppColors.colorBlack,
                          fontWeight: FontWeight.bold,
                        ),
                        textScaler: const TextScaler.linear(1.3),
                      ),
                      Text(
                        "Project",
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.colorWhite
                              : AppColors.colorBlack,
                        ),
                        textScaler: const TextScaler.linear(1),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.darkPrimaryLightColor
                        : AppColors.colorGray.withAlpha(100),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "156",
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.colorWhite
                              : AppColors.colorBlack,
                          fontWeight: FontWeight.bold,
                        ),
                        textScaler: const TextScaler.linear(1.3),
                      ),
                      Text(
                        "Tasks",
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.colorWhite
                              : AppColors.colorBlack,
                        ),
                        textScaler: const TextScaler.linear(1),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.darkPrimaryLightColor
                        : AppColors.colorGray.withAlpha(100),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "198%",
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.colorWhite
                              : AppColors.colorBlack,
                          fontWeight: FontWeight.bold,
                        ),
                        textScaler: const TextScaler.linear(1.3),
                      ),
                      Text(
                        "Efficiency",
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.colorWhite
                              : AppColors.colorBlack,
                        ),
                        textScaler: const TextScaler.linear(1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget personalInfoCardView(ProfileData? profileData, bool isDark) {
    final email = profileData?.email ?? "Email";
    final phone = profileData?.phone ?? "Phone no is not available";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: isDark
              ? AppColors.colorWhite
              : Theme.of(context).primaryColor.withAlpha(90),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 30,
                      color: isDark
                          ? AppColors.colorWhite
                          : Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Personal Information",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.colorWhite
                            : Theme.of(context).primaryColor,
                      ),
                      textScaler: const TextScaler.linear(1.2),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark ? AppColors.colorWhite : AppColors.colorGray,
                ),
              ],
            ),
          ),
          Divider(
            color: isDark
                ? AppColors.colorWhite
                : Theme.of(context).primaryColor,
            thickness: 0.5,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 25,
                      color: isDark
                          ? AppColors.colorWhite
                          : AppColors.colorGray,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      email,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.colorWhite
                            : AppColors.colorGray,
                      ),
                      textScaler: const TextScaler.linear(1.2),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark ? AppColors.colorWhite : AppColors.colorGray,
                ),
              ],
            ),
          ),
          Divider(
            color: isDark
                ? AppColors.colorWhite
                : Theme.of(context).primaryColor,
            thickness: 0.5,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 25,
                      color: isDark
                          ? AppColors.colorWhite
                          : AppColors.colorGray,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      phone,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.colorWhite
                            : AppColors.colorGray,
                      ),
                      textScaler: const TextScaler.linear(1.2),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark ? AppColors.colorWhite : AppColors.colorGray,
                ),
              ],
            ),
          ),
          Divider(
            color: isDark
                ? AppColors.colorWhite
                : Theme.of(context).primaryColor,
            thickness: 0.5,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_outlined,
                      size: 25,
                      color: isDark
                          ? AppColors.colorWhite
                          : AppColors.colorGray,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Department",
                      style: TextStyle(
                        color: isDark
                            ? AppColors.colorWhite
                            : AppColors.colorGray,
                      ),
                      textScaler: const TextScaler.linear(1.2),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark ? AppColors.colorWhite : AppColors.colorGray,
                ),
              ],
            ),
          ),
          Divider(
            color: isDark
                ? AppColors.colorWhite
                : Theme.of(context).primaryColor,
            thickness: 0.5,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.join_full,
                      size: 25,
                      color: isDark
                          ? AppColors.colorWhite
                          : AppColors.colorGray,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Joined",
                      style: TextStyle(
                        color: isDark
                            ? AppColors.colorWhite
                            : AppColors.colorGray,
                      ),
                      textScaler: const TextScaler.linear(1.2),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark ? AppColors.colorWhite : AppColors.colorGray,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget accountCardView(bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: isDark
              ? AppColors.colorWhite
              : Theme.of(context).primaryColor.withAlpha(90),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.settings,
                      size: 30,
                      color: isDark
                          ? AppColors.colorWhite
                          : Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Account Settings",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.colorWhite
                            : Theme.of(context).primaryColor,
                      ),
                      textScaler: const TextScaler.linear(1.2),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark ? AppColors.colorWhite : AppColors.colorGray,
                ),
              ],
            ),
          ),
          Divider(
            color: isDark
                ? AppColors.colorWhite
                : Theme.of(context).primaryColor,
            thickness: 0.5,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lock,
                      size: 25,
                      color: isDark
                          ? AppColors.colorWhite
                          : AppColors.colorGray,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Change Password",
                      style: TextStyle(
                        color: isDark
                            ? AppColors.colorWhite
                            : AppColors.colorGray,
                      ),
                      textScaler: const TextScaler.linear(1.2),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark ? AppColors.colorWhite : AppColors.colorGray,
                ),
              ],
            ),
          ),
          Divider(
            color: isDark
                ? AppColors.colorWhite
                : Theme.of(context).primaryColor,
            thickness: 0.5,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.security,
                      size: 25,
                      color: isDark
                          ? AppColors.colorWhite
                          : AppColors.colorGray,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Two Factor Authentication",
                      style: TextStyle(
                        color: isDark
                            ? AppColors.colorWhite
                            : AppColors.colorGray,
                      ),
                      textScaler: const TextScaler.linear(1.2),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark ? AppColors.colorWhite : AppColors.colorGray,
                ),
              ],
            ),
          ),
          Divider(
            color: isDark
                ? AppColors.colorWhite
                : Theme.of(context).primaryColor,
            thickness: 0.5,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.key,
                      size: 25,
                      color: isDark
                          ? AppColors.colorWhite
                          : AppColors.colorGray,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Api key",
                      style: TextStyle(
                        color: isDark
                            ? AppColors.colorWhite
                            : AppColors.colorGray,
                      ),
                      textScaler: const TextScaler.linear(1.2),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark ? AppColors.colorWhite : AppColors.colorGray,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget preferenceView(bool isDark, ThemeProvider themeProvider) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: isDark
              ? AppColors.colorWhite
              : Theme.of(context).primaryColor.withAlpha(90),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.menu,
                      size: 30,
                      color: isDark
                          ? AppColors.colorWhite
                          : Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Preferences",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.colorWhite
                            : Theme.of(context).primaryColor,
                      ),
                      textScaler: const TextScaler.linear(1.2),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark ? AppColors.colorWhite : AppColors.colorGray,
                ),
              ],
            ),
          ),
          Divider(
            color: isDark
                ? AppColors.colorWhite
                : Theme.of(context).primaryColor,
            thickness: 0.5,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ThemeColorChangeScreen(themeProvider: themeProvider),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.dark_mode,
                        size: 25,
                        color: isDark
                            ? AppColors.colorWhite
                            : AppColors.colorGray,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Light/Dark Mode",
                        style: TextStyle(
                          color: isDark
                              ? AppColors.colorWhite
                              : AppColors.colorGray,
                        ),
                        textScaler: const TextScaler.linear(1.2),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: isDark ? AppColors.colorWhite : AppColors.colorGray,
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: isDark
                ? AppColors.colorWhite
                : Theme.of(context).primaryColor,
            thickness: 0.5,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.notification_important,
                      size: 25,
                      color: isDark
                          ? AppColors.colorWhite
                          : AppColors.colorGray,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Notification",
                      style: TextStyle(
                        color: isDark
                            ? AppColors.colorWhite
                            : AppColors.colorGray,
                      ),
                      textScaler: const TextScaler.linear(1.2),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark ? AppColors.colorWhite : AppColors.colorGray,
                ),
              ],
            ),
          ),
          Divider(
            color: isDark
                ? AppColors.colorWhite
                : Theme.of(context).primaryColor,
            thickness: 0.5,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.language,
                      size: 25,
                      color: isDark
                          ? AppColors.colorWhite
                          : AppColors.colorGray,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Language",
                      style: TextStyle(
                        color: isDark
                            ? AppColors.colorWhite
                            : AppColors.colorGray,
                      ),
                      textScaler: const TextScaler.linear(1.2),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark ? AppColors.colorWhite : AppColors.colorGray,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonsView(ThemeProvider themeProvider) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            final shouldLogout = await DialogManager.logoutDialog(
              context,
              themeProvider,
            );
            if (shouldLogout) {
              context.read<ProfileBloc>().add(Logout());
            }
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: themeProvider.isDarkMode
                    ? AppColors.colorWhite
                    : Theme.of(context).primaryColor.withAlpha(90),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.logout,
                        size: 30,
                        color: themeProvider.isDarkMode
                            ? AppColors.colorWhite
                            : Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Logout",
                        style: TextStyle(
                          color: themeProvider.isDarkMode
                              ? AppColors.colorWhite
                              : Theme.of(context).primaryColor,
                        ),
                        textScaler: const TextScaler.linear(1.2),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: themeProvider.isDarkMode
                        ? AppColors.colorWhite
                        : AppColors.colorGray,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: themeProvider.isDarkMode
                  ? AppColors.colorWhite
                  : Theme.of(context).primaryColor.withAlpha(90),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.delete_sharp,
                      size: 30,
                      color: themeProvider.isDarkMode
                          ? AppColors.colorWhite
                          : Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Delete Account",
                      style: TextStyle(
                        color: themeProvider.isDarkMode
                            ? AppColors.colorWhite
                            : Theme.of(context).primaryColor,
                      ),
                      textScaler: const TextScaler.linear(1.2),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: themeProvider.isDarkMode
                      ? AppColors.colorWhite
                      : AppColors.colorGray,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomThemeToggle extends StatelessWidget {
  const CustomThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return GestureDetector(
      onTap: () => themeProvider.toggleDarkMode(!isDark),
      child: Container(
        width: 95,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.dark_mode, color: Colors.black, size: 24),
                Icon(Icons.light_mode, color: Colors.black, size: 24),
              ],
            ),
            AnimatedAlign(
              alignment: isDark ? Alignment.centerLeft : Alignment.centerRight,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.black,
                ),
              ),
            ),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [SizedBox(width: 40), SizedBox(width: 40)],
            ),
          ],
        ),
      ),
    );
  }
}
