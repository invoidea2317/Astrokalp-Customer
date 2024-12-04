import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/dimensions.dart';
import '../utils/sizedboxes.dart';

class CustomIconTextRowForAstrologer extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool? isWhite;
  const CustomIconTextRowForAstrologer({super.key, required this.icon, required this.title, this.isWhite = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,size: 12,color: isWhite! ? Theme.of(context).cardColor : Colors.grey[600],),
        sizedBoxW5(),
        Text(maxLines: 1,overflow: TextOverflow.ellipsis,
          title,
          style: Get.theme.primaryTextTheme.bodySmall!
              .copyWith(
            fontWeight: FontWeight.w300,
            color: isWhite! ? Theme.of(context).cardColor :  Colors.grey[600],
          ),
        ).tr(),
      ],
    );
  }
}

class CustomDecoratedContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Function()?  tap;
  const CustomDecoratedContainer({super.key, required this.child, this.color, this.horizontalPadding, this.verticalPadding,  this.tap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Container(padding:
      EdgeInsets.symmetric(horizontal: horizontalPadding ?? 3,vertical: verticalPadding ?? 0),
      decoration: BoxDecoration(
      color: color ?? Theme.of(context)
          .dividerColor
          .withOpacity(0.90),
      borderRadius: BorderRadius.circular(
      Dimensions.radius20),
      ),
        child: child,
      ),
    );
  }
}
