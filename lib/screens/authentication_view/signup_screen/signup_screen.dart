import 'package:flutter/material.dart';
import 'package:mserp/customeDesigns/custom_buttom.dart';
import 'package:mserp/customeDesigns/custome_text_field.dart';
import 'package:mserp/screens/authentication_view/login_screen/login_screen.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/strings.dart';
import 'package:mserp/themes/text_sizes.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 0.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops:const [.5, .5],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  isDark ? AppColors.darkPrimaryLightColor : AppColors.colorWhite,
                  isDark ? AppColors.darkPrimaryColor : Theme.of(context).primaryColor,
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
                  Image.asset("assets/icons/smerplogo.png", width: 150, color: AppColors.colorWhite,),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkPrimaryLightColor : AppColors.colorWhite,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? AppColors.colorBlack : Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, right: 30, left: 30, bottom: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 15,),
                            Text(register, style: TextStyle(fontSize: AppTextSizes.extraLarge, fontWeight: FontWeight.w600, color:isDark ? AppColors.colorWhite : Theme.of(context).primaryColor),),
                            const SizedBox(height: 20,),
                            CustomTextField(
                              hintText: "Enter name",
                              controller: nameController,
                            ),
                            const SizedBox(height: 15,),
                            CustomTextField(
                              hintText: "Enter email",
                              controller: emailController,
                            ),
                            const SizedBox(height: 15,),
                            CustomTextField(
                              hintText: "Enter phone number",
                              controller: phoneController,
                            ),
                            const SizedBox(height: 15,),
                            CustomTextField(
                              hintText: "Enter password",
                              controller: passwordController,
                              isPassword: true,
                            ),
                            const SizedBox(height: 15,),
                            CustomTextField(
                              hintText: "Enter confirm password",
                              controller: passwordController,
                              isPassword: true,
                            ),
                            const SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Align(alignment: Alignment.centerLeft,child: Text(forgotPassword, style: TextStyle(fontSize: AppTextSizes.large, fontWeight: FontWeight.w600, color: isDark ? AppColors.colorWhite : Theme.of(context).primaryColor))),
                            ),
                            const SizedBox(height: 15,),
                            GestureDetector(onTap: (){
                              /*Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigationView()));*/
                            }, child:const CustomButton(btnText: "Sign Up")),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(alreadyHaveAccount, style: TextStyle(fontSize: AppTextSizes.medium, fontWeight: FontWeight.w600, color: isDark ? AppColors.colorWhite : AppColors.dynamicTextColor),),
                                const SizedBox(width: 5,),
                                GestureDetector(onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>const LoginScreen()));
                                },child: Text(login, style: TextStyle(fontSize: AppTextSizes.large, fontWeight: FontWeight.w600, color: isDark ? AppColors.colorWhite : Theme.of(context).primaryColor),)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
