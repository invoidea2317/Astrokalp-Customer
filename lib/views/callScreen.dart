// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:developer';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/callController.dart';
import 'package:AstrowayCustomer/controllers/chatController.dart';
import 'package:AstrowayCustomer/controllers/filtterTabController.dart';
import 'package:AstrowayCustomer/controllers/languageController.dart';
import 'package:AstrowayCustomer/controllers/reportController.dart';
import 'package:AstrowayCustomer/controllers/skillController.dart';
import 'package:AstrowayCustomer/controllers/walletController.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/call/incoming_call_request.dart';
import 'package:AstrowayCustomer/views/callIntakeFormScreen.dart';
import 'package:AstrowayCustomer/views/paymentInformationScreen.dart';
import 'package:AstrowayCustomer/views/searchAstrologerScreen.dart';
import 'package:AstrowayCustomer/widget/customAppbarWidget.dart';
import 'package:AstrowayCustomer/widget/drawerWidget.dart';
import 'package:AstrowayCustomer/widget/language_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/follow_astrologer_controller.dart';
import '../controllers/homeController.dart';
import '../controllers/reviewController.dart';
import '../utils/AppColors.dart';
import '../utils/dimensions.dart';
import '../utils/fonts.dart';
import '../utils/sizedboxes.dart';
import '../utils/text_styles.dart';
import '../widget/custom_button_widget.dart';
import 'astrologerProfile/astrologerProfile.dart';
import 'call/oneToOneVideo/onetooneVideo.dart';

class CallScreen extends StatefulWidget {
  int flag;
  final bool? isBackExist;

  CallScreen({super.key, required this.flag, this.isBackExist = false});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final drawerKey = new GlobalKey<ScaffoldState>();
  FiltterTabController filtterTabController = Get.find<FiltterTabController>();

  SkillController skillController = Get.find<SkillController>();

  LanguageController languageController = Get.find<LanguageController>();

  ReportController reportController = Get.find<ReportController>();

  ChatController chatController = Get.find<ChatController>();
  CallController callController = Get.find<CallController>();

  BottomNavigationController bottomNavigationController =
      Get.find<BottomNavigationController>();
  WalletController walletController = Get.find<WalletController>();
  final PageController pageController = PageController();
  final homeController = Get.find<HomeController>();

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    global.sp = await SharedPreferences.getInstance();
    await global.sp!.reload();
    global.sp = global.sp;
    print("callScreenCall");
    print("${global.sp!.getInt('callBottom')}");
    if (global.sp!.getInt('callBottom') == 1) {
      callController.callBottom = true;
      callController.update();
    } else {
      callController.callBottom = false;
      callController.update();
    }
    print(global.sp);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: drawerKey,
        drawer: DrawerWidget(),
        appBar: CustomApp(title:widget.isBackExist! ? 'All Astrologers' : 'Call With Astrologers',
          isBackButtonExist: widget.isBackExist! ? true : false,
          menuWidget: Row(
          children: [
            InkWell(
              onTap: () async {
                homeController.lan = [];
                await Future.wait([
                  homeController.getLanguages(),
                  homeController.updateLanIndex()
                ]);
                print(homeController.lan);
                global.checkBody().then((result) {
                  if (result) {
                   Get.dialog(LanguageDialogWidget());
                  }
                });
              },
              child: Image.asset(
                height: 32,
                width: 32,
                Images.translation,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),),
        body: GetBuilder<CallController>(
          builder: (callController) {
            return DefaultTabController(
              length: chatController.categoryList.length,
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).cardColor,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => SearchAstrologerScreen());
                      },
                      child: SizedBox(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: FontSizes(context).width2(),
                              vertical: FontSizes(context).height1()),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                              border: Border.all(color: colorGrey)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                Container(
                                  padding:
                                  EdgeInsets.all(Dimensions.paddingSize7),
                                  height: Dimensions.fontSize40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).dividerColor),
                                  child: Icon(
                                    Icons.search,
                                    size: Dimensions.fontSize20,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Search astrologers,Products and Services...',
                                  style: Get.theme.primaryTextTheme.bodyLarge!
                                      .copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11,
                                    color: Colors.black38,
                                  ),
                                ).tr()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(top: 0),
                      itemCount: chatController.categoryList.length + 1,
                      itemBuilder: (context, value) {
                        // Filter Tab
                        if (value == 0) {
                          return GestureDetector(
                            onTap: () async {
                              openBottomSheetFilter(context);
                              skillController.getSkills();
                              languageController.getLanguages();
                            },
                            child: Chip(
                              padding: EdgeInsets.only(bottom: 5),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Theme.of(context).hintColor,
                                ),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              label: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.tune,
                                    size: 22,
                                    color: Theme.of(context)
                                        .hoverColor
                                        .withOpacity(0.40),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Filter',
                                    style: Get.theme.primaryTextTheme.bodySmall!
                                        .copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: Theme.of(context)
                                          .hoverColor
                                          .withOpacity(0.40),
                                    ),
                                  ).tr(),
                                ],
                              ),
                            ),
                          );
                        }

                        // Dynamic Tabs
                        int adjustedIndex = value - 1;
                        return GestureDetector(
                          onTap: () async {
                            chatController.isSelected = adjustedIndex;
                            pageController.jumpToPage(adjustedIndex);

                            if (adjustedIndex == 0) {
                              global.showOnlyLoaderDialog(context);
                              bottomNavigationController.astrologerList = [];
                              bottomNavigationController.isAllDataLoaded =
                                  false;
                              bottomNavigationController.update();
                              await bottomNavigationController
                                  .getAstrologerList(isLazyLoading: false);
                              global.hideLoader();
                            } else {
                              bottomNavigationController.astrologerList = [];
                              bottomNavigationController.isAllDataLoaded =
                                  false;
                              bottomNavigationController.update();
                              global.showOnlyLoaderDialog(context);
                              await bottomNavigationController.astroCat(
                                id: chatController
                                    .categoryList[adjustedIndex].id!,
                                isLazyLoading: false,
                              );
                              global.hideLoader();
                            }
                            chatController.update();
                          },
                          child: GetBuilder<ChatController>(builder: (chatco) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  right: Dimensions.paddingSize5),
                              child: Chip(
                                padding: EdgeInsets.only(bottom: 5),
                                backgroundColor:
                                    chatController.isSelected == adjustedIndex
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: chatController.isSelected ==
                                            adjustedIndex
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).hintColor,
                                  ),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                label: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (chatController
                                        .categoryList[adjustedIndex]
                                        .image
                                        .isNotEmpty)
                                      CachedNetworkImage(
                                        height: 20,
                                        width: 20,
                                        imageUrl:
                                            '${global.imgBaseurl}${chatController.categoryList[adjustedIndex].image}',
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          Icons.grid_view_rounded,
                                          color: Get.theme.primaryColor,
                                          size: 20,
                                        ),
                                      ),
                                    SizedBox(width: 5),
                                    Text(
                                      chatController
                                          .categoryList[adjustedIndex].name,
                                      style: Get
                                          .theme.primaryTextTheme.bodySmall!
                                          .copyWith(
                                        fontWeight: FontWeight.w300,
                                        color: chatController.isSelected ==
                                                adjustedIndex
                                            ? Theme.of(context).dividerColor
                                            : Theme.of(context)
                                                .hoverColor
                                                .withOpacity(0.40),
                                      ),
                                    ).tr(),
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: GetBuilder<BottomNavigationController>(
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
                          if (bottomNavigationController
                              .astrologerList.isEmpty) {
                            return Center(
                              child: Text(
                                'Astrologer not available',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 18),
                              ).tr(),
                            );
                          }
                          return RefreshIndicator(
                            onRefresh: () async {
                              bottomNavigationController.astrologerList = [];
                              bottomNavigationController.astrologerList.clear();
                              bottomNavigationController.isAllDataLoaded =
                                  false;
                              if (bottomNavigationController.genderFilterList !=
                                  null) {
                                bottomNavigationController.genderFilterList!
                                    .clear();
                              }
                              if (bottomNavigationController.languageFilter !=
                                  null) {
                                bottomNavigationController.languageFilter!
                                    .clear();
                              }
                              if (bottomNavigationController.skillFilterList !=
                                  null) {
                                bottomNavigationController.skillFilterList!
                                    .clear();
                              }
                              bottomNavigationController.applyFilter = false;
                              bottomNavigationController.update();
                              await bottomNavigationController
                                  .getAstrologerList(isLazyLoading: false);
                            },
                            child: TabViewAstrologer(
                              astrologerList:
                                  bottomNavigationController.astrologerList,
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
        bottomSheet: GetBuilder<CallController>(builder: (callController) {
          return callController.callBottom
              ? Container(
                  color: Get.theme.primaryColor,
                  height: 40,
                  width: Get.width,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(global.sp!
                                        .getString('bottomCallcallType')
                                        .toString() ==
                                    "11"
                                ? 'Start Video call with ${callController.bottomAstrologerName}'
                                : 'Start call with ${callController.bottomAstrologerName}')
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
                          callController.showBottomAcceptCall = false;
                          callController.callBottom = false;
                          global.sp!.remove('callBottom');
                          global.sp!.setInt('callBottom', 0);
                          callController.callBottom = false;
                          callController.update();
                          callController.bottomAstrologerName = global.sp!
                                  .getString('bottomCallAstrologerName') ??
                              '';
                          callController.bottomAstrologerProfile = global.sp!
                                  .getString('bottomCallAstrologerProfile') ??
                              '';
                          callController.bottomCallId =
                              global.sp!.getInt('bottomCallId');
                          callController.bottomChannel =
                              global.sp!.getString('bottomCallChannel');
                          callController.bottomAstrologerId =
                              global.sp!.getInt('bottomCallAstrologerId');
                          callController.bottomToken =
                              global.sp!.getString('bottomCallToken');
                          callController.bottomFcmToken =
                              global.sp!.getString('bottomCallFcmToken');
                          callController.callType =
                              global.sp!.getString('bottomCallcallType')!;
                          callController.update();
                          callController.callType.toString() == "11"
                              ? Get.to(() =>
                                  // OneToOneLiveScreen():
                                  OneToOneLiveScreen(
                                    channelname: callController.bottomChannel!,
                                    callId: callController.bottomCallId!,
                                    fcmToken: callController.bottomFcmToken!,
                                    end_time:
                                        callController.duration.toString(),
                                  ))
                              : Get.to(() => IncomingCallRequest(
                                    astrologerName:
                                        callController.bottomAstrologerName,
                                    astrologerProfile:
                                        callController.bottomAstrologerProfile,
                                    callId: callController.bottomCallId!,
                                    channel: callController.bottomChannel!,
                                    token: callController.bottomToken!,
                                    astrologerId:
                                        callController.bottomAstrologerId!,
                                    fcmToken: callController.bottomFcmToken!,
                                    duration:
                                        callController.duration.toString(),
                                  ));
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
      ),
    );
  }

  void openBottomSheetFilter(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.09,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Sort & Filter').tr(),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.close),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 2, height: 0),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Obx(
                    () => RotatedBox(
                      quarterTurns: 1,
                      child: TabBar(
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        controller: filtterTabController.filterTab,
                        indicatorColor: Colors.pink,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        indicator: BoxDecoration(),
                        indicatorWeight: 0,
                        unselectedLabelColor: Colors.grey[50],
                        onTap: (index) {
                          filtterTabController.selectedFilterIndex.value =
                              index;
                          filtterTabController.update();
                        },
                        tabs: List.generate(
                          filtterTabController.filtterList.length,
                          (ind) {
                            return RotatedBox(
                              quarterTurns: -1,
                              child: Container(
                                color: filtterTabController
                                            .selectedFilterIndex.value ==
                                        ind
                                    ? Colors.white
                                    : Colors.green[100],
                                height: 50,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        ),
                                        color: filtterTabController
                                                    .selectedFilterIndex
                                                    .value ==
                                                ind
                                            ? Colors.white
                                            : Colors.green,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        filtterTabController.filtterList[ind],
                                        style: TextStyle(color: Colors.black54),
                                      ).tr(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: RotatedBox(
                    quarterTurns: 1,
                    child: TabBarView(
                      controller: filtterTabController.filterTab,
                      children: [
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<ReportController>(
                            builder: (rpcont) {
                              return GetBuilder<SkillController>(
                                builder: (c) {
                                  return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: ListView.builder(
                                          itemCount:
                                              reportController.sorting.length,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            return RadioListTile(
                                              groupValue:
                                                  reportController.groupValue,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              contentPadding: EdgeInsets.zero,
                                              activeColor: Colors.black,
                                              value: reportController
                                                  .sorting[index].id,
                                              onChanged: (val) {
                                                reportController.groupValue =
                                                    val!;

                                                reportController.update();
                                              },
                                              title: Text(reportController
                                                      .sorting[index].name!)
                                                  .tr(),
                                            );
                                          }));
                                },
                              );
                            },
                          ),
                        )),
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<SkillController>(
                            builder: (c) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: ListView.builder(
                                      itemCount:
                                          skillController.skillList.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          activeColor: Colors.black,
                                          value: skillController.skillList[index].isSelected,
                                          onChanged: (value) {
                                            skillController.skillList[index].isSelected = value!;
                                            print('${skillController.skillList[index].isSelected}');skillController.update();
                                          },
                                          title: Text(skillController.skillList[index].name).tr(),
                                        );
                                      }));
                            },
                          ),
                        )),
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<LanguageController>(
                            builder: (c) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: ListView.builder(
                                      itemCount: languageController
                                          .languageList.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          activeColor: Colors.black,
                                          value: languageController
                                              .languageList[index].isSelected,
                                          onChanged: (value) {
                                            languageController
                                                .languageList[index]
                                                .isSelected = value!;
                                            languageController.update();
                                          },
                                          title: Text(languageController
                                                  .languageList[index]
                                                  .languageName)
                                              .tr(),
                                        );
                                      }));
                            },
                          ),
                        )),
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<FiltterTabController>(builder: (c) {
                            return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: ListView.builder(
                                    itemCount:
                                        filtterTabController.gender.length,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: Colors.black,
                                        value: filtterTabController
                                            .gender[index].isCheck,
                                        onChanged: (value) {
                                          filtterTabController
                                              .gender[index].isCheck = value!;
                                          filtterTabController.update();
                                        },
                                        title: Text(filtterTabController
                                                .gender[index].name)
                                            .tr(),
                                      );
                                    }));
                          }),
                        )),
                        SizedBox()
                      ],
                    ),
                  ))
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Divider(thickness: 2),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: SizedBox(
                          width: 0,
                          child: TextButton(
                            onPressed: () async {
                              skillController.skillFilterList = [];
                              filtterTabController.genderFilterList = [];
                              languageController.languageFilterList = [];
                              reportController.sortingFilter = null;
                              for (var i = 0;
                                  i < skillController.skillList.length;
                                  i++) {
                                skillController.skillList[i].isSelected = false;

                                skillController.update();
                              }
                              for (var i = 0;
                                  i < languageController.languageList.length;
                                  i++) {
                                languageController.languageList[i].isSelected =
                                    false;

                                languageController.update();
                              }
                              for (var i = 0;
                                  i < filtterTabController.gender.length;
                                  i++) {
                                filtterTabController.gender[i].isCheck = false;

                                filtterTabController.update();
                              }
                              Get.back();
                              bottomNavigationController.astrologerList = [];
                              bottomNavigationController.astrologerList.clear();
                              bottomNavigationController.isAllDataLoaded =
                                  false;
                              bottomNavigationController.skillFilterList =
                                  skillController.skillFilterList;
                              bottomNavigationController.genderFilterList =
                                  filtterTabController.genderFilterList;
                              bottomNavigationController.languageFilter =
                                  languageController.languageFilterList;
                              bottomNavigationController.applyFilter = false;
                              bottomNavigationController.update();
                              global.showOnlyLoaderDialog(context);
                              await bottomNavigationController
                                  .getAstrologerList(
                                      skills: skillController.skillFilterList,
                                      gender:
                                          filtterTabController.genderFilterList,
                                      language: languageController
                                          .languageFilterList);

                              global.hideLoader();
                              reportController.groupValue = 0;
                              print('done');
                              reportController.update();
                            },
                            child: Text(
                              'Reset',
                              style: TextStyle(color: Colors.black54),
                            ).tr(),
                          ),
                        )),
                        Expanded(child: GetBuilder<SkillController>(
                          builder: (controller) {
                            return SizedBox(
                              width: 80,
                              height: 55,
                              child: TextButton(
                                onPressed: () async {
                                  skillController.skillFilterList = [];
                                  filtterTabController.genderFilterList = [];
                                  languageController.languageFilterList = [];
                                  reportController.sortingFilter = null;

                                  for (var i = 0;
                                      i < skillController.skillList.length;
                                      i++) {
                                    if (skillController
                                            .skillList[i].isSelected ==
                                        true) {
                                      skillController.skillFilterList.add(
                                          skillController.skillList[i].id!);
                                      skillController.update();
                                    }
                                  }
                                  for (var i = 0;
                                      i < filtterTabController.gender.length;
                                      i++) {
                                    if (filtterTabController
                                            .gender[i].isCheck ==
                                        true) {
                                      filtterTabController.genderFilterList.add(
                                          filtterTabController.gender[i].name);
                                      filtterTabController.update();
                                    }
                                  }
                                  for (var i = 0;
                                      i <
                                          languageController
                                              .languageList.length;
                                      i++) {
                                    if (languageController
                                            .languageList[i].isSelected ==
                                        true) {
                                      languageController.languageFilterList.add(
                                          languageController
                                              .languageList[i].id!);
                                      languageController.update();
                                    }
                                  }
                                  for (var i = 0;
                                      i < reportController.sorting.length;
                                      i++) {
                                    if (reportController.groupValue ==
                                        reportController.sorting[i].id) {
                                      reportController.sortingFilter =
                                          reportController.sorting[i].value;
                                      reportController.update();
                                    }
                                  }
                                  Get.back();
                                  global.showOnlyLoaderDialog(context);
                                  bottomNavigationController.astrologerList =
                                      [];
                                  bottomNavigationController.astrologerList
                                      .clear();
                                  bottomNavigationController.isAllDataLoaded =
                                      false;
                                  bottomNavigationController.applyFilter = true;
                                  bottomNavigationController.skillFilterList =
                                      skillController.skillFilterList;
                                  bottomNavigationController.genderFilterList =
                                      filtterTabController.genderFilterList;
                                  bottomNavigationController.languageFilter =
                                      languageController.languageFilterList;
                                  bottomNavigationController.sortingFilter =
                                      reportController.sortingFilter;
                                  bottomNavigationController.update();
                                  await bottomNavigationController
                                      .getAstrologerList(
                                          skills:
                                              skillController.skillFilterList,
                                          gender: filtterTabController
                                              .genderFilterList,
                                          language: languageController
                                              .languageFilterList,
                                          sortBy:
                                              reportController.sortingFilter);
                                  global.hideLoader();
                                },
                                child: Text('Apply').tr(),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(8)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Get.theme.primaryColor),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.8),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    );
  }
}

class TabViewAstrologer extends StatelessWidget {
  final List astrologerList;

  TabViewAstrologer({
    required this.astrologerList,
    Key? key,
  }) : super(key: key);
  WalletController walletController = Get.find<WalletController>();
  BottomNavigationController bottomNavigationController =
      Get.find<BottomNavigationController>();
  ScrollController callScrollController = ScrollController();

  void paginateTask() {
    callScrollController.addListener(() async {
      if (callScrollController.position.pixels ==
              callScrollController.position.maxScrollExtent &&
          !bottomNavigationController.isAllDataLoaded) {
        bottomNavigationController.isMoreDataAvailable = true;
        bottomNavigationController.update();
        if (bottomNavigationController.selectedCatId == null ||
            bottomNavigationController.selectedCatId! == 0) {
          if (bottomNavigationController.isCallAstroDataLoadedOnce == false) {
            bottomNavigationController.isCallAstroDataLoadedOnce = true;
            bottomNavigationController.update();
            await bottomNavigationController.getAstrologerList(
                skills: bottomNavigationController.skillFilterList,
                gender: bottomNavigationController.genderFilterList,
                language: bottomNavigationController.languageFilter,
                sortBy: bottomNavigationController.sortingFilter,
                isLazyLoading: true);
            bottomNavigationController.isCallAstroDataLoadedOnce = false;
            bottomNavigationController.update();
          }
        } else {
          bottomNavigationController.astrologerList = [];
          bottomNavigationController.astrologerList.clear();
          bottomNavigationController.isAllDataLoaded = false;
          bottomNavigationController.update();
          await bottomNavigationController.astroCat(
              id: bottomNavigationController.selectedCatId!,
              isLazyLoading: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    paginateTask();
    return ListView.builder(
      controller: callScrollController,
      itemCount: astrologerList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            Get.find<ReviewController>()
                .getReviewData(astrologerList[index].id);
            global.showOnlyLoaderDialog(context);
            await bottomNavigationController
                .getAstrologerbyId(astrologerList[index].id);
            global.hideLoader();
            Get.to(() => AstrologerProfile(
                  index: index,
                ));
          },
          child: Column(
            children: [
              // Card(
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Row(
              //       children: [
              //         Column(
              //           children: [
              //             Stack(
              //               children: [
              //                 // Padding(
              //                 //   padding: const EdgeInsets.only(top: 10),
              //                 //   child: Container(
              //                 //     height: 65,
              //                 //     width: 65,
              //                 //     decoration: BoxDecoration(
              //                 //       border: Border.all(
              //                 //           color: Get.theme.primaryColor),
              //                 //       borderRadius: BorderRadius.circular(7),
              //                 //     ),
              //                 //     child: CircleAvatar(
              //                 //       radius: 35,
              //                 //       backgroundColor: Colors.white,
              //                 //       child: CachedNetworkImage(
              //                 //         height: 55,
              //                 //         width: 55,
              //                 //         imageUrl:
              //                 //             '${global.imgBaseurl}${astrologerList[index].profileImage}',
              //                 //         placeholder: (context, url) =>
              //                 //             const Center(
              //                 //                 child:
              //                 //                     CircularProgressIndicator()),
              //                 //         errorWidget: (context, url, error) =>
              //                 //             Image.asset(
              //                 //           Images.deafultUser,
              //                 //           fit: BoxFit.cover,
              //                 //           height: 50,
              //                 //           width: 40,
              //                 //         ),
              //                 //       ),
              //                 //     ),
              //                 //   ),
              //                 // ),
              //                 Container(
              //                   height: 14.h,
              //                   width: 12.h,
              //                   child: ClipRRect(
              //                     borderRadius: BorderRadius.circular(2.w),
              //                     child: CachedNetworkImage(
              //                       height: 14.h,
              //                       width: 12.h,
              //                       fit: BoxFit.cover,
              //                       imageUrl:
              //                           '${global.imgBaseurl}${astrologerList[index].profileImage}',
              //                       placeholder: (context, url) => const Center(
              //                           child: CircularProgressIndicator()),
              //                       errorWidget: (context, url, error) =>
              //                           Image.asset(
              //                         Images.deafultUser,
              //                         fit: BoxFit.cover,
              //                         height: 14.h,
              //                         width: 12.h,
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //                 Positioned(
              //                   bottom: 1.w,
              //                   right: 1.w,
              //                   left: 1.w,
              //                   child: Container(
              //                     width: 12.h,
              //                     height: 3.5.h,
              //                     decoration: BoxDecoration(
              //                       color: getRandomColor(index),
              //                       borderRadius: BorderRadius.circular(1.w),
              //                     ),
              //                     child: Center(
              //                       child: Text(
              //                         astrologerList[index]
              //                             .allSkill
              //                             .split(',')[0],
              //                         overflow: TextOverflow.ellipsis,
              //                         style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 14.sp,
              //                             fontWeight: FontWeight.w500),
              //                       ),
              //                     ),
              //                   ),
              //                 )
              //               ],
              //             ),
              //           ],
              //         ),
              //         Expanded(
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(horizontal: 5),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Row(
              //                   children: [
              //                     Text(
              //                       astrologerList[index].name,
              //                     ).tr(),
              //                     SizedBox(
              //                       width: 3,
              //                     ),
              //                     Image.asset(
              //                       Images.right,
              //                       height: 18,
              //                     )
              //                   ],
              //                 ),
              //                 astrologerList[index].allSkill == ""
              //                     ? const SizedBox()
              //                     : Text(
              //                         astrologerList[index].allSkill,
              //                         style: Get
              //                             .theme.primaryTextTheme.bodySmall!
              //                             .copyWith(
              //                           fontWeight: FontWeight.w300,
              //                           color: Colors.grey[600],
              //                         ),
              //                       ).tr(),
              //                 astrologerList[index].languageKnown == ""
              //                     ? const SizedBox()
              //                     : Text(
              //                         astrologerList[index].languageKnown,
              //                         style: Get
              //                             .theme.primaryTextTheme.bodySmall!
              //                             .copyWith(
              //                           fontWeight: FontWeight.w300,
              //                           color: Colors.grey[600],
              //                         ),
              //                       ).tr(),
              //                 Text(
              //                   'Experience : ${astrologerList[index].experienceInYears} Years',
              //                   style: Get.theme.primaryTextTheme.bodySmall!
              //                       .copyWith(
              //                     fontWeight: FontWeight.w300,
              //                     color: Colors.grey[600],
              //                   ),
              //                 ).tr(),
              //                 Row(
              //                   children: [
              //                     astrologerList[index].isFreeAvailable == true
              //                         ? Text(
              //                             'FREE',
              //                             style: Get
              //                                 .theme.textTheme.titleMedium!
              //                                 .copyWith(
              //                               fontSize: 11,
              //                               fontWeight: FontWeight.w500,
              //                               letterSpacing: 0,
              //                               color:
              //                                   Color.fromARGB(255, 167, 1, 1),
              //                             ),
              //                           ).tr()
              //                         : const SizedBox(),
              //                     SizedBox(
              //                       width:
              //                           astrologerList[index].isFreeAvailable ==
              //                                   true
              //                               ? 10
              //                               : 0,
              //                     ),
              //                     // Text(
              //                     //   '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${astrologerList[index].video}/min',
              //                     //   style: Get.theme.textTheme.titleMedium!
              //                     //       .copyWith(
              //                     //     fontSize: 11,
              //                     //     fontWeight: FontWeight.w500,
              //                     //     letterSpacing: 0,
              //                     //     decoration: astrologerList[index]
              //                     //                 .isFreeAvailable ==
              //                     //             true
              //                     //         ? TextDecoration.lineThrough
              //                     //         : null,
              //                     //     color: astrologerList[index]
              //                     //                 .isFreeAvailable ==
              //                     //             true
              //                     //         ? Colors.grey
              //                     //         : Color.fromARGB(255, 167, 1, 1),
              //                     //   ),
              //                     // ).tr(),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           height: 80,
              //           width: 80,
              //           child: Column(
              //             children: [
              //               SizedBox(
              //                 height: 4,
              //               ),
              //               Row(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: [
              //                     Expanded(
              //                       child: Container(
              //                         child: Center(
              //                           child: GetBuilder<CallController>(
              //                             builder:
              //                                 (CallController controller) =>
              //                                     InkWell(
              //                               onTap: () async {
              //                                 bool isLogin =
              //                                     await global.isLogin();
              //
              //                                 _logedIn(context, isLogin, index,
              //                                     true);
              //                               },
              //                               child: CircleAvatar(
              //                                 radius: 18,
              //                                 backgroundColor:
              //                                     astrologerList[index]
              //                                                 .callStatus ==
              //                                             "Online"
              //                                         ? Colors.green
              //                                         : Colors.orangeAccent,
              //                                 child: Center(
              //                                   child: Icon(
              //                                     Icons.call,
              //                                     color: Colors.white,
              //                                     size: 15,
              //                                   ),
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                     Expanded(
              //                       child: Container(
              //                         child: Center(
              //                           child: GetBuilder<CallController>(
              //                             builder:
              //                                 (CallController controller) =>
              //                                     InkWell(
              //                               onTap: () async {
              //                                 bool isLogin =
              //                                     await global.isLogin();
              //                                 _logedIn(context, isLogin, index,
              //                                     false);
              //                               },
              //                               child: CircleAvatar(
              //                                 radius: 18,
              //                                 backgroundColor:
              //                                     astrologerList[index]
              //                                                 .callStatus ==
              //                                             "Online"
              //                                         ? Colors.redAccent
              //                                         : Colors.orangeAccent,
              //                                 child: Center(
              //                                   child: Icon(
              //                                     Icons.video_call,
              //                                     color: Colors.white,
              //                                     size: 15,
              //                                   ),
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                   ]),
              //               SizedBox(
              //                 height: 4,
              //               ),
              //               RatingBar.builder(
              //                 initialRating: 0,
              //                 itemCount: 5,
              //                 allowHalfRating: false,
              //                 itemSize: 15,
              //                 ignoreGestures: true,
              //                 itemBuilder: (context, _) => Icon(
              //                   Icons.star,
              //                   color: Get.theme.primaryColor,
              //                 ),
              //                 onRatingUpdate: (rating) {},
              //               ),
              //               astrologerList[index].totalOrder == 0 ||
              //                       astrologerList[index].totalOrder == null
              //                   ? SizedBox()
              //                   : Text(
              //                       '${astrologerList[index].totalOrder} orders',
              //                       style: Get.theme.primaryTextTheme.bodySmall!
              //                           .copyWith(
              //                         fontWeight: FontWeight.w300,
              //                         fontSize: 9,
              //                       ),
              //                     ).tr()
              //             ],
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 90,
                                    width: 90,
                                    clipBehavior: Clip.hardEdge,
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          '${global.imgBaseurl}${astrologerList[index].profileImage}',
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        Images.deafultUser,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 10,
                                    left: 10,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .dividerColor
                                            .withOpacity(0.90),
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radius20),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            astrologerList[index]
                                                .rating
                                                .toString(),
                                            style: openSansRegular.copyWith(
                                                color:
                                                    Theme.of(context).cardColor,
                                                fontSize:
                                                    Dimensions.fontSize14),
                                          ),
                                          sizedBoxW5(),
                                          Icon(
                                            Icons.star,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: Dimensions.fontSize14,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                astrologerList[index].name,
                                              ).tr(),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Image.asset(
                                              Images.right,
                                              height: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                      GetBuilder<FollowAstrologerController>(builder: (followAstrologerController) {
                                        return CustomButtonWidget(
                                          height: 32,
                                          width: 100,
                                          onPressed: () async {
                                            log('message');
                                            bool isLogin =
                                            await global.isLogin();
                                            if (isLogin) {
                                              global.showOnlyLoaderDialog(context);
                                              await followAstrologerController.addFollowers(astrologerList[index].id!);global.hideLoader();
                                            }
                                          },
                                          radius: Dimensions.radius20,
                                          transparent: true,
                                          borderSideColor: Colors.green,
                                          buttonText: astrologerList[index].isFollow! ? 'Following' :  '+ Follow',
                                          textColor: Colors.green,
                                          isBold: false,
                                          fontSize: Dimensions.fontSize12,
                                        );
                                      })
                                    ],
                                  ),
                                  astrologerList[index].languageKnown == ""
                                      ? const SizedBox()
                                      : Row(
                                          children: [
                                            Icon(
                                              Icons.translate,
                                              size: 12,
                                              color: Colors.grey[600],
                                            ),
                                            sizedBoxW5(),
                                            Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              astrologerList[index]
                                                  .languageKnown,
                                              style: Get.theme.primaryTextTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey[600],
                                              ),
                                            ).tr(),
                                          ],
                                        ),
                                  astrologerList[index].allSkill == ""
                                      ? const SizedBox()
                                      : Row(
                                          children: [
                                            Icon(
                                              Icons.verified,
                                              size: 12,
                                              color: Colors.grey[600],
                                            ),
                                            sizedBoxW5(),
                                            Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              astrologerList[index].allSkill,
                                              style: Get.theme.primaryTextTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey[600],
                                              ),
                                            ).tr(),
                                          ],
                                        ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.school,
                                        size: 12,
                                        color: Colors.grey[600],
                                      ),
                                      sizedBoxW5(),
                                      Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        'Experience : ${astrologerList[index].experienceInYears} Years',
                                        style: Get
                                            .theme.primaryTextTheme.bodySmall!
                                            .copyWith(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.grey[600],
                                        ),
                                      ).tr(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Theme.of(context).dividerColor.withOpacity(0.20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${astrologerList[index].charge}/min',
                                style:
                                    Get.theme.textTheme.titleMedium!.copyWith(
                                  fontSize: Dimensions.fontSize20,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0,
                                  decoration:
                                      astrologerList[index].isFreeAvailable ==
                                              true
                                          ? TextDecoration.lineThrough
                                          : null,
                                  color: Theme.of(context).dividerColor,
                                ),
                              ).tr(),
                              astrologerList[index].isFreeAvailable == true
                                  ? Text(
                                      'FREE Chat Available',
                                      style: Get.theme.textTheme.titleMedium!
                                          .copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0,
                                        color: Colors.green,
                                      ),
                                    ).tr()
                                  : const SizedBox(),
                            ],
                          ),
                          Row(
                            children: [
                              CustomButtonWidget(
                                width: 100,
                                height: 40,
                                radius: Dimensions.radius5,
                                fontSize: Dimensions.fontSize12,
                                borderSideColor:
                                    Theme.of(context).highlightColor,
                                color: Theme.of(context).highlightColor,
                                textColor: Theme.of(context).cardColor,
                                buttonText: 'Call Now',
                                icon: CupertinoIcons.phone_solid,
                                iconColor: Theme.of(context).cardColor,
                                onPressed: () async {
                                  bool isLogin = await global.isLogin();

                                  _logedIn(context, isLogin, index, true);
                                },
                                isBold: false,
                              ),
                              // sizedBoxW10(),
                              // CustomButtonWidget(
                              //   width: 100,
                              //   height: 40,
                              //   radius: Dimensions.radius5,
                              //   fontSize: Dimensions.fontSize12,
                              //   borderSideColor: redColor,
                              //   color: redColor,
                              //   textColor: Theme.of(context).cardColor,
                              //   buttonText: 'Video Now',
                              //   icon: CupertinoIcons.video_camera_solid,
                              //   iconColor: Theme.of(context).cardColor,
                              //   onPressed: () async {
                              //     bool isLogin = await global.isLogin();
                              //     _logedIn(context, isLogin, index, false);
                              //   },
                              //   isBold: false,
                              // )
                            ],
                          )
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     TextButton(
                      //       style: ButtonStyle(
                      //         padding:
                      //         MaterialStateProperty.all(EdgeInsets.all(0)),
                      //         fixedSize:
                      //         MaterialStateProperty.all(Size.fromWidth(90)),
                      //         backgroundColor: astrologerList[index]
                      //             .chatStatus ==
                      //             "Online"
                      //             ? MaterialStateProperty.all(Colors.lightBlue)
                      //             : MaterialStateProperty.all(
                      //             Colors.orangeAccent),
                      //         shape: MaterialStateProperty.all(
                      //           RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //         ),
                      //       ),
                      //       onPressed: () async {
                      //         bool isLogin = await global.isLogin();
                      //         if (isLogin) {
                      //           await bottomNavigationController
                      //               .getAstrologerbyId(
                      //               astrologerList[index].id);
                      //           if (astrologerList[index].charge * 5 <=
                      //               global.splashController.currentUser!
                      //                   .walletAmount ||
                      //               astrologerList[index].isFreeAvailable ==
                      //                   true) {
                      //             await bottomNavigationController
                      //                 .checkAlreadyInReq(
                      //                 astrologerList[index].id);
                      //             if (bottomNavigationController
                      //                 .isUserAlreadyInChatReq ==
                      //                 false) {
                      //               if (astrologerList[index].chatStatus ==
                      //                   "Online") {
                      //                 global.showOnlyLoaderDialog(context);
                      //
                      //                 if (astrologerList[index].chatWaitTime !=
                      //                     null) {
                      //                   if (astrologerList[index]
                      //                       .chatWaitTime!
                      //                       .difference(DateTime.now())
                      //                       .inMinutes <
                      //                       0) {
                      //                     await bottomNavigationController
                      //                         .changeOfflineStatus(
                      //                         astrologerList[index].id,
                      //                         "Online");
                      //                   }
                      //                 }
                      //                 await Get.to(() => CallIntakeFormScreen(
                      //                   type: "Chat",
                      //                   astrologerId:
                      //                   astrologerList[index].id,
                      //                   astrologerName:
                      //                   astrologerList[index].name,
                      //                   astrologerProfile:
                      //                   astrologerList[index]
                      //                       .profileImage,
                      //                   isFreeAvailable:
                      //                   astrologerList[index]
                      //                       .isFreeAvailable,
                      //                 ));
                      //                 global.hideLoader();
                      //               } else if (astrologerList[index]
                      //                   .chatStatus ==
                      //                   "Offline" ||
                      //                   astrologerList[index].chatStatus ==
                      //                       "Busy" ||
                      //                   astrologerList[index].chatStatus ==
                      //                       "Wait Time") {
                      //                 bottomNavigationController
                      //                     .dialogForJoinInWaitList(
                      //                     context,
                      //                     astrologerList[index].name,
                      //                     true,
                      //                     bottomNavigationController
                      //                         .astrologerbyId[0].chatStatus
                      //                         .toString(),
                      //                     astrologerList[index]
                      //                         .profileImage);
                      //               }
                      //             } else {
                      //               bottomNavigationController
                      //                   .dialogForNotCreatingSession(context);
                      //             }
                      //           } else {
                      //             global.showOnlyLoaderDialog(context);
                      //             await walletController.getAmount();
                      //             global.hideLoader();
                      //             openBottomSheetRechrage(
                      //                 context,
                      //                 (astrologerList[index].charge * 5)
                      //                     .toString(),
                      //                 astrologerList[index].name);
                      //           }
                      //         }
                      //       },
                      //       child: astrologerList[index].isFreeAvailable == true
                      //           ? Text(
                      //         'FREE',
                      //         style: Get.theme.textTheme.titleMedium!
                      //             .copyWith(
                      //             fontSize: 12,
                      //             fontWeight: FontWeight.w500,
                      //             letterSpacing: 0,
                      //             color: Colors.white
                      //           //Color.fromARGB(255, 167, 1, 1),
                      //         ),
                      //       ).tr()
                      //           : Row(
                      //         mainAxisAlignment:
                      //         MainAxisAlignment.spaceEvenly,
                      //         children: [
                      //           Icon(
                      //             CupertinoIcons.chat_bubble_fill,
                      //             size: 15,
                      //             color: Colors.white,
                      //           ),
                      //           Text(
                      //             '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${astrologerList[index].charge}/min',
                      //             style: Get.theme.textTheme.titleMedium!
                      //                 .copyWith(
                      //               fontSize: 11,
                      //               fontWeight: FontWeight.w500,
                      //               letterSpacing: 0,
                      //               decoration: astrologerList[index]
                      //                   .isFreeAvailable ==
                      //                   true
                      //                   ? TextDecoration.lineThrough
                      //                   : null,
                      //               color: astrologerList[index]
                      //                   .isFreeAvailable ==
                      //                   true
                      //                   ? Colors.grey
                      //                   : Colors.white,
                      //             ),
                      //           ).tr(),
                      //         ],
                      //       ),
                      //     ),
                      //     astrologerList[index].chatStatus == "Offline"
                      //         ? Text(
                      //       "Currently Offline",
                      //       style: TextStyle(
                      //           color: Colors.red, fontSize: 09),
                      //     ).tr()
                      //         : astrologerList[index].chatStatus == "Wait Time"
                      //         ? Text(
                      //       astrologerList[index]
                      //           .chatWaitTime!
                      //           .difference(DateTime.now())
                      //           .inMinutes >
                      //           0
                      //           ? "Wait till - ${astrologerList[index].chatWaitTime!.difference(DateTime.now()).inMinutes} min"
                      //           : "Wait till",
                      //       style: TextStyle(
                      //           color: Colors.red, fontSize: 09),
                      //     ).tr()
                      //         : (astrologerList[index].chatStatus == "Busy"
                      //         ? Text(
                      //       "Currently Busy",
                      //       style: TextStyle(
                      //           color: Colors.red, fontSize: 09),
                      //     ).tr()
                      //         : SizedBox()),
                      //     // RatingBar.builder(
                      //     //   initialRating: 0,
                      //     //   itemCount: 5,
                      //     //   allowHalfRating: false,
                      //     //   itemSize: 15,
                      //     //   ignoreGestures: true,
                      //     //   itemBuilder: (context, _) => Icon(
                      //     //     Icons.star,
                      //     //     color: Get.theme.primaryColor,
                      //     //   ),
                      //     //   onRatingUpdate: (rating) {},
                      //     // ),
                      //     astrologerList[index].totalOrder == 0 ||
                      //         astrologerList[index].totalOrder == null
                      //         ? SizedBox()
                      //         : Text(
                      //       '${astrologerList[index].totalOrder} orders',
                      //       style: Get.theme.primaryTextTheme.bodySmall!
                      //           .copyWith(
                      //         fontWeight: FontWeight.w300,
                      //         fontSize: 9,
                      //       ),
                      //     ).tr()
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
              bottomNavigationController.isMoreDataAvailable == true &&
                      !bottomNavigationController.isAllDataLoaded &&
                      astrologerList.length - 1 == index
                  ? const CircularProgressIndicator()
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }

  void openBottomSheetRechrage(
      BuildContext context, String minBalance, String astrologer) {
    Get.bottomSheet(
      Container(
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.85,
                                    child: minBalance != ''
                                        ? Text('Minimum balance of 5 minutes(${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $minBalance) is required to start call with $astrologer ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.red))
                                            .tr()
                                        : const SizedBox(),
                                  ),
                                  GestureDetector(
                                    child: Padding(
                                      padding: minBalance == ''
                                          ? const EdgeInsets.only(top: 8)
                                          : const EdgeInsets.only(top: 0),
                                      child: Icon(Icons.close, size: 18),
                                    ),
                                    onTap: () {
                                      Get.back();
                                    },
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 5),
                                child: Text('Recharge Now',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))
                                    .tr(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Icon(Icons.lightbulb_rounded,
                                        color: Get.theme.primaryColor,
                                        size: 13),
                                  ),
                                  Expanded(
                                      child: Text(
                                              'Minimum balance required ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $minBalance',
                                              style: TextStyle(fontSize: 12))
                                          .tr())
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 3.8 / 2.3,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: walletController.rechrage.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => PaymentInformationScreen(
                              flag: 0,
                              amount: double.parse(
                                  walletController.payment[index])));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                                child: Text(
                              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${walletController.rechrage[index]}',
                              style: TextStyle(fontSize: 13),
                            )),
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.8),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    );
  }

  void _logedIn(context, isLogin, index, audio) async {
    if (isLogin) {

      //_checkAstrologerAvailability(index);
      global.showOnlyLoaderDialog(context);
      await bottomNavigationController
          .getAstrologerbyId(astrologerList[index].id);
      print('charge${global.splashController.currentUser!.walletAmount! * 5}');
      if (astrologerList[index].charge * 5 <=
              global.splashController.currentUser!.walletAmount! ||
          astrologerList[index].isFreeAvailable == true) {
        await bottomNavigationController
            .checkAlreadyInReqForCall(astrologerList[index].id);
        if (bottomNavigationController.isUserAlreadyInCallReq == false) {
          if (astrologerList[index].callStatus == "Online") {
            // global.showOnlyLoaderDialog(context);
            if (astrologerList[index].callWaitTime != null) {
              if (astrologerList[index]
                      .callWaitTime!
                      .difference(DateTime.now())
                      .inMinutes <
                  0) {
                await bottomNavigationController.changeOfflineCallStatus(
                    astrologerList[index].id, "Online");
              }
            }
            await Get.to(() => CallIntakeFormScreen(
                  astrologerProfile: astrologerList[index].profileImage,
                  type: audio ? "Call" : "Videocall",
                  astrologerId: astrologerList[index].id,
                  astrologerName: astrologerList[index].name,
                  isFreeAvailable: astrologerList[index].isFreeAvailable,
                ));

            global.hideLoader();
          } else if (astrologerList[index].callStatus == "Offline" ||
              astrologerList[index].callStatus == "Busy" ||
              astrologerList[index].callStatus == "Wait Time") {
            bottomNavigationController.dialogForJoinInWaitList(
                context,
                astrologerList[index].name,
                true,
                bottomNavigationController.astrologerbyId[0].callStatus
                    .toString(),
                astrologerList[index].profileImage);
          }
        } else {
          bottomNavigationController.dialogForNotCreatingSession(context);
        }
      } else {
        global.showOnlyLoaderDialog(context);
        await walletController.getAmount();
        global.hideLoader();
        openBottomSheetRechrage(
            context,
            (astrologerList[index].charge * 5).toString(),
            '${astrologerList[index].name}');
      }
    }
  }
}
