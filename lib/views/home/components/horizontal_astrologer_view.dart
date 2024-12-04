import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/walletController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/callIntakeFormScreen.dart';
import 'package:AstrowayCustomer/views/paymentInformationScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import '../../../controllers/reviewController.dart';
import '../../../theme/nativeTheme.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/sizedboxes.dart';
import '../../../utils/text_styles.dart';
import '../../../widget/custom_button_widget.dart';
import '../../astrologerProfile/astrologerProfile.dart';

class HorizontalAstrologerView extends StatelessWidget {
  final List astrologerList;
  final String title;
  final Function() tap;
  final bool? isColor;

  HorizontalAstrologerView({
    required this.astrologerList,
    Key? key, required this.title, required this.tap, this.isColor = false,
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
    return Container(
      color:isColor! ? lightPrimary: Theme.of(context).cardColor,
      padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Get.theme.primaryTextTheme
                      .titleMedium!
                      .copyWith(
                      fontWeight:
                      FontWeight.w500),
                ).tr(),
                GestureDetector(
                  onTap: tap,
                  child: Text(
                    'See All',
                    style: openSansRegular.copyWith(
                        fontSize: Dimensions.fontSize14
                    ),
                  ).tr(),
                ),
              ],
            ),
          ),
          sizedBoxDefault(),
          SizedBox(
            height: 200,
            child: ListView.builder(
              padding: EdgeInsets.only(left: Dimensions.paddingSizeDefault),
              scrollDirection: Axis.horizontal,
              controller: callScrollController,
              itemCount: astrologerList.length,
              itemBuilder: (context, index) {
                print('astrologerList.length ${astrologerList.length}');
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
                  child: Container(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    height: 200,
                    width: 180,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radius10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(astrologerList[index].chatStatus == "Online" ? '• Available' : '• Offline',
                            style: openSansRegular.copyWith(
                              fontSize: Dimensions.fontSize14,
                              color: astrologerList[index].chatStatus == "Online" ?
                                  greenColor : redColor,),),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: lightPrimary,
                                borderRadius: BorderRadius.circular(Dimensions.radius20),
                              ),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(  astrologerList[index].rating.toString(),
                                    style: openSansRegular.copyWith(color: Theme.of(context).dividerColor,
                                        fontSize: Dimensions.fontSize14),),
                                  sizedBoxW5(),
                                  Icon(Icons.star,color: Theme.of(context).primaryColor,
                                    size:  Dimensions.fontSize14,)
                                ],
                              ),
                            )
                          ],
                        ),
                        sizedBox10(),
                        Container(
                          height: 80,
                          width: 180,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:
                                '${global.imgBaseurl}${astrologerList[index].profileImage}',
                            placeholder: (context, url) =>
                                const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.asset(
                              Images.deafultUser,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        sizedBox5(),
                        Flexible(
                          child: Text(
                            astrologerList[index].name ??
                                'N/A', // Fallback to 'N/A' if name is null
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: openSansSemiBold.copyWith(
                                fontSize: Dimensions.fontSize14),
                          ).tr(),
                        ),
                        Text(maxLines: 1, overflow: TextOverflow.ellipsis,
                          'Exp : ${astrologerList[index].experienceInYears} Years',
                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w300, color: Colors.grey[700],),
                        ).tr(),
                        astrologerList[index].languageKnown == ""
                                                ? const SizedBox()
                                                : Row(mainAxisAlignment: MainAxisAlignment.center,
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
          
                        // Card(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Column(
                        //       children: [
                        //         Row(
                        //           children: [
                        //             Column(
                        //               children: [
                        //                 Stack(
                        //                   children: [
                        //                     Container(
                        //                       height: 90,
                        //                       width: 90,
                        //                       clipBehavior: Clip.hardEdge,
                        //                       decoration:
                        //                       BoxDecoration(shape: BoxShape.circle),
                        //                       child: CachedNetworkImage(
                        //                         fit: BoxFit.cover,
                        //                         imageUrl:
                        //                         '${global.imgBaseurl}${astrologerList[index].profileImage}',
                        //                         placeholder: (context, url) =>
                        //                         const Center(
                        //                             child:
                        //                             CircularProgressIndicator()),
                        //                         errorWidget: (context, url, error) =>
                        //                             Image.asset(
                        //                               Images.deafultUser,
                        //                               fit: BoxFit.cover,
                        //                             ),
                        //                       ),
                        //                     ),
                        //                     Positioned(
                        //                       bottom: 0,
                        //                       right: 10,
                        //                       left: 10,
                        //                       child: Container(
                        //                         padding:
                        //                         EdgeInsets.symmetric(horizontal: 3),
                        //                         decoration: BoxDecoration(
                        //                           color: Theme.of(context)
                        //                               .dividerColor
                        //                               .withOpacity(0.90),
                        //                           borderRadius: BorderRadius.circular(
                        //                               Dimensions.radius20),
                        //                         ),
                        //                         child: Row(
                        //                           mainAxisAlignment:
                        //                           MainAxisAlignment.center,
                        //                           children: [
                        //                             Text(
                        //                               astrologerList[index]
                        //                                   .rating
                        //                                   .toString(),
                        //                               style: openSansRegular.copyWith(
                        //                                   color:
                        //                                   Theme.of(context).cardColor,
                        //                                   fontSize:
                        //                                   Dimensions.fontSize14),
                        //                             ),
                        //                             sizedBoxW5(),
                        //                             Icon(
                        //                               Icons.star,
                        //                               color:
                        //                               Theme.of(context).primaryColor,
                        //                               size: Dimensions.fontSize14,
                        //                             )
                        //                           ],
                        //                         ),
                        //                       ),
                        //                     )
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //             Expanded(
                        //               child: Padding(
                        //                 padding:
                        //                 const EdgeInsets.symmetric(horizontal: 10),
                        //                 child: Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Row(
                        //                       mainAxisAlignment:
                        //                       MainAxisAlignment.spaceBetween,
                        //                       children: [
                        //                         Expanded(
                        //                           child: Row(
                        //                             children: [
                        //                               Flexible(
                        //                                 child: Text(
                        //                                   astrologerList[index].name,
                        //                                 ).tr(),
                        //                               ),
                        //                               SizedBox(
                        //                                 width: 3,
                        //                               ),
                        //                               Image.asset(
                        //                                 Images.right,
                        //                                 height: 16,
                        //                               ),
                        //                             ],
                        //                           ),
                        //                         ),
                        //                         CustomButtonWidget(
                        //                           height: 32,
                        //                           width: 100,
                        //                           onPressed: () {},
                        //                           radius: Dimensions.radius20,
                        //                           transparent: true,
                        //                           borderSideColor: Colors.green,
                        //                           buttonText: '+ Follow',
                        //                           textColor: Colors.green,
                        //                           isBold: false,
                        //                           fontSize: Dimensions.fontSize12,
                        //                         )
                        //                       ],
                        //                     ),
                        //                     astrologerList[index].languageKnown == ""
                        //                         ? const SizedBox()
                        //                         : Row(
                        //                       children: [
                        //                         Icon(
                        //                           Icons.translate,
                        //                           size: 12,
                        //                           color: Colors.grey[600],
                        //                         ),
                        //                         sizedBoxW5(),
                        //                         Text(
                        //                           maxLines: 1,
                        //                           overflow: TextOverflow.ellipsis,
                        //                           astrologerList[index]
                        //                               .languageKnown,
                        //                           style: Get.theme.primaryTextTheme
                        //                               .bodySmall!
                        //                               .copyWith(
                        //                             fontWeight: FontWeight.w300,
                        //                             color: Colors.grey[600],
                        //                           ),
                        //                         ).tr(),
                        //                       ],
                        //                     ),
                        //                     astrologerList[index].allSkill == ""
                        //                         ? const SizedBox()
                        //                         : Row(
                        //                       children: [
                        //                         Icon(
                        //                           Icons.verified,
                        //                           size: 12,
                        //                           color: Colors.grey[600],
                        //                         ),
                        //                         sizedBoxW5(),
                        //                         Text(
                        //                           maxLines: 1,
                        //                           overflow: TextOverflow.ellipsis,
                        //                           astrologerList[index].allSkill,
                        //                           style: Get.theme.primaryTextTheme
                        //                               .bodySmall!
                        //                               .copyWith(
                        //                             fontWeight: FontWeight.w300,
                        //                             color: Colors.grey[600],
                        //                           ),
                        //                         ).tr(),
                        //                       ],
                        //                     ),
                        //                     Row(
                        //                       children: [
                        //                         Icon(
                        //                           Icons.school,
                        //                           size: 12,
                        //                           color: Colors.grey[600],
                        //                         ),
                        //                         sizedBoxW5(),
                        //                         Text(
                        //                           maxLines: 1,
                        //                           overflow: TextOverflow.ellipsis,
                        //                           'Experience : ${astrologerList[index].experienceInYears} Years',
                        //                           style: Get
                        //                               .theme.primaryTextTheme.bodySmall!
                        //                               .copyWith(
                        //                             fontWeight: FontWeight.w300,
                        //                             color: Colors.grey[600],
                        //                           ),
                        //                         ).tr(),
                        //                       ],
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //         Divider(
                        //           color: Theme.of(context).dividerColor.withOpacity(0.20),
                        //         ),
                        //         Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Text(
                        //                   '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${astrologerList[index].charge}/min',
                        //                   style:
                        //                   Get.theme.textTheme.titleMedium!.copyWith(
                        //                     fontSize: Dimensions.fontSize20,
                        //                     fontWeight: FontWeight.w500,
                        //                     letterSpacing: 0,
                        //                     decoration:
                        //                     astrologerList[index].isFreeAvailable ==
                        //                         true
                        //                         ? TextDecoration.lineThrough
                        //                         : null,
                        //                     color: Theme.of(context).dividerColor,
                        //                   ),
                        //                 ).tr(),
                        //                 astrologerList[index].isFreeAvailable == true
                        //                     ? Text(
                        //                   'FREE Chat Available',
                        //                   style: Get.theme.textTheme.titleMedium!
                        //                       .copyWith(
                        //                     fontSize: 10,
                        //                     fontWeight: FontWeight.w700,
                        //                     letterSpacing: 0,
                        //                     color: Colors.green,
                        //                   ),
                        //                 ).tr()
                        //                     : const SizedBox(),
                        //               ],
                        //             ),
                        //             Row(
                        //               children: [
                        //                 CustomButtonWidget(
                        //                   width: 100,
                        //                   height: 40,
                        //                   radius: Dimensions.radius5,
                        //                   fontSize: Dimensions.fontSize12,
                        //                   borderSideColor:
                        //                   Theme.of(context).highlightColor,
                        //                   color: Theme.of(context).highlightColor,
                        //                   textColor: Theme.of(context).cardColor,
                        //                   buttonText: 'Call Now',
                        //                   icon: CupertinoIcons.phone_solid,
                        //                   iconColor: Theme.of(context).cardColor,
                        //                   onPressed: () async {
                        //                     bool isLogin = await global.isLogin();
                        //
                        //                     _logedIn(context, isLogin, index, true);
                        //                   },
                        //                   isBold: false,
                        //                 ),
                        //               ],
                        //             )
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        bottomNavigationController.isMoreDataAvailable == true &&
                                !bottomNavigationController.isAllDataLoaded &&
                                astrologerList.length - 1 == index
                            ? const CircularProgressIndicator()
                            : const SizedBox(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
            global.showOnlyLoaderDialog(context);
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
