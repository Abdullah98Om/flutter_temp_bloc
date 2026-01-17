import 'package:flutter/material.dart';

import '../theme/app_color.dart';

class MyButtont extends StatelessWidget {
  const MyButtont({
    super.key,
    this.name,
    this.color = AppColor.primaryColor,
    this.icon,
    this.onTap,
    this.textColor = AppColor.backgroundColor,
  });
  final String? name;
  final Color color, textColor;
  final IconData? icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: name != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) Icon(icon, color: textColor, size: 30),
                  if (icon != null) SizedBox(width: 8),
                  Text(
                    name!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
