// ignore_for_file: must_be_immutable, deprecated_member_use, invalid_use_of_protected_member

import 'dart:developer';
import 'dart:io';

import 'package:AstrowayCustomer/controllers/advancedPanchangController.dart';
import 'package:AstrowayCustomer/controllers/astrologerCategoryController.dart';
import 'package:AstrowayCustomer/controllers/astrologyBlogController.dart';
import 'package:AstrowayCustomer/controllers/astromallController.dart';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/dailyHoroscopeController.dart';
import 'package:AstrowayCustomer/controllers/history_controller.dart';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/controllers/kundliController.dart';
import 'package:AstrowayCustomer/controllers/liveController.dart';
import 'package:AstrowayCustomer/controllers/reviewController.dart';
import 'package:AstrowayCustomer/utils/text_styles.dart';
import 'package:AstrowayCustomer/widget/custom_network_image.dart';
import 'package:AstrowayCustomer/widget/custom_rows_widget.dart';
import 'package:AstrowayCustomer/widget/language_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:AstrowayCustomer/model/kundli_model.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/date_converter.dart';
import 'package:AstrowayCustomer/utils/dimensions.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/utils/sizedboxes.dart';

// import 'package:AstrowayCustomer/views/addMoneyToWallet.dart';
import 'package:AstrowayCustomer/views/astroBlog/astrologyBlogListScreen.dart';
import 'package:AstrowayCustomer/views/astroBlog/astrologyDetailScreen.dart';
import 'package:AstrowayCustomer/views/astrologerNews.dart';
import 'package:AstrowayCustomer/views/astrologerProfile/astrologerProfile.dart';
import 'package:AstrowayCustomer/views/astrologerVideo.dart';
import 'package:AstrowayCustomer/views/astromall/astromallScreen.dart';
import 'package:AstrowayCustomer/views/blog_screen.dart';
import 'package:AstrowayCustomer/views/call/call_history_detail_screen.dart';
import 'package:AstrowayCustomer/views/callScreen.dart';
import 'package:AstrowayCustomer/views/categoryScreen.dart';
import 'package:AstrowayCustomer/views/chat/chat_screen.dart';
import 'package:AstrowayCustomer/views/clientsReviewScreem.dart';
import 'package:AstrowayCustomer/views/kudali/kundliScreen.dart';
import 'package:AstrowayCustomer/views/kundliMatching/kundliMatchingScreen.dart';
import 'package:AstrowayCustomer/views/liveAstrologerList.dart';
import 'package:AstrowayCustomer/views/live_astrologer/live_astrologer_screen.dart';
import 'package:AstrowayCustomer/views/panchangScreen.dart';
import 'package:AstrowayCustomer/views/searchAstrologerScreen.dart';
import 'package:AstrowayCustomer/views/settings/notificationScreen.dart';
import 'package:AstrowayCustomer/views/stories/viewStories.dart';
import 'package:AstrowayCustomer/widget/drawerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

// import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/IntakeController.dart';
import '../controllers/chatController.dart';
import '../controllers/settings_controller.dart';
import '../controllers/splashController.dart';
import '../controllers/walletController.dart';
import '../model/systemFlagNameListModel.dart';
import '../theme/nativeTheme.dart';
import '../utils/fonts.dart';
import '../widget/videoPlayerWidget.dart';
import 'CustomText.dart';
import 'astromall/astroProductScreen.dart';
import 'chatScreen.dart';
import 'daily_horoscope/dailyHoroscopeScreen.dart';
import 'home/components/horizontal_astrologer_view.dart';
import 'home/components/live_video_astrologers_component.dart';

class HomeScreen extends StatefulWidget {
  final KundliModel? userDetails;

  HomeScreen({a, o, this.userDetails}) : super();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  var facebookAppEvents;

  final homeController = Get.find<HomeController>();
  final astrologerCategoryController = Get.find<AstrologerCategoryController>();
  final bottomControllerMain = Get.find<BottomNavigationController>();
  final liveController = Get.find<LiveController>();
  final kundliController = Get.find<KundliController>();
  final panchangController = Get.find<PanchangController>();
  final splashController = Get.find<SplashController>();
  final walletController = Get.find<WalletController>();
  final astromallController = Get.find<AstromallController>();
  final bottomNavigationController = Get.find<BottomNavigationController>();
  final chatController = Get.find<ChatController>();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool isExit = await homeController.onBackPressed();
        if (isExit) {
          exit(0);
        }
        return isExit;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: drawerKey,
        drawer: DrawerWidget(),
        appBar: AppBar(
          toolbarHeight:
              kIsWeb ? MediaQuery.of(context).size.height * 0.16 : null,
          elevation: 0,
          backgroundColor: Get.theme.dividerColor,
          title: InkWell(
            onTap: () {
              try {
                facebookAppEvents.logEvent(
                  name: 'button_clicked',
                  parameters: {
                    'button_id': 'the_clickme_button',
                  },
                );
              } catch (e) {
                print("facebook error:- $e");
              }
            },
            child: Text(
              'ASTROJIO',
              // '${global.getSystemFlagValueForLogin(global.systemFlagNameList.appName)}',
              style: Get.theme.primaryTextTheme.titleLarge!.copyWith(
                fontSize: kIsWeb
                    ? MediaQuery.of(context).size.width * 0.027
                    : MediaQuery.of(context).size.width * 0.043,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          leading: InkWell(
              onTap: () {
                if (kIsWeb) {
                  if (MediaQuery.of(context).size.width <= 700) {
                    drawerKey.currentState!.isDrawerOpen
                        ? drawerKey.currentState!.closeDrawer()
                        : drawerKey.currentState!.openDrawer();
                  }
                } else {
                  drawerKey.currentState!.isDrawerOpen
                      ? drawerKey.currentState!.closeDrawer()
                      : drawerKey.currentState!.openDrawer();
                }
              },
              child: MediaQuery.of(context).size.width >= 700
                  ? SizedBox()
                  : Icon(
                      Icons.menu,
                      color: Theme.of(context).primaryColor,
                    )),
          actions: [
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
            const SizedBox(width: 15),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await homeController.getBanner();
            await homeController.getBlog();
            await homeController.getAstroNews();
            await homeController.getMyOrder();
            await homeController.getAstrologyVideos();
            await homeController.getClientsTestimonals();
            await homeController.getAllStories();
            await bottomControllerMain.getLiveAstrologerList();
            await astromallController.getAstromallCategory(false);
          },
          child: GetBuilder<BottomNavigationController>(
              builder: (bottomController) {
                List<String> getCategoriesFromSystemFlagNameList =
                ['${global.imgBaseurl}${global.getSystemFlagValueForLogin(global.systemFlagNameList.freeKundli)}',
                  '${global.imgBaseurl}${global.getSystemFlagValueForLogin(global.systemFlagNameList.dailyHoroscope)}',
                  '${global.imgBaseurl}${global.getSystemFlagValueForLogin(global.systemFlagNameList.kundliMatching)}',
                  '${global.imgBaseurl}${global.getSystemFlagValueForLogin(global.systemFlagNameList.todayPanchang)}',
                ];
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Theme.of(context).dividerColor,
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
                  sizedBoxDefault(),
                  GetBuilder<HomeController>(builder: (homeController) {
                    return homeController.bannerList.isEmpty
                        ? const SizedBox()
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                // Carousel Slider
                                CarouselSlider.builder(
                                  itemCount: homeController.bannerList.length,
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    height: 18.h,
                                    enlargeCenterPage: true,
                                    viewportFraction: 1.0,
                                    initialPage: 0,
                                    onPageChanged: (index, reason) {
                                      homeController
                                          .setActiveBannerIndex(index);
                                    },
                                  ),
                                  itemBuilder: (context, index, realIndex) {
                                    return GestureDetector(
                                      onTap: () async {
                                        if (homeController
                                                .bannerList[index].bannerType ==
                                            'Astrologer') {
                                          global.showOnlyLoaderDialog(context);
                                          bottomController.astrologerList = [];
                                          bottomController.astrologerList
                                              .clear();
                                          bottomController.isAllDataLoaded =
                                              false;
                                          bottomController.update();
                                          await bottomController
                                              .getAstrologerList(
                                                  isLazyLoading: false);
                                          global.hideLoader();
                                          bottomController.setBottomIndex(1, 0);
                                        } else if (homeController
                                                .bannerList[index].bannerType ==
                                            'Astroshop') {
                                          final AstromallController
                                              astromallController =
                                              Get.find<AstromallController>();
                                          astromallController.astroCategory
                                              .clear();
                                          astromallController.isAllDataLoaded =
                                              false;
                                          astromallController.update();
                                          global.showOnlyLoaderDialog(context);
                                          await astromallController
                                              .getAstromallCategory(false);
                                          global.hideLoader();
                                          Get.to(() => AstromallScreen());
                                        }
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: kIsWeb
                                            ? 'https://corsproxy.io/?${global.imgBaseurl}${homeController.bannerList[index].bannerImage}'
                                            : '${global.imgBaseurl}${homeController.bannerList[index].bannerImage}',
                                        imageBuilder: (context, imageProvider) {
                                          return homeController
                                                  .checkBannerValid(
                                            startDate: homeController
                                                .bannerList[index].fromDate,
                                            endDate: homeController
                                                .bannerList[index].toDate,
                                          )
                                              ? Card(
                                                  child: Container(
                                                    height: Get.height * 0.2,
                                                    width: Get.width,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: imageProvider,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(color: Colors.green);
                                        },
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Card(
                                          child: Container(
                                            color: Colors.grey.shade400,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.error,
                                                      color: Colors.red,
                                                      size: 30.sp),
                                                  Text(
                                                    'Banner Loading error',
                                                    style: TextStyle(
                                                        fontSize: 14.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                sizedBox5(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                      homeController.bannerList.length,
                                      (index) {
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      width: homeController.activeBannerIndex ==
                                              index
                                          ? 8
                                          : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color:
                                            homeController.activeBannerIndex ==
                                                    index
                                                ? Theme.of(context).dividerColor
                                                : Colors.grey,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    );
                                  }),
                                ),
                                // Indicators
                              ],
                            ),
                          );
                  }),
                  sizedBoxDefault(),
                  LiveVideoAstrologersComponent(title: 'Free Live Chat', liveVideo: homeController.liveAstrologersVideo,),


                  // GetBuilder<HomeController>(builder: (homeController) {
                  //   return homeController.bannerList.isEmpty
                  //       ? const SizedBox()
                  //       : Container(
                  //     margin: EdgeInsets.symmetric(horizontal: 10),
                  //     child: ImageSlideshow(
                  //       isLoop: true,
                  //       autoPlayInterval: 3000,
                  //       width: double.infinity,
                  //       height: 25.h,
                  //       initialPage: 0,
                  //       children: List.generate(
                  //           homeController.bannerList.length,
                  //               (index) {
                  //             return GestureDetector(
                  //               onTap: () async {
                  //                 if (homeController
                  //                     .bannerList[index].bannerType ==
                  //                     'Astrologer') {
                  //                   global.showOnlyLoaderDialog(context);
                  //                   bottomController.astrologerList = [];
                  //                   bottomController.astrologerList
                  //                       .clear();
                  //                   bottomController.isAllDataLoaded =
                  //                   false;
                  //                   bottomController.update();
                  //                   await bottomController
                  //                       .getAstrologerList(
                  //                       isLazyLoading: false);
                  //                   global.hideLoader();
                  //                   bottomController.setBottomIndex(1, 0);
                  //                 } else if (homeController
                  //                     .bannerList[index].bannerType ==
                  //                     'Astroshop') {
                  //                   final AstromallController
                  //                   astromallController =
                  //                   Get.find<AstromallController>();
                  //                   astromallController.astroCategory
                  //                       .clear();
                  //                   astromallController.isAllDataLoaded =
                  //                   false;
                  //                   astromallController.update();
                  //                   global.showOnlyLoaderDialog(context);
                  //                   await astromallController
                  //                       .getAstromallCategory(false);
                  //                   global.hideLoader();
                  //                   Get.to(() => AstromallScreen());
                  //                 } else {}
                  //               },
                  //               //                       child:
                  //               // FastCachedImage(
                  //               //                         url:
                  //               //                             '${global.imgBaseurl}${homeController.bannerList[index].bannerImage}',
                  //               //                         fit: BoxFit.cover,
                  //               //                         fadeInDuration:
                  //               //                             const Duration(seconds: 1),
                  //               //                         errorBuilder:
                  //               //                             (context, exception, stacktrace) {
                  //               //                           return Icon(Icons.no_accounts);
                  //               //                         },
                  //               //                       ),
                  //               child: CachedNetworkImage(
                  //                 imageUrl: kIsWeb
                  //                     ? 'https://corsproxy.io/?${global.imgBaseurl}${homeController.bannerList[index].bannerImage}'
                  //                     : '${global.imgBaseurl}${homeController.bannerList[index].bannerImage}',
                  //                 imageBuilder: (context, imageProvider) {
                  //                   return homeController
                  //                       .checkBannerValid(
                  //                     startDate: homeController
                  //                         .bannerList[index].fromDate,
                  //                     endDate: homeController
                  //                         .bannerList[index].toDate,
                  //                   )
                  //                       ? Card(
                  //                     child: Container(
                  //                       height: Get.height * 0.2,
                  //                       width: Get.width,
                  //                       decoration: BoxDecoration(
                  //                         borderRadius:
                  //                         BorderRadius.circular(
                  //                             10),
                  //                         image: DecorationImage(
                  //                           fit: BoxFit.cover,
                  //                           image: imageProvider,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   )
                  //                       : Container(
                  //                     color: Colors.green,
                  //                   );
                  //                 },
                  //                 placeholder: (context, url) => Center(
                  //                     child: CircularProgressIndicator()),
                  //                 errorWidget: (context, url, error) =>
                  //                     Card(
                  //                         child: SizedBox(
                  //                           child: Container(
                  //                             color: Colors.grey.shade400,
                  //                             child: Center(
                  //                               child: Column(
                  //                                 mainAxisAlignment:
                  //                                 MainAxisAlignment.center,
                  //                                 children: [
                  //                                   Icon(
                  //                                     Icons.error,
                  //                                     color: Colors.red,
                  //                                     size: 30.sp,
                  //                                   ),
                  //                                   Text(
                  //                                     'banner Loading error',
                  //                                     style: TextStyle(
                  //                                       fontSize: 14.sp,
                  //                                       fontWeight:
                  //                                       FontWeight.w400,
                  //                                     ),
                  //                                   )
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         )),
                  //               ),
                  //             );
                  //           }),
                  //     ),
                  //   );
                  // }),

                  ///freeservice
                  Container(
                    padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSize20),
                    color: Theme.of(context).primaryColor.withOpacity(0.25),
                    child: Center(
                      child: SizedBox(
                        height: Get.size.height * 0.16,
                        child: ListView.separated(
                          padding: EdgeInsets.only(left: Dimensions.paddingSizeDefault,right: 0,bottom: 0),
                          scrollDirection: Axis.horizontal,
                          itemCount:  getCategoriesFromSystemFlagNameList.length,
                          itemBuilder: (_, i) {
                            List<String> categoryName = ['Kundli', 'Horoscope', 'Match\nMaker', 'Panchang'];
                            return GestureDetector(
                              onTap: () async {
                                try {
                                  switch (categoryName[i]) {
                                    case 'Kundli':
                                      bool isLogin = await global.isLogin();
                                      if (isLogin) {
                                        if (Get.context != null) global.showOnlyLoaderDialog(Get.context);
                                        await kundliController.getKundliList();
                                        global.hideLoader();
                                        Get.to(() => KundaliScreen(), transition: Transition.rightToLeft);
                                      }
                                      break;
                                    case 'Horoscope':
                                      Get.find<DailyHoroscopeController>().selectZodic(0);
                                      await Get.find<DailyHoroscopeController>().getHoroscopeList(
                                        horoscopeId: Get.find<DailyHoroscopeController>().signId,
                                      );
                                      Get.to(() => DailyHoroscopeScreen(), transition: Transition.rightToLeft);
                                      break;
                                    case 'Match\n Maker':
                                      if (Get.context != null) global.showOnlyLoaderDialog(Get.context);
                                      await kundliController.getKundliList();
                                      global.hideLoader();
                                      Get.to(() => KundliMatchingScreen(), transition: Transition.rightToLeft);
                                      break;
                                    case 'Panchang':
                                      DateTime now = DateTime.now();
                                      global.showOnlyLoaderDialog(context);
                                      await kundliController.getBasicPanchangDetail(
                                        day: now.day,
                                        hour: now.hour,
                                        min: now.minute,
                                        month: now.month,
                                        year: now.year,
                                        lat: 21.1255,
                                        lon: 73.1122,
                                        tzone: 5,
                                      );
                                      panchangController.getPanchangVedic(now);
                                      global.hideLoader();
                                      Get.to(() => PanchangScreen(), transition: Transition.rightToLeft);
                                      break;
                                    default:
                                      print('No navigation defined for this category');
                                      break;
                                  }
                                } catch (e) {
                                  print('Error in navigation: $e');
                                }
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radius10),
                                      gradient: LinearGradient(
                                        colors: [Colors.black, Colors.black.withOpacity(0.70), Colors.black],
                                        stops: [0.0, 0.5, 1.0],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        height: 5.h,
                                        width: 5.h,
                                        child: ClipRRect(
                                          child: CachedNetworkImage(
                                            imageUrl: getCategoriesFromSystemFlagNameList[i],
                                            placeholder: (context, url) =>
                                            const Center(child: CircularProgressIndicator()),
                                            errorWidget: (context, url, error) =>
                                            const Icon(Icons.no_accounts, size: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 1.w),
                                  Text(categoryName[i], textAlign: TextAlign.center,
                                    style: openSansRegular.copyWith(fontSize: Dimensions.fontSize14),
                                  ).tr(),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) => sizedBoxW15(),
                        ),
                      ),
                    ),
                  ),
                  LiveVideoAstrologersComponent( title: 'Free Live Webinar', liveVideo: homeController.liveAstrologersVideo,),
                  LiveVideoAstrologersComponent( title: 'Free Live Vastu',isBlackColor: true, liveVideo: homeController.liveAstrologersVideo,),
                  HorizontalAstrologerView(
                    isColor: true,
                    astrologerList:
                    bottomNavigationController.skilledAstrologerList, title: 'Vedic Astrologers', tap: () {
                      Get.to(ChatScreen(isBackButton: true,));
                  },
                  ),
                  HorizontalAstrologerView(
                    astrologerList:
                    bottomNavigationController.tarotAstrologerList, title: 'Tarott Astrologers', tap: () {
                    Get.to(ChatScreen(isBackButton: true,));
                  },
                  ),
                  ///Stories
                  GetBuilder<HomeController>(builder: (homeController) {
                    return Column(
                      children: [
                        homeController.allStories.length == 0
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Astro Stories',
                                      style: Get
                                          .theme.primaryTextTheme.titleMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w500),
                                    ).tr(),
                                  ],
                                ),
                              ),
                        homeController.allStories.length == 0
                            ? SizedBox()
                            : Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 100,
                                child: ListView.builder(
                                    shrinkWrap: false,
                                    itemCount: homeController.allStories.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(left: 4),
                                        child: InkWell(
                                            onTap: () {
                                              homeController
                                                  .getAstroStory(homeController
                                                      .allStories[index]
                                                      .astrologerId
                                                      .toString())
                                                  .then((value) {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewStoriesScreen(
                                                            profile:
                                                                "${global.imgBaseurl}${homeController.allStories[index].profileImage}",
                                                            name: homeController
                                                                .allStories[
                                                                    index]
                                                                .name
                                                                .toString(),
                                                            isprofile: false,
                                                            astroId: int.parse(
                                                                homeController
                                                                    .allStories[
                                                                        index]
                                                                    .astrologerId
                                                                    .toString()),
                                                          )),
                                                );
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor: homeController
                                                              .allStories[index]
                                                              .allStoriesViewed
                                                              .toString() ==
                                                          "1"
                                                      ? Colors.grey
                                                      : Colors.red,
                                                  child: CircleAvatar(
                                                    radius: 27,
                                                    backgroundColor:
                                                        Colors.yellow,
                                                    backgroundImage: NetworkImage(
                                                        "${global.imgBaseurl}${homeController.allStories[index].profileImage}"),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 16.w,
                                                  child: Text(
                                                    homeController
                                                        .allStories[index].name
                                                        .toString(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 15.sp),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      );
                                    }),
                              ),
                      ],
                    );
                  }),
                  //--------------------------------------TOP BANNER-----------------------------------------------------------------------------
                  // Container(
                  //   margin: EdgeInsets.symmetric(
                  //       horizontal: FontSizes(context).width2()),
                  //   height: FontSizes(context).height23(),
                  //   child: PageView.builder(
                  //     controller: _pageController,
                  //     itemCount: 1,
                  //     onPageChanged: (page) {
                  //       setState(() {
                  //         _pageIndex = page;
                  //       });
                  //     },
                  //     itemBuilder: (context, index) {
                  //       return Container(
                  //           decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(15),
                  //               border: Border.all(
                  //                   color: colorGrey.withOpacity(0.4))),
                  //           margin: EdgeInsets.only(
                  //               bottom: screenHeight(context) * 0.02,
                  //               top: screenHeight(context) * 0.01),
                  //           child: Image.network(
                  //             '${global.imgBaseurl}${global.getSystemFlagValueForLogin(global.systemFlagNameList.TopBanner)}',
                  //             fit: BoxFit.fill,
                  //           ));
                  //     },
                  //   ),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     ...List.generate(
                  //       1,
                  //       (index) => Container(
                  //         margin: EdgeInsets.symmetric(horizontal: 3),
                  //         height: 6,
                  //         width: 6,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(3),
                  //             color: _pageIndex == index
                  //                 ? Get.theme.primaryColor
                  //                 : colorGrey),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  //--------------------------------ASTROLOGER BLOCK------------------------------------------------------------------------------------

                  GetBuilder<HomeController>(builder: (homeController) {
                    return homeController.myOrders.isEmpty
                        ? const SizedBox()
                        : SizedBox(
                            height: 160,
                            child: Card(
                              elevation: 0,
                              margin: EdgeInsets.only(top: 6),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'My orders',
                                                style: Get
                                                    .theme
                                                    .primaryTextTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ).tr(),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              final HistoryController
                                                  historyController =
                                                  Get.find<HistoryController>();
                                              global.showOnlyLoaderDialog(
                                                  context);
                                              await historyController
                                                  .getPaymentLogs(
                                                      global.currentUserId!,
                                                      false);
                                              historyController
                                                  .walletTransactionList = [];
                                              historyController
                                                  .walletTransactionList
                                                  .clear();
                                              historyController
                                                  .walletAllDataLoaded = false;
                                              historyController.update();
                                              await historyController
                                                  .getWalletTransaction(
                                                      global.currentUserId!,
                                                      false);
                                              historyController
                                                  .astroMallHistoryList = [];
                                              historyController
                                                  .astroMallHistoryList
                                                  .clear();
                                              historyController
                                                  .isAllDataLoaded = false;
                                              historyController.update();
                                              await historyController
                                                  .getAstroMall(
                                                      global.currentUserId!,
                                                      false);
                                              historyController
                                                  .callHistoryList = [];
                                              historyController.callHistoryList
                                                  .clear();
                                              historyController
                                                  .callAllDataLoaded = false;
                                              historyController.update();
                                              await historyController
                                                  .getCallHistory(
                                                      global.currentUserId!,
                                                      false);
                                              historyController
                                                  .chatHistoryList = [];
                                              historyController.chatHistoryList
                                                  .clear();
                                              historyController
                                                  .chatAllDataLoaded = false;
                                              historyController.update();
                                              await historyController
                                                  .getChatHistory(
                                                      global.currentUserId!,
                                                      false);
                                              global.hideLoader();
                                              bottomController.setBottomIndex(
                                                  4, 0);
                                            },
                                            child: Text(
                                              'View All',
                                              style: Get.theme.primaryTextTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.blue[500],
                                              ),
                                            ).tr(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GetBuilder<HomeController>(
                                      builder: (c) {
                                        return Expanded(
                                          child: ListView.builder(
                                            itemCount:
                                                homeController.myOrders.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.only(
                                                top: 5, left: 10),
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                  onTap: () async {
                                                    if (homeController
                                                            .myOrders[index]
                                                            .orderType ==
                                                        "call") {
                                                      if (homeController
                                                              .myOrders[index]
                                                              .callId !=
                                                          0) {
                                                        IntakeController
                                                            intakeController =
                                                            Get.find<
                                                                IntakeController>();
                                                        HistoryController
                                                            historyController =
                                                            Get.find<
                                                                HistoryController>();
                                                        global
                                                            .showOnlyLoaderDialog(
                                                                context);
                                                        await intakeController
                                                            .getFormIntakeData();
                                                        await historyController
                                                            .getCallHistoryById(
                                                                homeController
                                                                    .myOrders[
                                                                        index]
                                                                    .callId!);
                                                        global.hideLoader();
                                                        Get.to(() =>
                                                            CallHistoryDetailScreen(
                                                              astrologerId:
                                                                  homeController
                                                                      .myOrders[
                                                                          index]
                                                                      .astrologerId!,
                                                              astrologerProfile:
                                                                  homeController
                                                                          .myOrders[
                                                                              index]
                                                                          .profileImage ??
                                                                      "",
                                                              index: index,
                                                              callType: homeController
                                                                      .myOrders[
                                                                          index]
                                                                      .call_type ??
                                                                  0,
                                                            ));
                                                      }
                                                    } else if (homeController
                                                            .myOrders[index]
                                                            .orderType ==
                                                        "chat") {
                                                      if (homeController
                                                              .myOrders[index]
                                                              .firebaseChatId !=
                                                          "") {
                                                        ChatController
                                                            chatController =
                                                            Get.find<
                                                                ChatController>();
                                                        global
                                                            .showOnlyLoaderDialog(
                                                                context);
                                                        await chatController
                                                            .getuserReview(
                                                                homeController
                                                                    .myOrders[
                                                                        index]
                                                                    .astrologerId!);
                                                        global.hideLoader();
                                                        Get.to(() =>
                                                            AcceptChatScreen(
                                                              flagId: 0,
                                                              profileImage: homeController
                                                                      .myOrders[
                                                                          index]
                                                                      .profileImage ??
                                                                  "",
                                                              astrologerName: homeController
                                                                      .myOrders[
                                                                          index]
                                                                      .astrologerName ??
                                                                  "Astrologer",
                                                              fireBasechatId:
                                                                  homeController
                                                                      .myOrders[
                                                                          index]
                                                                      .firebaseChatId!,
                                                              astrologerId:
                                                                  homeController
                                                                      .myOrders[
                                                                          index]
                                                                      .astrologerId!,
                                                              chatId:
                                                                  homeController
                                                                      .myOrders[
                                                                          index]
                                                                      .id!,
                                                              duration: int.parse(
                                                                      homeController
                                                                              .myOrders[index]
                                                                              .totalMin ??
                                                                          "100")
                                                                  .toString(),
                                                            ));
                                                      } else {
                                                        log("firbaseid null");
                                                      }
                                                    }
                                                  },
                                                  child: Card(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 65,
                                                          width: 65,
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Get.theme
                                                                    .primaryColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7),
                                                          ),
                                                          child: CircleAvatar(
                                                            radius: 35,
                                                            backgroundColor:
                                                                Colors.white,
                                                            child: homeController
                                                                        .myOrders[
                                                                            index]
                                                                        .profileImage ==
                                                                    ""
                                                                ? Image.asset(
                                                                    Images
                                                                        .deafultUser,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height: 50,
                                                                    width: 40,
                                                                  )
                                                                : CachedNetworkImage(
                                                                    imageUrl:
                                                                        '${global.imgBaseurl}${homeController.myOrders[index].profileImage}',
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        const Center(
                                                                            child:
                                                                                CircularProgressIndicator()),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image
                                                                            .asset(
                                                                      Images
                                                                          .deafultUser,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      height:
                                                                          50,
                                                                      width: 40,
                                                                    ),
                                                                  ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text('${homeController.myOrders[index].astrologerName}')
                                                                  .tr(),
                                                              Text(
                                                                DateConverter.dateTimeStringToDateOnly(
                                                                    homeController
                                                                        .myOrders[
                                                                            index]
                                                                        .createdAt
                                                                        .toString()),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                              SizedBox(
                                                                height: 1.h,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      if (homeController
                                                                              .myOrders[
                                                                                  index]
                                                                              .orderType ==
                                                                          "call") {
                                                                        if (homeController.myOrders[index].callId !=
                                                                            0) {
                                                                          IntakeController
                                                                              intakeController =
                                                                              Get.find<IntakeController>();
                                                                          HistoryController
                                                                              historyController =
                                                                              Get.find<HistoryController>();
                                                                          global
                                                                              .showOnlyLoaderDialog(context);
                                                                          await intakeController
                                                                              .getFormIntakeData();
                                                                          await historyController.getCallHistoryById(homeController
                                                                              .myOrders[index]
                                                                              .callId!);
                                                                          global
                                                                              .hideLoader();
                                                                          Get.to(() =>
                                                                              CallHistoryDetailScreen(
                                                                                astrologerId: homeController.myOrders[index].astrologerId!,
                                                                                astrologerProfile: homeController.myOrders[index].profileImage ?? "",
                                                                                index: index,
                                                                                callType: homeController.myOrders[index].call_type ?? 10,
                                                                              ));
                                                                        }
                                                                      } else if (homeController
                                                                              .myOrders[index]
                                                                              .orderType ==
                                                                          "chat") {
                                                                        if (homeController.myOrders[index].firebaseChatId !=
                                                                            "") {
                                                                          ChatController
                                                                              chatController =
                                                                              Get.find<ChatController>();
                                                                          global
                                                                              .showOnlyLoaderDialog(context);
                                                                          await chatController.getuserReview(homeController
                                                                              .myOrders[index]
                                                                              .astrologerId!);
                                                                          global
                                                                              .hideLoader();
                                                                          Get.to(() =>
                                                                              AcceptChatScreen(
                                                                                flagId: 0,
                                                                                profileImage: homeController.myOrders[index].profileImage ?? "",
                                                                                astrologerName: homeController.myOrders[index].astrologerName ?? "Astrologer",
                                                                                fireBasechatId: homeController.myOrders[index].firebaseChatId!,
                                                                                astrologerId: homeController.myOrders[index].astrologerId!,
                                                                                chatId: homeController.myOrders[index].id!,
                                                                                duration: int.parse(homeController.myOrders[index].totalMin ?? "100").toString(),
                                                                              ));
                                                                        }
                                                                      }
                                                                    },
                                                                    child: CircleAvatar(
                                                                        radius:
                                                                            13,
                                                                        child: homeController.myOrders[index].orderType ==
                                                                                "call"
                                                                            ? Icon(Icons.play_arrow,
                                                                                size: 13)
                                                                            : Icon(Icons.message, size: 13)),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        global.showOnlyLoaderDialog(
                                                                            context);
                                                                        final BottomNavigationController
                                                                            bottomNavigationController =
                                                                            Get.find<BottomNavigationController>();
                                                                        Get.find<ReviewController>().getReviewData(
                                                                            homeController.myOrders[index].astrologerId ??
                                                                                0);
                                                                        await bottomNavigationController.getAstrologerbyId(
                                                                            homeController.myOrders[index].astrologerId ??
                                                                                0);
                                                                        global
                                                                            .hideLoader();
                                                                        if (bottomNavigationController
                                                                            .astrologerbyId
                                                                            .isNotEmpty) {
                                                                          Get.to(() =>
                                                                              AstrologerProfile(
                                                                                index: index,
                                                                              ));
                                                                        }
                                                                      },
                                                                      child:
                                                                          CircleAvatar(
                                                                        radius:
                                                                            13,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .call,
                                                                          size:
                                                                              13,
                                                                        ),
                                                                      )),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ));
                                            },
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                  }),
                  //--------------------------------------LIVE ASTROLOGER LIST---------------------------------
                  GetBuilder<BottomNavigationController>(builder: (c) {
                    return Get.find<BottomNavigationController>()
                                .liveAstrologer
                                .length ==
                            0
                        ? const SizedBox()
                        : SizedBox(
                            height: 38.h,
                            child: Card(
                              elevation: 0,
                              margin: EdgeInsets.only(top: 6),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Live Astrologers',
                                                style: Get
                                                    .theme
                                                    .primaryTextTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ).tr(),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    global.showOnlyLoaderDialog(
                                                        context);
                                                    await bottomControllerMain
                                                        .getLiveAstrologerList();
                                                    global.hideLoader();
                                                  },
                                                  child: Icon(
                                                    Icons.refresh,
                                                    size: 20,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              Get.to(() =>
                                                  LiveAstrologerListScreen());
                                            },
                                            child: Text(
                                              'View All',
                                              style: Get.theme.primaryTextTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.blue[500],
                                              ),
                                            ).tr(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GetBuilder<BottomNavigationController>(
                                      builder: (c) {
                                        return Expanded(
                                          child: ListView.builder(
                                            itemCount: Get.find<
                                                    BottomNavigationController>()
                                                .liveAstrologer
                                                .length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.only(
                                                top: 10, left: 10),
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                  onTap: () async {
                                                    bottomControllerMain
                                                        .anotherLiveAstrologers = Get
                                                            .find<
                                                                BottomNavigationController>()
                                                        .liveAstrologer
                                                        .where((element) =>
                                                            element
                                                                .astrologerId !=
                                                            Get.find<
                                                                    BottomNavigationController>()
                                                                .liveAstrologer[
                                                                    index]
                                                                .astrologerId)
                                                        .toList();
                                                    bottomControllerMain
                                                        .update();
                                                    print("channel name");
                                                    print(
                                                        "${Get.find<BottomNavigationController>().liveAstrologer[index].channelName}");
                                                    await liveController
                                                        .getWaitList(Get.find<
                                                                BottomNavigationController>()
                                                            .liveAstrologer[
                                                                index]
                                                            .channelName);
                                                    int index2 = liveController
                                                        .waitList
                                                        .indexWhere((element) =>
                                                            element.userId ==
                                                            global
                                                                .currentUserId);
                                                    if (index2 != -1) {
                                                      liveController
                                                              .isImInWaitList =
                                                          true;
                                                      liveController.update();
                                                    } else {
                                                      liveController
                                                              .isImInWaitList =
                                                          false;
                                                      liveController.update();
                                                    }
                                                    liveController.isImInLive =
                                                        true;
                                                    liveController
                                                        .isJoinAsChat = false;
                                                    liveController
                                                        .isLeaveCalled = false;
                                                    liveController.update();
                                                    bool isLogin =
                                                        await global.isLogin();
                                                    if (isLogin) {
                                                      Get.to(
                                                        () =>
                                                            LiveAstrologerScreen(
                                                          token: Get.find<
                                                                  BottomNavigationController>()
                                                              .liveAstrologer[
                                                                  index]
                                                              .token,
                                                          channel: Get.find<
                                                                  BottomNavigationController>()
                                                              .liveAstrologer[
                                                                  index]
                                                              .channelName,
                                                          astrologerName: Get.find<
                                                                  BottomNavigationController>()
                                                              .liveAstrologer[
                                                                  index]
                                                              .name,
                                                          astrologerProfile: Get
                                                                  .find<
                                                                      BottomNavigationController>()
                                                              .liveAstrologer[
                                                                  index]
                                                              .profileImage,
                                                          astrologerId: Get.find<
                                                                  BottomNavigationController>()
                                                              .liveAstrologer[
                                                                  index]
                                                              .astrologerId,
                                                          isFromHome: true,
                                                          charge: Get.find<
                                                                  BottomNavigationController>()
                                                              .liveAstrologer[
                                                                  index]
                                                              .charge,
                                                          isForLiveCallAcceptDecline:
                                                              false,
                                                          isFromNotJoined:
                                                              false,
                                                          isFollow: Get.find<
                                                                  BottomNavigationController>()
                                                              .liveAstrologer[
                                                                  index]
                                                              .isFollow!,
                                                          videoCallCharge: Get.find<
                                                                  BottomNavigationController>()
                                                              .liveAstrologer[
                                                                  index]
                                                              .videoCallRate,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(FontSizes(
                                                                      context)
                                                                  .width2())),
                                                      margin: EdgeInsets.symmetric(
                                                          horizontal:
                                                              FontSizes(context)
                                                                  .width1()),
                                                      child: Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius
                                                                .circular(FontSizes(
                                                                        context)
                                                                    .width2()),
                                                            child: Get.find<BottomNavigationController>()
                                                                        .liveAstrologer[
                                                                            index]
                                                                        .profileImage !=
                                                                    ""
                                                                ? Container(
                                                                    width: 120,
                                                                    height: 200,
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                4),
                                                                    child:
                                                                        Image(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      colorBlendMode:
                                                                          BlendMode
                                                                              .darken,
                                                                      color: Colors
                                                                          .black45,
                                                                      width: FontSizes(
                                                                              context)
                                                                          .width30(),
                                                                      height: FontSizes(
                                                                              context)
                                                                          .height20(),
                                                                      image:
                                                                          NetworkImage(
                                                                        "${global.imgBaseurl}${Get.find<BottomNavigationController>().liveAstrologer[index].profileImage}",
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    //NO image then it will set
                                                                    width: 120,
                                                                    height: 200,
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                4),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.black.withOpacity(0.3),
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        border: Border.all(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              214,
                                                                              214,
                                                                              214),
                                                                        ),
                                                                        image: DecorationImage(
                                                                            fit: BoxFit.cover,
                                                                            image: AssetImage(
                                                                              Images.deafultUser,
                                                                            ),
                                                                            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken))),
                                                                  ),
                                                          ),
                                                          Positioned(
                                                            right: FontSizes(
                                                                    context)
                                                                .width2(),
                                                            top: FontSizes(
                                                                    context)
                                                                .height01(),
                                                            child: Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        FontSizes(context)
                                                                            .width2()),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(FontSizes(context)
                                                                            .width2()),
                                                                    color: Get
                                                                        .theme
                                                                        .primaryColor),
                                                                child:
                                                                    CustomText(
                                                                  text: "Live",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      whiteColor,
                                                                )),
                                                          ),
                                                          Positioned(
                                                            left: FontSizes(
                                                                    context)
                                                                .width2(),
                                                            bottom: FontSizes(
                                                                    context)
                                                                .height1(),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CustomText(
                                                                  text:
                                                                      "${Get.find<BottomNavigationController>().liveAstrologer[index].name}",
                                                                  color:
                                                                      whiteColor,
                                                                  maxLine: 1,
                                                                  fontsize: FontSizes(
                                                                          context)
                                                                      .font4(),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                                CustomText(
                                                                  text:
                                                                      "${Get.find<BottomNavigationController>().liveAstrologer[index].videoCallRate} /min",
                                                                  color: Get
                                                                      .theme
                                                                      .primaryColor,
                                                                  maxLine: 1,
                                                                  fontsize: FontSizes(
                                                                          context)
                                                                      .font3(),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      )));
                                            },
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                  }),
                  //---------- Categories  ----------------------------------------
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Categories',
                              style: Get.theme.primaryTextTheme.titleMedium!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ).tr(),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => CategoryScreen());
                              },
                              child: Text(
                                'View All',
                                style: Get.theme.primaryTextTheme.bodySmall!
                                    .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blue[500],
                                ),
                              ).tr(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: FontSizes(context).height2(),
                  ),
                  GetBuilder<AstrologerCategoryController>(
                      builder: (astrologyCat) {
                    return Container(
                        height: 20.h,
                        // margin: EdgeInsets.symmetric(
                        //     horizontal: FontSizes(context).width3()),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: astrologyCat.categoryList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              print(
                                  "=================> CATEGORY IMAGES ${global.imgBaseurl}${astrologyCat.categoryList[index].image}");
                              return InkWell(
                                onTap: () async {
                                  global.showOnlyLoaderDialog(context);
                                  bottomNavigationController.astrologerList =
                                      [];
                                  bottomNavigationController.astrologerList
                                      .clear();
                                  bottomNavigationController.isAllDataLoaded =
                                      false;
                                  bottomNavigationController.update();
                                  chatController.isSelected = index;
                                  chatController.update();
                                  await bottomNavigationController.astroCat(
                                      id: astrologyCat.categoryList[index].id!,
                                      isLazyLoading: false);
                                  global.hideLoader();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CallScreen(
                                                flag: 1,
                                              )));
                                },
                                child: Container(
                                  width: 80,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: FontSizes(context).width13(),
                                        backgroundImage: NetworkImage(
                                            "${global.imgBaseurl}${astrologyCat.categoryList[index].image}"),
                                      ),
                                      SizedBox(
                                        height: FontSizes(context).height1(),
                                      ),
                                      CustomText(
                                        text:
                                            "${astrologyCat.categoryList[index].name}",
                                        textAlign: TextAlign.center,
                                        maxLine: 2,
                                        fontWeight: FontWeight.w600,
                                        fontsize: FontSizes(context).font3(),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }));
                  }),

                  //---------- ASTROLOGERS BLOCK----------------------------------------

                  GetBuilder<BottomNavigationController>(
                      builder: (bottomNavigationController) {
                    return bottomNavigationController.astrologerList.isEmpty
                        ? const SizedBox()
                        : SizedBox(
                            height: 34.h,
                            child: Card(
                              elevation: 0,
                              margin: EdgeInsets.only(top: 6),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: FontSizes(context)
                                                    .width3()),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Astrologers',
                                                  style: Get
                                                      .theme
                                                      .primaryTextTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ).tr(),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              bottomController.bottomNavIndex =
                                                  1;
                                              bottomController.update();
                                            },
                                            child: Text(
                                              'View All',
                                              style: Get.theme.primaryTextTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.blue[500],
                                              ),
                                            ).tr(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.w,
                                    ),
                                    Container(
                                      height: FontSizes(context).height25(),
                                      child: GridView.builder(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: bottomNavigationController
                                              .astrologerList.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisSpacing:
                                                FontSizes(context).height01(),
                                            mainAxisSpacing:
                                                FontSizes(context).width2(),
                                            mainAxisExtent:
                                                FontSizes(context).width70(),
                                            crossAxisCount: 2,
                                          ),
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () async {
                                                Get.find<ReviewController>()
                                                    .getReviewData(
                                                        bottomNavigationController
                                                            .astrologerList[
                                                                index]
                                                            .id!);
                                                global.showOnlyLoaderDialog(
                                                    context);
                                                await bottomNavigationController
                                                    .getAstrologerbyId(
                                                        bottomNavigationController
                                                            .astrologerList[
                                                                index]
                                                            .id!);
                                                global.hideLoader();
                                                await Get.to(
                                                    () => AstrologerProfile(
                                                          index: index,
                                                        ));
                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      width: FontSizes(context)
                                                          .width25(),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(FontSizes(
                                                                      context)
                                                                  .width4()),
                                                          color: lightGrey),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                FontSizes(
                                                                        context)
                                                                    .width4()),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              '${global.imgBaseurl}${bottomNavigationController.astrologerList[index].profileImage}',
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Center(
                                                                  child:
                                                                      CircularProgressIndicator()),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                            Images.deafultUser,
                                                            fit: BoxFit.cover,
                                                            height: 50,
                                                            width: 40,
                                                          ),
                                                        ),
                                                      )),
                                                  SizedBox(width: FontSizes(context).width2(),),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomText(
                                                          text: bottomNavigationController
                                                              .astrologerList[
                                                                  index]
                                                              .name!,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color: blackColor,
                                                          fontsize:
                                                              FontSizes(context)
                                                                  .font04(),
                                                          maxLine: 1,
                                                        ),
                                                        CustomText(
                                                          text:
                                                              '${bottomNavigationController.astrologerList[index].primarySkill}',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: colorGrey,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontsize:
                                                              FontSizes(context)
                                                                  .font03(),
                                                          maxLine: 1,
                                                        ),
                                                        CustomText(
                                                          text:
                                                              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${bottomNavigationController.astrologerList[index].charge}/min',
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: colorGrey,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontsize:
                                                              FontSizes(context)
                                                                  .font03(),
                                                          maxLine: 1,
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              FontSizes(context)
                                                                  .height1(),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            CustomText(
                                                              text:
                                                                  '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${bottomNavigationController.astrologerList[index].charge}/min',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: greenColor,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              fontsize: FontSizes(
                                                                      context)
                                                                  .font4(),
                                                              maxLine: 1,
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColorDark,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          FontSizes(context)
                                                                              .width6())),
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: FontSizes(
                                                                          context)
                                                                      .height1(),
                                                                  horizontal: FontSizes(
                                                                          context)
                                                                      .width6()),
                                                              child: CustomText(
                                                                text: "Connect",
                                                                fontsize: FontSizes(
                                                                        context)
                                                                    .font03(),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color:
                                                                    whiteColor,
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                  }),
                  GetBuilder<AstromallController>(
                      builder: (astromallController) {
                    return astromallController.astroCategory.length == 0
                        ? SizedBox()
                        : SizedBox(
                            height: 200,
                            child: Card(
                              elevation: 0,
                              margin: EdgeInsets.only(top: 6),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Shop Now',
                                                  style: Get
                                                      .theme
                                                      .primaryTextTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ).tr(),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              final AstromallController
                                                  astromallController =
                                                  Get.find<
                                                      AstromallController>();
                                              astromallController.astroCategory
                                                  .clear();
                                              astromallController
                                                  .isAllDataLoaded = false;
                                              astromallController.update();
                                              global.showOnlyLoaderDialog(
                                                  context);
                                              await astromallController
                                                  .getAstromallCategory(false);
                                              global.hideLoader();
                                              Get.to(() => AstromallScreen());
                                            },
                                            child: Text(
                                              'View All',
                                              style: Get.theme.primaryTextTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.blue[500],
                                              ),
                                            ).tr(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: ListView.builder(
                                      itemCount: astromallController
                                          .astroCategory.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.only(
                                          top: 10,
                                          left: 10,
                                          bottom: 2,
                                          right: 10),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            global
                                                .showOnlyLoaderDialog(context);
                                            astromallController.astroProduct
                                                .clear();
                                            astromallController
                                                    .isAllDataLoadedForProduct =
                                                false;
                                            astromallController.productCatId =
                                                astromallController
                                                    .astroCategory[index].id;
                                            astromallController.update();
                                            await astromallController
                                                .getAstromallProduct(
                                                    astromallController
                                                        .astroCategory[index]
                                                        .id,
                                                    false);
                                            global.hideLoader();
                                            Get.to(
                                              () => AstroProductScreen(
                                                appbarTitle: astromallController
                                                    .astroCategory[index].name,
                                                productCategoryId:
                                                    astromallController
                                                        .astroCategory[index]
                                                        .id,
                                                sliderImage:
                                                    "${global.imgBaseurl}${astromallController.astroCategory[index].categoryImage}",
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 80,
                                            margin: const EdgeInsets.only(
                                                top: 4, bottom: 1, right: 15),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                    child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 35.sp,
                                                  backgroundImage: NetworkImage(
                                                      "${global.imgBaseurl}${astromallController.astroCategory[index].categoryImage}"),
                                                )),
                                                Container(
                                                  color: Colors.white,
                                                  width: Get.width,
                                                  height: 45,
                                                  alignment: Alignment.center,
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Text(
                                                    maxLines: 2,
                                                    astromallController
                                                        .astroCategory[index]
                                                        .name,
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Get
                                                        .textTheme.bodyMedium!
                                                        .copyWith(
                                                            fontSize: 11,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ).tr(),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          );
                  }),
                  //---------- LATEST BLOG ----------------------------------------
                  SizedBox(
                    height: FontSizes(context).height1(),
                  ),
                  GetBuilder<HomeController>(
                    builder: (homeController) {
                      return homeController.blogList.length == 0
                          ? SizedBox()
                          : SizedBox(
                              height: 250,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 5),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Blog',
                                            style: Get.theme.primaryTextTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ).tr(),
                                          GestureDetector(
                                            onTap: () async {
                                              BlogController blogController =
                                                  Get.find<BlogController>();
                                              global.showOnlyLoaderDialog(
                                                  context);
                                              blogController.astrologyBlogs =
                                                  [];
                                              blogController.astrologyBlogs
                                                  .clear();
                                              blogController.isAllDataLoaded =
                                                  false;
                                              blogController.update();
                                              await blogController
                                                  .getAstrologyBlog(
                                                      "", false);
                                              global.hideLoader();
                                              Get.to(() =>
                                                  AstrologyBlogScreen());
                                            },
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
                                    Expanded(child:
                                        GetBuilder<HomeController>(
                                            builder: (homeControllerr) {
                                      return ListView.separated(
                                        itemCount:
                                            homeController.blogList.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 10, bottom: 10),
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              global.showOnlyLoaderDialog(
                                                  context);
                                              await homeController
                                                  .incrementBlogViewer(
                                                      homeController
                                                          .blogList[index]
                                                          .id);
                                              homeController.homeBlogVideo(
                                                  homeController
                                                      .blogList[index]
                                                      .blogImage);
                                              global.hideLoader();
                                              Get.to(() =>
                                                  AstrologyBlogDetailScreen(
                                                    image:
                                                        "${homeController.blogList[index].blogImage}",
                                                    title: homeController
                                                        .blogList[index]
                                                        .title,
                                                    description:
                                                        homeController
                                                            .blogList[index]
                                                            .description!,
                                                    extension: homeController
                                                        .blogList[index]
                                                        .extension!,
                                                    controller: homeController
                                                        .homeVideoPlayerController,
                                                  ));
                                            },
                                            child: Container(
                                              width: 220,
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 0.5,color: Theme.of(context).primaryColor),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        0),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                children: [
                                                  Stack(children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft: Radius
                                                              .circular(0),
                                                          topRight: Radius
                                                              .circular(0),
                                                        ),
                                                        child: homeController
                                                                        .blogList[
                                                                            index]
                                                                        .extension ==
                                                                    'mp4' ||
                                                                homeController
                                                                        .blogList[index]
                                                                        .extension ==
                                                                    'gif'
                                                            ? Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                children: [
                                                                  CachedNetworkImage(
                                                                    imageUrl:
                                                                        '${global.imgBaseurl}${homeController.blogList[index].previewImage}',
                                                                    imageBuilder:
                                                                        (context, imageProvider) =>
                                                                            Container(
                                                                      height: 160,
                                                                      width:
                                                                          Get.width,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(0),
                                                                        image:
                                                                            DecorationImage(
                                                                          fit: BoxFit.fill,
                                                                          image: imageProvider,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    placeholder:
                                                                        (context, url) =>
                                                                            const Center(child: CircularProgressIndicator()),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image.asset(
                                                                      Images
                                                                          .blog,
                                                                      height:
                                                                          Get.height * 0.15,
                                                                      width:
                                                                          Get.width,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .play_arrow,
                                                                    size:
                                                                        40,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ],
                                                              )
                                                            : CachedNetworkImage(
                                                                imageUrl:
                                                                    '${global.imgBaseurl}${homeController.blogList[index].blogImage}',
                                                                imageBuilder:
                                                                    (context,
                                                                            imageProvider) =>
                                                                        Container(
                                                                  height:
                                                                      110,
                                                                  width: Get
                                                                      .width,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(10),
                                                                    image:
                                                                        DecorationImage(
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      image:
                                                                          imageProvider,
                                                                    ),
                                                                  ),
                                                                ),
                                                                placeholder: (context,
                                                                        url) =>
                                                                    const Center(
                                                                        child:
                                                                            CircularProgressIndicator()),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Image
                                                                        .asset(
                                                                  Images
                                                                      .blog,
                                                                  height: Get
                                                                          .height *
                                                                      0.15,
                                                                  width: Get
                                                                      .width,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              )),
                                                    Positioned(
                                                      right: 7,
                                                      child: ElevatedButton(
                                                          style:
                                                              ElevatedButton
                                                                  .styleFrom(
                                                            padding:
                                                                EdgeInsets
                                                                    .zero,
                                                            backgroundColor:
                                                                Colors.white
                                                                    .withOpacity(
                                                                        0.5),
                                                            elevation: 0,
                                                            minimumSize:
                                                                const Size(
                                                                    50, 30),
                                                            //height
                                                            maximumSize:
                                                                const Size(
                                                                    60, 30),
                                                            //width
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        50.0)),
                                                          ),
                                                          onPressed: () {},
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .visibility,
                                                                size: 20,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            5.0),
                                                                child: Text(
                                                                  "${homeController.blogList[index].viewer}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          Colors.black),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    )
                                                  ]),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 5,
                                                            right: 5,
                                                            top: 3,
                                                            bottom: 3),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          height: 42,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom:
                                                                        8.0),
                                                            child: Text(
                                                              homeController
                                                                  .blogList[
                                                                      index]
                                                                  .title,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: Get
                                                                  .theme
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                fontSize:
                                                                    13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    0,
                                                              ),
                                                            ).tr(),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              child: Text(
                                                                homeController
                                                                    .blogList[
                                                                        index]
                                                                    .author,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: Get
                                                                    .theme
                                                                    .textTheme
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                  fontSize:
                                                                      10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
                                                                  letterSpacing:
                                                                      0,
                                                                ),
                                                              ).tr(),
                                                            ),
                                                            Text(
                                                              "${DateFormat("MMM d,yyyy").format(DateTime.parse(homeController.blogList[index].createdAt))}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: Get
                                                                  .theme
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                fontSize:
                                                                    10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                        .grey[
                                                                    700],
                                                                letterSpacing:
                                                                    0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }, separatorBuilder: (BuildContext context, int index) => sizedBoxW10(),
                                      );
                                    }))
                                  ],
                                ),
                              ),
                            );
                    },
                  ),
                  //---------------------BEHIND THE SCHENE-------------------------------
                  // GetBuilder<HomeController>(builder: (homeController) {
                  //   return SizedBox(
                  //     height: 34.h,
                  //     child: Card(
                  //       elevation: 0,
                  //       margin: EdgeInsets.only(top: 0),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.zero),
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(top: 2, bottom: 5),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Container(
                  //               margin: EdgeInsets.symmetric(horizontal: 20),
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text(
                  //                     'Behind the scene',
                  //                     style: Get
                  //                         .theme.primaryTextTheme.titleMedium!
                  //                         .copyWith(
                  //                             fontWeight: FontWeight.w500),
                  //                   ).tr(),
                  //                 ],
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               height: 190,
                  //               width: Get.width,
                  //               child: Stack(
                  //                 alignment: Alignment.center,
                  //                 children: [
                  //                   homeController.videoPlayerController!.value
                  //                           .isInitialized
                  //                       ? Card(
                  //                           margin: EdgeInsets.only(
                  //                               left: 10, right: 10, top: 10),
                  //                           elevation: 5,
                  //                           shape: RoundedRectangleBorder(
                  //                               borderRadius:
                  //                                   BorderRadius.circular(15)),
                  //                           child: SizedBox(
                  //                             height: 200,
                  //                             width: Get.width,
                  //                             child: ClipRRect(
                  //                               borderRadius:
                  //                                   BorderRadius.circular(10),
                  //                               child: AspectRatio(
                  //                                 aspectRatio: homeController
                  //                                     .videoPlayerController!
                  //                                     .value
                  //                                     .aspectRatio,
                  //                                 child: VideoPlayerWidget(
                  //                                   controller: homeController
                  //                                       .videoPlayerController!,
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         )
                  //                       : SizedBox(),
                  //                 ],
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   );
                  // }),

                  ///Customer experience
                  // GetBuilder<HomeController>(builder: (homeController) {
                  //   return homeController.clientReviews.length == 0
                  //       ? SizedBox()
                  //       : Container(
                  //           // height: 50.h,
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Container(
                  //                 margin: EdgeInsets.symmetric(
                  //                   horizontal: 20,
                  //                 ),
                  //                 child: Column(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: [
                  //                     Text(
                  //                       "Customer's Experience",
                  //                       style: Get
                  //                           .theme.primaryTextTheme.titleMedium!
                  //                           .copyWith(
                  //                               fontWeight: FontWeight.w500),
                  //                     ).tr(),
                  //                   ],
                  //                 ),
                  //               ),
                  //               Container(
                  //                 margin: EdgeInsets.symmetric(
                  //                     horizontal: FontSizes(context).width3()),
                  //                 height: FontSizes(context).height37(),
                  //                 child: GridView.builder(
                  //                     scrollDirection: Axis.horizontal,
                  //                     shrinkWrap: true,
                  //                     itemCount:
                  //                         homeController.clientReviews.length,
                  //                     gridDelegate:
                  //                         SliverGridDelegateWithFixedCrossAxisCount(
                  //                       crossAxisSpacing:
                  //                           FontSizes(context).height01(),
                  //                       mainAxisSpacing:
                  //                           FontSizes(context).width2(),
                  //                       mainAxisExtent:
                  //                           FontSizes(context).width70(),
                  //                       crossAxisCount: 2,
                  //                     ),
                  //                     itemBuilder: (context, index) {
                  //                       return Container(
                  //                         margin: EdgeInsets.only(
                  //                           top: FontSizes(context).height01(),
                  //                           bottom:
                  //                               FontSizes(context).height01(),
                  //                         ),
                  //                         padding: EdgeInsets.symmetric(
                  //                             horizontal:
                  //                                 FontSizes(context).width2(),
                  //                             vertical:
                  //                                 FontSizes(context).height1()),
                  //                         decoration: BoxDecoration(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(
                  //                                     FontSizes(context)
                  //                                         .width4()),
                  //                             color: whiteColor,
                  //                             border: Border.all(
                  //                                 color: Get.theme.primaryColor,
                  //                                 width: 0.1),
                  //                             boxShadow: [
                  //                               BoxShadow(
                  //                                   color: Get
                  //                                       .theme.primaryColor
                  //                                       .withOpacity(0.7),
                  //                                   offset: Offset(
                  //                                     0.1,
                  //                                     0.1,
                  //                                   ),
                  //                                   blurRadius: 0.1,
                  //                                   spreadRadius: 0.1),
                  //                             ]),
                  //                         child: Row(
                  //                           crossAxisAlignment:
                  //                               CrossAxisAlignment.start,
                  //                           children: [
                  //                             Column(
                  //                               children: [
                  //                                 homeController
                  //                                                 .clientReviews[
                  //                                                     index]
                  //                                                 .profile
                  //                                                 .toString() ==
                  //                                             "" ||
                  //                                         homeController
                  //                                                 .clientReviews[
                  //                                                     index]
                  //                                                 .profile
                  //                                                 .toString() ==
                  //                                             "null"
                  //                                     ? CircleAvatar(
                  //                                         radius:
                  //                                             FontSizes(context)
                  //                                                 .width10(),
                  //                                         backgroundImage:
                  //                                             AssetImage(Images
                  //                                                 .deafultUser))
                  //                                     : CircleAvatar(
                  //                                         radius:
                  //                                             FontSizes(context)
                  //                                                 .width10(),
                  //                                         backgroundImage: CachedNetworkImageProvider(
                  //                                             "${global.imgBaseurl}${homeController.clientReviews[index].profile}",
                  //                                             errorListener: (e) =>
                  //                                                 AssetImage(Images
                  //                                                     .deafultUser)),
                  //                                       ),
                  //                               ],
                  //                             ),
                  //                             SizedBox(
                  //                               width:
                  //                                   FontSizes(context).width2(),
                  //                             ),
                  //                             Expanded(
                  //                               child: Column(
                  //                                 crossAxisAlignment:
                  //                                     CrossAxisAlignment.start,
                  //                                 children: [
                  //                                   Row(
                  //                                     mainAxisAlignment:
                  //                                         MainAxisAlignment
                  //                                             .spaceBetween,
                  //                                     children: [
                  //                                       CustomText(
                  //                                         text:
                  //                                             "${homeController.clientReviews[index].name}",
                  //                                         fontWeight:
                  //                                             FontWeight.w600,
                  //                                         overflow: TextOverflow
                  //                                             .ellipsis,
                  //                                         color: blackColor,
                  //                                         fontsize:
                  //                                             FontSizes(context)
                  //                                                 .font04(),
                  //                                         maxLine: 1,
                  //                                       ),
                  //                                       Icon(
                  //                                         Icons.more_vert,
                  //                                         color: blackColor,
                  //                                         size:
                  //                                             FontSizes(context)
                  //                                                 .width4(),
                  //                                       )
                  //                                     ],
                  //                                   ),
                  //                                   SizedBox(
                  //                                     height: FontSizes(context)
                  //                                         .height1(),
                  //                                   ),
                  //                                   CustomText(
                  //                                     text:
                  //                                         "${homeController.clientReviews[index].review}",
                  //                                     fontWeight:
                  //                                         FontWeight.w600,
                  //                                     color: blackColor,
                  //                                     overflow:
                  //                                         TextOverflow.ellipsis,
                  //                                     fontsize:
                  //                                         FontSizes(context)
                  //                                             .font04(),
                  //                                     maxLine: 2,
                  //                                   ),
                  //                                   SizedBox(
                  //                                     height: FontSizes(context)
                  //                                         .height1(),
                  //                                   ),
                  //                                   InkWell(
                  //                                     onTap: () async {
                  //                                       global
                  //                                           .showOnlyLoaderDialog(
                  //                                               context);
                  //                                       await homeController
                  //                                           .getClientsTestimonals();
                  //                                       global.hideLoader();
                  //                                       Get.to(() =>
                  //                                           ClientsReviewScreen());
                  //                                     },
                  //                                     child: CustomText(
                  //                                       text: "More",
                  //                                       fontWeight:
                  //                                           FontWeight.w600,
                  //                                       decoration:
                  //                                           TextDecoration
                  //                                               .underline,
                  //                                       decorationColor:
                  //                                           orangeColor,
                  //                                       color: Get
                  //                                           .theme.primaryColor,
                  //                                       overflow: TextOverflow
                  //                                           .ellipsis,
                  //                                       fontsize:
                  //                                           FontSizes(context)
                  //                                               .font04(),
                  //                                       maxLine: 2,
                  //                                     ),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       );
                  //                     }),
                  //               ),
                  //             ],
                  //           ),
                  //         );
                  // }),

                  ///astro in news
                  // GetBuilder<HomeController>(builder: (homeController) {
                  //   return homeController.astroNews.length == 0
                  //       ? SizedBox()
                  //       : SizedBox(
                  //           height: 266,
                  //           child: Card(
                  //             elevation: 0,
                  //             margin: EdgeInsets.only(top: 6),
                  //             shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.zero),
                  //             child: Padding(
                  //               padding:
                  //                   const EdgeInsets.only(top: 0, bottom: 5),
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Padding(
                  //                     padding: const EdgeInsets.symmetric(
                  //                         horizontal: 10),
                  //                     child: Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         Container(
                  //                           margin: EdgeInsets.symmetric(
                  //                               horizontal: 10),
                  //                           child: Column(
                  //                             crossAxisAlignment:
                  //                                 CrossAxisAlignment.start,
                  //                             children: [
                  //                               Text(
                  //                                 ' News',
                  //                                 style: Get
                  //                                     .theme
                  //                                     .primaryTextTheme
                  //                                     .titleMedium!
                  //                                     .copyWith(
                  //                                         fontWeight:
                  //                                             FontWeight.w500),
                  //                               ).tr(),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                         GestureDetector(
                  //                           onTap: () {
                  //                             Get.to(
                  //                                 () => AstrologerNewsScreen());
                  //                           },
                  //                           child: Text(
                  //                             'View All',
                  //                             style: Get.theme.primaryTextTheme
                  //                                 .bodySmall!
                  //                                 .copyWith(
                  //                               fontWeight: FontWeight.w400,
                  //                               color: Colors.blue[500],
                  //                             ),
                  //                           ).tr(),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   Expanded(
                  //                       child: ListView.builder(
                  //                     itemCount:
                  //                         homeController.astroNews.length,
                  //                     shrinkWrap: true,
                  //                     scrollDirection: Axis.horizontal,
                  //                     padding: EdgeInsets.only(
                  //                         top: 10, left: 10, bottom: 10),
                  //                     itemBuilder: (context, index) {
                  //                       return GestureDetector(
                  //                         onTap: () {
                  //                           Get.to(() => BlogScreen(
                  //                                 link: homeController
                  //                                     .astroNews[index].link,
                  //                               ));
                  //                         },
                  //                         child: Card(
                  //                           elevation: 4,
                  //                           margin: EdgeInsets.only(right: 12),
                  //                           shape: RoundedRectangleBorder(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(20),
                  //                           ),
                  //                           child: Container(
                  //                             width: 190,
                  //                             decoration: BoxDecoration(
                  //                               color: Colors.white,
                  //                               borderRadius:
                  //                                   BorderRadius.circular(20),
                  //                             ),
                  //                             child: Column(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.start,
                  //                               children: [
                  //                                 ClipRRect(
                  //                                   borderRadius:
                  //                                       BorderRadius.only(
                  //                                     topLeft:
                  //                                         Radius.circular(20),
                  //                                     topRight:
                  //                                         Radius.circular(20),
                  //                                   ),
                  //                                   child: CachedNetworkImage(
                  //                                     imageUrl:
                  //                                         '${global.imgBaseurl}${homeController.astroNews[index].bannerImage}',
                  //                                     imageBuilder: (context,
                  //                                             imageProvider) =>
                  //                                         Container(
                  //                                       height: 110,
                  //                                       width: Get.width,
                  //                                       decoration:
                  //                                           BoxDecoration(
                  //                                         borderRadius:
                  //                                             BorderRadius
                  //                                                 .circular(10),
                  //                                         image:
                  //                                             DecorationImage(
                  //                                           fit: BoxFit.fill,
                  //                                           image:
                  //                                               imageProvider,
                  //                                         ),
                  //                                       ),
                  //                                     ),
                  //                                     placeholder: (context,
                  //                                             url) =>
                  //                                         const Center(
                  //                                             child:
                  //                                                 CircularProgressIndicator()),
                  //                                     errorWidget: (context,
                  //                                             url, error) =>
                  //                                         Image.asset(
                  //                                       Images.blog,
                  //                                       height:
                  //                                           Get.height * 0.15,
                  //                                       width: Get.width,
                  //                                       fit: BoxFit.fill,
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                                 Padding(
                  //                                   padding:
                  //                                       const EdgeInsets.only(
                  //                                           left: 5,
                  //                                           right: 5,
                  //                                           top: 3,
                  //                                           bottom: 3),
                  //                                   child: Column(
                  //                                     crossAxisAlignment:
                  //                                         CrossAxisAlignment
                  //                                             .start,
                  //                                     children: [
                  //                                       Container(
                  //                                         height: 55,
                  //                                         child: Text(
                  //                                           homeController
                  //                                               .astroNews[
                  //                                                   index]
                  //                                               .description,
                  //                                           textAlign:
                  //                                               TextAlign.start,
                  //                                           maxLines: 2,
                  //                                           style: Get
                  //                                               .theme
                  //                                               .textTheme
                  //                                               .titleMedium!
                  //                                               .copyWith(
                  //                                             fontSize: 13,
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w500,
                  //                                             letterSpacing: 0,
                  //                                           ),
                  //                                         ).tr(),
                  //                                       ),
                  //                                       Row(
                  //                                         mainAxisAlignment:
                  //                                             MainAxisAlignment
                  //                                                 .spaceBetween,
                  //                                         children: [
                  //                                           Text(
                  //                                             homeController
                  //                                                 .astroNews[
                  //                                                     index]
                  //                                                 .channel,
                  //                                             textAlign:
                  //                                                 TextAlign
                  //                                                     .center,
                  //                                             style: Get
                  //                                                 .theme
                  //                                                 .textTheme
                  //                                                 .titleMedium!
                  //                                                 .copyWith(
                  //                                               fontSize: 11,
                  //                                               fontWeight:
                  //                                                   FontWeight
                  //                                                       .w500,
                  //                                               color: Colors
                  //                                                   .grey[700],
                  //                                               letterSpacing:
                  //                                                   0,
                  //                                             ),
                  //                                           ).tr(),
                  //                                           Text(
                  //                                             "${DateFormat("MMM d, yyyy").format(DateTime.parse(homeController.astroNews[index].newsDate.toString()))}",
                  //                                             textAlign:
                  //                                                 TextAlign
                  //                                                     .center,
                  //                                             style: Get
                  //                                                 .theme
                  //                                                 .textTheme
                  //                                                 .titleMedium!
                  //                                                 .copyWith(
                  //                                               fontSize: 11,
                  //                                               fontWeight:
                  //                                                   FontWeight
                  //                                                       .w500,
                  //                                               color: Colors
                  //                                                   .grey[700],
                  //                                               letterSpacing:
                  //                                                   0,
                  //                                             ),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ],
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       );
                  //                     },
                  //                   ))
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         );
                  // }),
                  // Card(
                  //   elevation: 0,
                  //   margin: EdgeInsets.only(top: 6),
                  //   shape:
                  //       RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 10, horizontal: 10),
                  //     child: SizedBox(
                  //       height: 110,
                  //       child: Stack(
                  //         children: [
                  //           GestureDetector(
                  //             onTap: () async {
                  //               DateTime dateBasic = DateTime.now();
                  //               int formattedYear = int.parse(
                  //                   DateFormat('yyyy').format(dateBasic));
                  //               int formattedDay = int.parse(
                  //                   DateFormat('dd').format(dateBasic));
                  //               int formattedMonth = int.parse(
                  //                   DateFormat('MM').format(dateBasic));
                  //               int formattedHour = int.parse(
                  //                   DateFormat('HH').format(dateBasic));
                  //               int formattedMint = int.parse(
                  //                   DateFormat('mm').format(dateBasic));
                  //
                  //               global.showOnlyLoaderDialog(context);
                  //               await kundliController.getBasicPanchangDetail(
                  //                   day: formattedDay,
                  //                   hour: formattedHour,
                  //                   min: formattedMint,
                  //                   month: formattedMonth,
                  //                   year: formattedYear,
                  //                   lat: 21.1255,
                  //                   lon: 73.1122,
                  //                   tzone: 5);
                  //               panchangController
                  //                   .getPanchangVedic(DateTime.now());
                  //               global.hideLoader();
                  //               Get.to(() => PanchangScreen());
                  //             },
                  //             child: Container(
                  //               width: Get.width,
                  //               decoration: BoxDecoration(
                  //                 color: Get.theme.primaryColor,
                  //                 borderRadius: BorderRadius.circular(10),
                  //               ),
                  //               padding: EdgeInsets.only(right: 20),
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.end,
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Text(
                  //                     "Today's Panchang",
                  //                     style: TextStyle(color: Colors.white),
                  //                   ).tr(),
                  //                   Container(
                  //                     height: 25,
                  //                     width: 90,
                  //                     margin:
                  //                         EdgeInsets.only(right: 35, top: 5),
                  //                     padding:
                  //                         EdgeInsets.symmetric(horizontal: 5),
                  //                     decoration: BoxDecoration(
                  //                       color: Colors.black,
                  //                       borderRadius: BorderRadius.circular(7),
                  //                     ),
                  //                     alignment: Alignment.center,
                  //                     child: Text(
                  //                       'Check Now',
                  //                       style: TextStyle(
                  //                         fontSize: 10,
                  //                         fontWeight: FontWeight.w500,
                  //                         color: Colors.white,
                  //                         letterSpacing: -0.2,
                  //                         wordSpacing: 0,
                  //                       ),
                  //                     ).tr(),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //           Container(
                  //             height: 110,
                  //             width: 130,
                  //             child: ClipRRect(
                  //               borderRadius: BorderRadius.only(
                  //                 topRight: Radius.circular(45),
                  //                 bottomRight: Radius.circular(45),
                  //                 topLeft: Radius.circular(10),
                  //                 bottomLeft: Radius.circular(10),
                  //               ),
                  //               child: CachedNetworkImage(
                  //                 imageUrl:
                  //                     '${global.imgBaseurl}${global.getSystemFlagValueForLogin(global.systemFlagNameList.todayPanchang)}',
                  //                 imageBuilder: (context, imageProvider) =>
                  //                     Image.network(
                  //                   '${global.imgBaseurl}${global.getSystemFlagValueForLogin(global.systemFlagNameList.todayPanchang)}',
                  //                   fit: BoxFit.fill,
                  //                 ),
                  //                 placeholder: (context, url) => const Center(
                  //                     child: CircularProgressIndicator()),
                  //                 errorWidget: (context, url, error) =>
                  //                     Icon(Icons.no_accounts, size: 20),
                  //               ),
                  //             ),
                  //             decoration: BoxDecoration(
                  //                 color: Colors.black,
                  //                 borderRadius: BorderRadius.only(
                  //                   topRight: Radius.circular(45),
                  //                   bottomRight: Radius.circular(45),
                  //                   topLeft: Radius.circular(10),
                  //                   bottomLeft: Radius.circular(10),
                  //                 )),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // GetBuilder<HomeController>(builder: (homeController) {
                  //   return homeController.astrologyVideo.length == 0
                  //       ? SizedBox()
                  //       : SizedBox(
                  //           height: 250,
                  //           child: Card(
                  //             elevation: 0,
                  //             margin: EdgeInsets.only(top: 6),
                  //             shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.zero),
                  //             child: Padding(
                  //               padding:
                  //                   const EdgeInsets.only(top: 10, bottom: 5),
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Padding(
                  //                     padding: const EdgeInsets.symmetric(
                  //                         horizontal: 10),
                  //                     child: Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         Container(
                  //                           margin: EdgeInsets.symmetric(
                  //                               horizontal: 10),
                  //                           child: Column(
                  //                             crossAxisAlignment:
                  //                                 CrossAxisAlignment.start,
                  //                             children: [
                  //                               Text(
                  //                                 'Watch Astrology Videos',
                  //                                 style: Get
                  //                                     .theme
                  //                                     .primaryTextTheme
                  //                                     .titleMedium!
                  //                                     .copyWith(
                  //                                         fontWeight:
                  //                                             FontWeight.w500),
                  //                               ).tr(),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                         GestureDetector(
                  //                           onTap: () {
                  //                             Get.to(() =>
                  //                                 AstrologerVideoScreen());
                  //                           },
                  //                           child: Text(
                  //                             'View All',
                  //                             style: Get.theme.primaryTextTheme
                  //                                 .bodySmall!
                  //                                 .copyWith(
                  //                               fontWeight: FontWeight.w400,
                  //                               color: Colors.blue[500],
                  //                             ),
                  //                           ).tr(),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   Expanded(
                  //                       child: ListView.builder(
                  //                     itemCount:
                  //                         homeController.astrologyVideo.length,
                  //                     shrinkWrap: true,
                  //                     scrollDirection: Axis.horizontal,
                  //                     padding: EdgeInsets.only(
                  //                         top: 10, left: 10, bottom: 10),
                  //                     itemBuilder: (context, index) {
                  //                       return GestureDetector(
                  //                         onTap: () async {
                  //                           global
                  //                               .showOnlyLoaderDialog(context);
                  //                           await homeController.youtubPlay(
                  //                               homeController
                  //                                   .astrologyVideo[index]
                  //                                   .youtubeLink);
                  //                           global.hideLoader();
                  //                           Get.to(() => BlogScreen(
                  //                                 link: homeController
                  //                                     .astrologyVideo[index]
                  //                                     .youtubeLink,
                  //                                 title: 'Video',
                  //                                 controller: homeController
                  //                                     .youtubePlayerController,
                  //                                 date:
                  //                                     '${DateFormat("MMM d,yyyy").format(DateTime.parse(homeController.astrologyVideo[index].createdAt))}',
                  //                                 videoTitle: homeController
                  //                                     .astrologyVideo[index]
                  //                                     .videoTitle,
                  //                               ));
                  //                         },
                  //                         child: Card(
                  //                           elevation: 4,
                  //                           margin: EdgeInsets.only(right: 12),
                  //                           shape: RoundedRectangleBorder(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(20),
                  //                           ),
                  //                           child: Container(
                  //                             width: 230,
                  //                             decoration: BoxDecoration(
                  //                               color: Colors.white,
                  //                               borderRadius:
                  //                                   BorderRadius.circular(20),
                  //                             ),
                  //                             child: Column(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.start,
                  //                               mainAxisSize: MainAxisSize.min,
                  //                               children: [
                  //                                 Stack(
                  //                                   alignment: Alignment.center,
                  //                                   children: [
                  //                                     ClipRRect(
                  //                                       borderRadius:
                  //                                           BorderRadius.only(
                  //                                         topLeft:
                  //                                             Radius.circular(
                  //                                                 20),
                  //                                         topRight:
                  //                                             Radius.circular(
                  //                                                 20),
                  //                                       ),
                  //                                       child:
                  //                                           CachedNetworkImage(
                  //                                         imageUrl:
                  //                                             '${global.imgBaseurl}${homeController.astrologyVideo[index].coverImage}',
                  //                                         imageBuilder: (context,
                  //                                                 imageProvider) =>
                  //                                             Container(
                  //                                           height: 110,
                  //                                           width: Get.width,
                  //                                           decoration:
                  //                                               BoxDecoration(
                  //                                             borderRadius:
                  //                                                 BorderRadius
                  //                                                     .circular(
                  //                                                         10),
                  //                                             image:
                  //                                                 DecorationImage(
                  //                                               fit:
                  //                                                   BoxFit.fill,
                  //                                               image:
                  //                                                   imageProvider,
                  //                                             ),
                  //                                           ),
                  //                                         ),
                  //                                         placeholder: (context,
                  //                                                 url) =>
                  //                                             const Center(
                  //                                                 child:
                  //                                                     CircularProgressIndicator()),
                  //                                         errorWidget: (context,
                  //                                                 url, error) =>
                  //                                             Image.asset(
                  //                                           Images.blog,
                  //                                           height: Get.height *
                  //                                               0.15,
                  //                                           width: Get.width,
                  //                                           fit: BoxFit.fill,
                  //                                         ),
                  //                                       ),
                  //                                     ),
                  //                                     Positioned(
                  //                                       child: Image.asset(
                  //                                         Images.youtube,
                  //                                         height: 40,
                  //                                         width: 40,
                  //                                       ),
                  //                                     )
                  //                                   ],
                  //                                 ),
                  //                                 Padding(
                  //                                   padding:
                  //                                       const EdgeInsets.only(
                  //                                           left: 5,
                  //                                           right: 5,
                  //                                           top: 3,
                  //                                           bottom: 3),
                  //                                   child: Column(
                  //                                     crossAxisAlignment:
                  //                                         CrossAxisAlignment
                  //                                             .start,
                  //                                     children: [
                  //                                       Container(
                  //                                         height: 43,
                  //                                         child: Text(
                  //                                           homeController
                  //                                               .astrologyVideo[
                  //                                                   index]
                  //                                               .videoTitle,
                  //                                           textAlign:
                  //                                               TextAlign.start,
                  //                                           maxLines: 2,
                  //                                           overflow:
                  //                                               TextOverflow
                  //                                                   .ellipsis,
                  //                                           style: Get
                  //                                               .theme
                  //                                               .textTheme
                  //                                               .titleMedium!
                  //                                               .copyWith(
                  //                                             fontSize: 13,
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w500,
                  //                                             letterSpacing: 0,
                  //                                           ),
                  //                                         ).tr(),
                  //                                       ),
                  //                                       Row(
                  //                                         mainAxisAlignment:
                  //                                             MainAxisAlignment
                  //                                                 .end,
                  //                                         children: [
                  //                                           Text(
                  //                                             "${DateFormat("MMM d, yyyy").format(DateTime.parse(homeController.astrologyVideo[index].createdAt))}",
                  //                                             textAlign:
                  //                                                 TextAlign
                  //                                                     .center,
                  //                                             style: Get
                  //                                                 .theme
                  //                                                 .textTheme
                  //                                                 .titleMedium!
                  //                                                 .copyWith(
                  //                                               fontSize: 10,
                  //                                               fontWeight:
                  //                                                   FontWeight
                  //                                                       .w500,
                  //                                               color: Colors
                  //                                                   .grey[700],
                  //                                               letterSpacing:
                  //                                                   0,
                  //                                             ),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ],
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       );
                  //                     },
                  //                   ))
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         );
                  // }),
                  GetBuilder<HomeController>(builder: (homeController) {
                    return Card(
                      elevation: 0,
                      margin: EdgeInsets.only(top: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'I am the Product Manager',
                              style: Get.theme.primaryTextTheme.titleMedium!
                                  .copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 17.sp,
                              ),
                            ).tr(),
                            Text(
                              'share your feedback to help us improve the app',
                              style: TextStyle(
                                fontSize: 15.sp,
                              ),
                            ).tr(),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              style: TextStyle(fontSize: 15.sp),
                              controller: homeController.feedbackController,
                              maxLines: 8,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Start typing here..',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[500],
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 5),
                                child: SizedBox(
                                  height: 35,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(0)),
                                      fixedSize: MaterialStateProperty.all(
                                          Size.fromWidth(Get.width / 2)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Get.theme.primaryColor),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      bool isLogin = await global.isLogin();
                                      if (isLogin) {
                                        if (homeController
                                                .feedbackController.text ==
                                            "") {
                                          global.showToast(
                                            message: 'Please enter feedback',
                                            textColor: global.textColor,
                                            bgColor: global.toastBackGoundColor,
                                          );
                                        } else {
                                          global.showOnlyLoaderDialog(context);
                                          await homeController.addFeedback(
                                              homeController
                                                  .feedbackController.text);
                                          global.hideLoader();
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Send Feedback',
                                      style: Get
                                          .theme.primaryTextTheme.bodySmall!
                                          .copyWith(color: Colors.white),
                                    ).tr(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.only(top: 6),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10)
                          .copyWith(bottom: 65),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.grey[200],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    Images.confidential,
                                    height: 45,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Private &\nConfidential',
                                textAlign: TextAlign.center,
                                style:
                                    Get.theme.textTheme.titleMedium!.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                              ).tr(),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.grey[200],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    Images.verifiedAccount,
                                    height: 45,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Verified\nAstrologers',
                                textAlign: TextAlign.center,
                                style:
                                    Get.theme.textTheme.titleMedium!.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                              ).tr(),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.grey[200],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    Images.payment,
                                    height: 45,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Secure\nPayments',
                                textAlign: TextAlign.center,
                                style:
                                    Get.theme.textTheme.titleMedium!.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
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
            );
          }),
        ),
        // floatingActionButton: InkWell(
        //   onTap: () {
        //      global.warningDialog(context);
        //   },
        //   child: Container(
        //     margin: EdgeInsets.symmetric(vertical: 6.h),
        //     child: CircleAvatar(
        //       radius: 20.sp,
        //       backgroundColor: Colors.black,
        //       backgroundImage: AssetImage(
        //         "assets/images/warning.png",
        //       ),
        //     ),
        //   ),
        // ),
        //  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void refreshIt() async {
    // global.warningDialog(context);
    splashController.currentLanguageCode =
        homeController.lan[homeController.selectedIndex].lanCode;
    splashController.update();
    global.spLanguage = await SharedPreferences.getInstance();
    global.spLanguage!
        .setString('currentLanguage', splashController.currentLanguageCode);
    homeController.refresh();

    Get.back();
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 100);
    path.lineTo(250, 100);
    path.lineTo(0, 100);
    path.lineTo(200, 300);
    path.lineTo(90, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
