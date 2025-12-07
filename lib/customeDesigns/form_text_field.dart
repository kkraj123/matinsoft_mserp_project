import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class FormTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;

  const FormTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  }) : super(key: key);

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius:const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: isDark? AppColors.colorWhite : Theme.of(context).primaryColor),
        ),
        enabledBorder:  OutlineInputBorder(
          borderRadius:const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: isDark ? AppColors.colorWhite : Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: isDark ? AppColors.colorWhite : Theme.of(context).primaryColor, width: 1.5),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: _toggleVisibility,
        )
            : null,
      ),
    );
  }
}
