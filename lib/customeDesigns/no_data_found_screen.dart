import 'package:flutter/material.dart';
import 'package:mserp/themes/app_cololors.dart';

class NoDataFoundScreen extends StatelessWidget {
  final bool isDark;
  final String emptyText;
  const NoDataFoundScreen({super.key, required this.isDark, required this.emptyText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset("assets/icons/empty_icon.png", width: 90, height: 90,color: isDark ? Colors.white : Theme.of(context).primaryColor,),
        const SizedBox(height: 10,),
        Text(emptyText, style: TextStyle(color: isDark ? AppColors.colorWhite : Theme.of(context).primaryColor),textScaler:const TextScaler.linear(1.2),)
      ],
    );
  }
}
