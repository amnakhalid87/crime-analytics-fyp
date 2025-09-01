import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/utils/constant/colors.dart';

class BuildToast {
  static void toastMessages(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      textColor: Colors.white,
      backgroundColor: AppColors.primaryColor,
      fontSize: 18,
    );
  }
}
