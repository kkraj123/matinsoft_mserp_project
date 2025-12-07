import 'package:flutter/material.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/text_sizes.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomButton extends StatefulWidget {
  final String btnText;
  const CustomButton({super.key, required this.btnText});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkPrimaryLightColor : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(widget.btnText, style: const TextStyle(color: AppColors.colorWhite, fontSize: AppTextSizes.large),),
      ),
    );
  }
}
