import 'package:flutter/material.dart';
import 'package:mserp/screens/profile_screen/profile_screen.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onClick;
  const CustomAppBar({super.key,this.onClick});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: isDark ? AppColors.darkPrimaryColor : AppColors.colorWhite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 18, right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) {
                    return InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Icon(
                        Icons.menu,
                        size: 35,
                        color: isDark ? AppColors.colorGray : AppColors.colorGray,
                      ),
                    );
                  },
                ),

                Image.asset("assets/icons/mserplogo.png", width: 100, height: 50,),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.message,
                          size: 25,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>const ProfileScreen()));
                      },
                      child: const Icon(
                        Icons.person,
                        size: 25,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 15,),
                    InkWell(
                      onTap: onClick,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isDark ? AppColors.colorWhite: Theme.of(context).primaryColor
                        ),
                        child: Center(
                          child: Image.asset("assets/icons/click.png", width: 20, height: 20, color: isDark ? AppColors.primaryColor : AppColors.colorWhite,),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1.5,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 0.1,
                  offset:const Offset(0, 2),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(80);
}
