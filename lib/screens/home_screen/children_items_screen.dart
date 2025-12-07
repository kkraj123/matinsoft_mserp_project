import 'package:flutter/material.dart';
import 'package:mserp/constant.dart';
import 'package:mserp/customeDesigns/custom_toolbar.dart';
import 'package:mserp/screens/flutter_icons.dart';
import 'package:mserp/screens/home_screen/handle_click_items.dart';
import 'package:mserp/screens/home_screen/model/CategoryItemsResponse.dart';
import 'package:mserp/screens/leave_request_screen/MyLeaveStatusScreen.dart';
import 'package:mserp/screens/leave_request_screen/leave_request_screen.dart';
import 'package:mserp/screens/leave_request_screen/model/MyLeaveStatusResponse.dart';
import 'package:mserp/screens/time_leave_request/time_leave_request_screen.dart';
import 'package:mserp/screens/time_leave_request/time_leave_scree.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:mserp/widget/default_screen.dart';
import 'package:provider/provider.dart';

class ChildrenItemsScreen extends StatelessWidget {
  final String parentName;
  final List<Children> children;

  const ChildrenItemsScreen({
    super.key,
    required this.parentName,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkPrimaryColor
          : AppColors.colorWhite,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.black.withAlpha(200)
                    : Theme.of(context).primaryColor,
                borderRadius:const  BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.ac_unit,
                    color: AppColors.colorWhite,
                    size: 35,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    parentName,
                    style: const TextStyle(
                      color: AppColors.colorWhite,
                      fontWeight: FontWeight.bold,
                    ),
                    textScaler: const TextScaler.linear(1.5),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              top: 150,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: children.length,
                  itemBuilder: (context, index) {
                    final child = children[index];
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        handleChildrenClickItems(child, context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkPrimaryLightColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(getFlutterIcon(child.icon), size: 40, color: isDark ? AppColors.colorWhite : Theme.of(context).primaryColor,),
                              const SizedBox(height: 5),
                              Text(
                                "${child.name}",
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.colorWhite
                                      : Theme.of(context).primaryColor,
                                  overflow: TextOverflow.ellipsis
                                ),
                                textScaler:const TextScaler.linear(1.2),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
