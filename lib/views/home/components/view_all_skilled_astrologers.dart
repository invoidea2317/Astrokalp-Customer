// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/chatController.dart';
import 'package:AstrowayCustomer/controllers/filtterTabController.dart';
import 'package:AstrowayCustomer/controllers/languageController.dart';
import 'package:AstrowayCustomer/controllers/reportController.dart';
import 'package:AstrowayCustomer/controllers/reviewController.dart';
import 'package:AstrowayCustomer/controllers/skillController.dart';
import 'package:AstrowayCustomer/controllers/walletController.dart';
import 'package:AstrowayCustomer/main.dart';
import 'package:AstrowayCustomer/utils/dimensions.dart';
// import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/utils/text_styles.dart';
// import 'package:AstrowayCustomer/views/addMoneyToWallet.dart';
import 'package:AstrowayCustomer/views/astrologerProfile/astrologerProfile.dart';
import 'package:AstrowayCustomer/views/callIntakeFormScreen.dart';
import 'package:AstrowayCustomer/views/chat/incoming_chat_request.dart';
import 'package:AstrowayCustomer/views/paymentInformationScreen.dart';
import 'package:AstrowayCustomer/views/searchAstrologerScreen.dart';
import 'package:AstrowayCustomer/widget/customAppbarWidget.dart';
import 'package:AstrowayCustomer/widget/custom_button_widget.dart';
import 'package:AstrowayCustomer/widget/drawerWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

import '../../../controllers/homeController.dart';
import '../../../model/astrologer_model.dart';
import '../../../utils/sizedboxes.dart';
import '../../chatScreen.dart';



class ViewAllSkilledAstrologers extends StatelessWidget {
  final String title;
  final List astrologerList;
   ViewAllSkilledAstrologers({super.key, required this.title, required this.astrologerList});
  final drawerKey = new GlobalKey<ScaffoldState>();

  FiltterTabController filtterTabController = Get.find<FiltterTabController>();

  SkillController skillController = Get.find<SkillController>();

  LanguageController languageController = Get.find<LanguageController>();

  ReportController reportController = Get.find<ReportController>();

  BottomNavigationController bottomNavigationController =
  Get.find<BottomNavigationController>();

  final homeController = Get.find<HomeController>();

  WalletController walletController = Get.find<WalletController>();

  ChatController cController = Get.find<ChatController>();

  final walletcontroller = Get.find<WalletController>();

  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomApp(title: title,isBackButtonExist: true,),
      body: GetBuilder<BottomNavigationController>(
          builder: (bottomNavigationController) {
            return PageView.builder(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                chatController.isSelected = index;
                chatController.update();
              },
              itemCount: chatController.categoryList.length,
              itemBuilder: (context, index) {
                if (bottomNavigationController.astrologerList.isEmpty) {
                  return Center(
                    child: Text(
                      'Astrologer not available',
                      style:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                    ).tr(),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    bottomNavigationController.astrologerList = [];
                    bottomNavigationController.isAllDataLoaded = false;
                    bottomNavigationController.update();
                    await bottomNavigationController
                        .getAstrologerList(isLazyLoading: false);
                  },
                  child: TabViewWidget(
                    astrologerList: astrologerList,
                  ),
                );
              },
            );
          }),
      bottomSheet: GetBuilder<ChatController>(builder: (C) {
        return chatController.chatBottom == true
            ? Container(
          color: Get.theme.primaryColor,
          height: 40,
          width: Get.width,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                    'Start chat with ${cController.bottomAstrologerName}')
                    .tr(),
              ),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                  backgroundColor:
                  MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () async {
                  cController.bottomAstrologerName =
                      global.sp!.getString('bottomAstrologerName') ??
                          '';
                  cController.bottomAstrologerProfile =
                      global.sp!.getString('bottomAstrologerProfile') ??
                          '';
                  cController.bottomFirebaseChatId =
                      global.sp!.getString('bottomFirebaseChatId') ??
                          '';
                  cController.bottomChatId =
                      global.sp!.getInt('bottomChatId');
                  cController.bottomAstrologerId =
                      global.sp!.getInt('bottomAstrologerId');
                  cController.bottomFcmToken =
                      global.sp!.getString('bottomFcmToken');
                  cController.update();
                  Get.to(() => IncomingChatRequest(
                      astrologerName: cController.bottomAstrologerName,
                      profile: cController.bottomAstrologerProfile,
                      fireBasechatId:
                      cController.bottomFirebaseChatId ?? "",
                      chatId: cController.bottomChatId!,
                      astrologerId: cController.bottomAstrologerId!,
                      fcmToken: cController.bottomFcmToken,
                      duration: cController.duration.toString()));
                },
                child: Text(
                  'Start',
                  style: Get.theme.primaryTextTheme.bodySmall!
                      .copyWith(color: Colors.white),
                ).tr(),
              ),
            ],
          ),
        )
            : const SizedBox();
      }),
    );
  }
}


