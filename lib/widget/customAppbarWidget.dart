import 'package:AstrowayCustomer/utils/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/dimensions.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function onBackPressed;
  final List<Widget> actions;
  final Color bgColor;
  final TextStyle? titleStyle;
  final int flagId;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int ?flagforCategory;
  final bool? leading;
  CustomAppBar({required this.title, required this.bgColor, this.flagId = 0, required this.onBackPressed, required this.actions,  this.titleStyle, required this.scaffoldKey,this.flagforCategory, this.leading = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: bgColor,
      leading: InkWell(
        onTap: () {
          if(flagforCategory==1)
          {
            Get.back();
          }
          else{
            if (scaffoldKey.currentState!.isDrawerOpen) {
              scaffoldKey.currentState!.closeDrawer();
              Get.back();
            } else {
              scaffoldKey.currentState!.openDrawer();
            }
          }

        },
        child: Icon(
          flagId == 1
              ? Icons.chat
              : (flagId == 2
                  ? (flagforCategory==0?Icons.phone:Icons.arrow_back)
                  : Icons.menu),
          color:  Theme.of(context).primaryColor,
        ),
      ),
      title: Text(
        title,
          // style: titleStyle,
        style: titleStyle ?? Get.theme.primaryTextTheme.titleLarge!
            .copyWith(fontWeight: FontWeight.normal, color:  Theme.of(context).primaryColor),
      ).tr(),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}




class CustomApp extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final Widget? menuWidget;
  final Function()? isBackCall;

  const CustomApp({Key? key, required this.title, this.onBackPressed, this.isBackButtonExist = false, this.menuWidget,  this.isBackCall, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title!, style: openSansRegular.copyWith(fontSize: Dimensions.fontSize18, color: Theme.of(context).primaryColor)),
      centerTitle: true,
      leading: isBackButtonExist ? IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          if (isBackCall != null) {
            isBackCall!();
          } else {
            Navigator.pop(context);
          }
        },
      ):  Builder(
        builder: (context) => InkWell(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Container(
            padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Icon(
              Icons.menu,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),),

      backgroundColor: Theme.of(context).dividerColor,
      elevation: 0,
      actions: menuWidget != null ? [Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: menuWidget!,
      )] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
