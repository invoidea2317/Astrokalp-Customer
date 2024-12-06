import 'package:AstrowayCustomer/utils/dimensions.dart';
import 'package:AstrowayCustomer/utils/text_styles.dart';
import 'package:AstrowayCustomer/views/watch/widgets/video_content_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import '../../controllers/homeController.dart';
import '../../utils/images.dart';
import '../../utils/sizedboxes.dart';
import '../../widget/customAppbarWidget.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../widget/drawerWidget.dart';
import '../../widget/language_widget.dart';
import '../astrologerVideo.dart';
import '../blog_screen.dart';

class WatchScreen extends StatelessWidget {
   WatchScreen({super.key});
  final homeController = Get.find<HomeController>();
   final drawerKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.getAstrologyLatestVideos();
      homeController.getAstrologyTrendingReelsVideos();
      homeController.getAstrologyDailyHoroscopeVideos();
      homeController.getAstrologyMonthlyHoroscopeVideos();
      homeController.getAstrologyYearlyHoroscopeVideos();

    });
    return Scaffold(
      key: drawerKey,
      drawer: DrawerWidget(),
      backgroundColor: Colors.white,
      appBar: CustomApp(title: 'Watch',menuWidget: Row(
      children: [
        InkWell(
          onTap: () async {
            homeController.lan = [];
            await Future.wait([
              homeController.getLanguages(),
              homeController.updateLanIndex()
            ]);
            //LANGUAGE DIALOG
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            GetBuilder<HomeController>(builder: (homeController) {
              return homeController.getAstrologyLatestVideo.length == 0
                  ? SizedBox()
                  : AstrologyVideoWidget(title: 'Astrology Latest',
                isLoading:homeController.isLatestVideoLoading,
                videoDataList: homeController.getAstrologyLatestVideo,
                onSeeAllTap: () {
                  Get.to(() => AstrologerVideoScreen(navigateFrom: 'Astrology Latest',));
                }, );

            }),
            GetBuilder<HomeController>(builder: (homeController) {
              return homeController.getAstrologyTrendingReelsVideo.length == 0
                  ? SizedBox()
                  : AstrologyVideoWidget(title: 'Trending Reels',
                isLoading:homeController.isTrendingReelsLoading,
                videoDataList: homeController.getAstrologyTrendingReelsVideo,
                onSeeAllTap: () {
                  Get.to(() => AstrologerVideoScreen(navigateFrom: 'Trending Reels',));
                },
                isColor: true,
              );
            }),
            GetBuilder<HomeController>(builder: (homeController) {
              return homeController.getAstrologyDailyHoroscopeVideo.length == 0
                  ? SizedBox()
                  : AstrologyVideoWidget(title: 'Daily Horoscope',
                isLoading:homeController.isDailyHoroscopeLoading,
                videoDataList: homeController.getAstrologyDailyHoroscopeVideo,
                onSeeAllTap: () {
                  Get.to(() => AstrologerVideoScreen(navigateFrom: 'Daily Horoscope',));
                }, );
            }),
            GetBuilder<HomeController>(builder: (homeController) {
              return homeController.getAstrologyMonthlyHoroscopeVideo.length == 0
                  ? SizedBox()
                  : AstrologyVideoWidget(title: 'Monthly Horoscope',
                isLoading:homeController.isMonthlyHoroscopeLoading,
                videoDataList: homeController.getAstrologyMonthlyHoroscopeVideo,
                isColor: true,
                onSeeAllTap: () {
                  Get.to(() => AstrologerVideoScreen(navigateFrom: 'Monthly Horoscope',));
                }, );
            }),
            GetBuilder<HomeController>(builder: (homeController) {
              return homeController.getAstrologyYearlyHoroscopeVideo.length == 0
                  ? SizedBox()
                  : AstrologyVideoWidget(title: 'Yearly Horoscope',
                isLoading:homeController.isYearlyHoroscopeLoading,
                videoDataList: homeController.getAstrologyYearlyHoroscopeVideo,
                onSeeAllTap: () {
                  Get.to(() => AstrologerVideoScreen(navigateFrom: 'Yearly Horoscope',));
                }, );
            }),
          ],
        )
      ),
    );
  }
}
