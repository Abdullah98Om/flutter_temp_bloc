import 'package:flutter/material.dart';

Widget loader({Color? color}) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.black),
    ),
  );
}
