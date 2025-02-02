import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Utils{
  void toastMessage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white.withOpacity(0.6),
        textColor: Colors.black,
        fontSize: 16.0
    );
  }
}