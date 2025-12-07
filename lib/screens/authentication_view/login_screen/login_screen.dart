import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mserp/customeDesigns/custom_buttom.dart';
import 'package:mserp/customeDesigns/custome_text_field.dart';
import 'package:mserp/networkSupport/ErrorHandler.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/authentication_view/login_screen/bloc/login_bloc.dart';
import 'package:mserp/screens/authentication_view/login_screen/repo/login_repo.dart';
import 'package:mserp/screens/authentication_view/signup_screen/signup_screen.dart';
import 'package:mserp/supports/LoadingDialog.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/strings.dart';
import 'package:mserp/themes/text_sizes.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:mserp/widget/bottom_navigation_view.dart';
import 'package:mserp/widget/circuler_bottom_navigation.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LoginRepository>(
          create: (context) => LoginRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginBloc(repository: LoginRepository()),
          ),
        ],
        child: const LoginView(),
      ),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final loginFromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Scaffold(
      body: BlocListener<LoginBloc, GlobalApiResponseState>(
        listener: (context, state) {
          switch (state.status) {
            case GlobalApiStatus.loading:
              LoadingDialog.show(context, key: const ObjectKey("Login..."));
              break;
            case GlobalApiStatus.completed:
              LoadingDialog.hide(context);
              if (state is LoginSuccessStates) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const CircularBottomNavBar()));
              }
              break;
            case GlobalApiStatus.error:
              LoadingDialog.hide(context);
              ErrorHandler.errorHandle(
                state.message,
                "Something went wrong",
                context,
              );
              break;
            default:
              LoadingDialog.hide(context);
          }
        },
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 0.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: const [.5, .5],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    isDark
                        ? AppColors.darkPrimaryLightColor
                        : AppColors.colorWhite,
                    isDark
                        ? AppColors.darkPrimaryColor
                        : Theme.of(context).primaryColor, // top Right part
                  ],
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/mserplogo.png",
                      width: 150,
                      color: AppColors.colorWhite,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        height: 450,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkPrimaryLightColor
                              : AppColors.colorWhite,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? AppColors.colorBlack
                                  : Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            right: 30,
                            left: 30,
                            bottom: 20,
                          ),
                          child: Form(
                            key: loginFromKey,
                            child: Column(
                              children: [
                                const SizedBox(height: 15),
                                Text(
                                  login,
                                  style: TextStyle(
                                    fontSize: AppTextSizes.extraLarge,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.colorWhite
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  hintText: "Enter your email",
                                  controller: nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your email";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                CustomTextField(
                                  hintText: "Enter your password",
                                  controller: passwordController,
                                  isPassword: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your password";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      forgotPassword,
                                      style: TextStyle(
                                        fontSize: AppTextSizes.large,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.colorWhite
                                            : Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                GestureDetector(
                                  onTap: () {
                                    if (loginFromKey.currentState!.validate()) {
                                      context.read<LoginBloc>().add(
                                        PostLogin(
                                          email: nameController.text.trim(),
                                          password: passwordController.text
                                              .trim(),
                                        ),
                                      );
                                    }
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) =>const CircularBottomNavBar()));
                                  },
                                  child: const CustomButton(btnText: "Login"),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      doNotHaveAccount,
                                      style: TextStyle(
                                        fontSize: AppTextSizes.medium,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.colorWhite
                                            : AppColors.dynamicTextColor,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        register,
                                        style: TextStyle(
                                          fontSize: AppTextSizes.large,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? AppColors.colorWhite
                                              : Theme.of(context).primaryColor,
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
                    ),
                    Image.asset(
                      "assets/icons/finger_print_icon.png",
                      width: 80,
                      color: isDark
                          ? AppColors.colorWhite
                          : Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
