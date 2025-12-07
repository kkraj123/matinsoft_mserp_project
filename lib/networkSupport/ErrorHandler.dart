import 'package:flutter/material.dart';
import 'package:mserp/supports/DialogManager.dart';


class ErrorHandler {
  //change with suitable dialog
  static void errorHandle(String message, String title, BuildContext context){
    DialogManager.showErrorDialog(message, title,context);
  }
}
