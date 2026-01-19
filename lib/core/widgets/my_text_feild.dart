import 'package:flutter/material.dart';

import '../theme/app_color.dart';
import '../theme/app_text_style.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    this.hint,
    this.textDirection = TextDirection.ltr,
    this.icon,
    this.maxLines,
    this.title,
    this.textEditingController,
    this.scureText = false,
  });

  final String? hint, title;
  final TextDirection textDirection;
  final Widget? icon;
  final int? maxLines;
  final bool scureText;
  final TextEditingController? textEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) Text(title!, style: AppTextStyles.headline2),
        // if (title != null) SizedBox(height: 8),
        Container(
          alignment: Alignment.center,
          height: maxLines != null ? null : 46,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(16),
            // color: AppColor.backgroundColor,
            // border: Border.all(
            //   color: AppColor.darkGrayColor.withValues(alpha: 0.3),
            // ),
          ),
          child: TextFormField(
            cursorColor: Theme.of(context).colorScheme.primary,
            textDirection: textDirection,
            controller: textEditingController,
            maxLines: scureText ? 1 : maxLines,

            obscureText: scureText,

            style: TextStyle(
              decoration: TextDecoration.none,
              color: AppColor.secondaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              suffix: icon,
              counterStyle: TextStyle(
                color: Theme.of(context).colorScheme.surface,
              ),
              hintText: hint,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD9DFEB)),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              // enabledBorder: InputBorder.none, // إلغاء الحدود عند التمكين
              // focusedBorder: InputBorder.none, // إلغاء الحدود عند التركيز
              // errorBorder: InputBorder.none, // إلغاء الحدود عند الخطأ
              // disabledBorder: InputBorder.none,
              // focusedErrorBorder: InputBorder.none,
              hintStyle: TextStyle(
                letterSpacing: 1.75,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColor.successColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
