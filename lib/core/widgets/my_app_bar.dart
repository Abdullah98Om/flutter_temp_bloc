import 'package:flutter/material.dart';

import '../util/app_responsive.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key, this.title, this.color = Colors.transparent});
  final String? title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: 101,
      width: context.screenWidth,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          title != null
              ? Text(
                  maxLines: 1,
                  title!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                )
              : InkWell(
                  onTap: () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),

          Icon(
            Icons.more_horiz_rounded,
            size: 20,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
