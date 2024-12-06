import 'dart:io';

import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/blog_screen.dart';
import 'package:AstrowayCustomer/widget/customAppbarWidget.dart';
import 'package:AstrowayCustomer/widget/custom_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:AstrowayCustomer/utils/global.dart' as global;

import '../model/home_Model.dart';

class AstrologerVideoScreen extends StatelessWidget {
  final String navigateFrom;
   AstrologerVideoScreen({Key? key, required this.navigateFrom}) : super(key: key);


  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(navigateFrom == 'Astrology Latest') {
        print('Astrology Latest');
        homeController.getAstrologyLatestVideos();

      } else if (navigateFrom == 'Trending Reels') {
        homeController.getAstrologyTrendingReelsVideos();

      } else if (navigateFrom == 'Daily Horoscope') {
        homeController.getAstrologyDailyHoroscopeVideos();

      } else if(navigateFrom == 'Monthly Horoscope') {
        homeController.getAstrologyMonthlyHoroscopeVideos();
      } else if (navigateFrom == 'Yearly Horoscope') {
        homeController.getAstrologyYearlyHoroscopeVideos();
      }


    });
    final watchVideoList = <WatchVideoModel>[];
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          homeController.getAstrologyLatestVideos();
          homeController.getAstrologyTrendingReelsVideos();
          homeController.getAstrologyDailyHoroscopeVideos();
          homeController.getAstrologyMonthlyHoroscopeVideos();
          homeController.getAstrologyYearlyHoroscopeVideos();
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomApp(title: 'Astrology Video',isBackButtonExist: true,
          isBackCall: () {
            homeController.getAstrologyLatestVideos();
            homeController.getAstrologyTrendingReelsVideos();
            homeController.getAstrologyDailyHoroscopeVideos();
            homeController.getAstrologyMonthlyHoroscopeVideos();
            homeController.getAstrologyYearlyHoroscopeVideos();
            Get.back();
          },),
          body: GetBuilder<HomeController>(builder: (homeController) {
            return RefreshIndicator(
              onRefresh: () async {
                if(navigateFrom == 'Astrology Latest') {
                  homeController.getAstrologyLatestVideos();
                } else if (navigateFrom == 'Trending Reels') {
                  homeController.getAstrologyTrendingReelsVideos();
                } else if (navigateFrom == 'Daily Horoscope') {
                  homeController.getAstrologyDailyHoroscopeVideos();
                } else if(navigateFrom == 'Monthly Horoscope') {
                  homeController.getAstrologyMonthlyHoroscopeVideos();
                } else if (navigateFrom == 'Yearly Horoscope') {
                  homeController.getAstrologyYearlyHoroscopeVideos();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: (() {
                    if (navigateFrom == 'Astrology Latest') {
                      print('Astrology Latest 2');
                      return homeController.getAstrologyLatestVideo.length;
                    } else if (navigateFrom == 'Trending Reels') {
                      return homeController.getAstrologyTrendingReelsVideo.length;
                    } else if (navigateFrom == 'Daily Horoscope') {
                      return homeController.getAstrologyDailyHoroscopeVideo.length;
                    } else if (navigateFrom == 'Monthly Horoscope') {
                      return homeController.getAstrologyMonthlyHoroscopeVideo.length;
                    } else if (navigateFrom == 'Yearly Horoscope') {
                      return homeController.getAstrologyYearlyHoroscopeVideo.length;
                    } else {
                      return homeController.watchVideoList.length;
                    }
                  })(),
                  itemBuilder: (BuildContext ctx, index) {
                    var videoList = [];
                    if (navigateFrom == 'Astrology Latest') {
                      videoList = homeController.getAstrologyLatestVideo;
                    } else if (navigateFrom == 'Trending Reels') {
                      videoList = homeController.getAstrologyTrendingReelsVideo;
                    } else if (navigateFrom == 'Daily Horoscope') {
                      videoList = homeController.getAstrologyDailyHoroscopeVideo;
                    } else if (navigateFrom == 'Monthly Horoscope') {
                      videoList = homeController.getAstrologyMonthlyHoroscopeVideo;
                    } else if (navigateFrom == 'Yearly Horoscope') {
                      videoList = homeController.getAstrologyYearlyHoroscopeVideo;
                    } else {
                      videoList = homeController.watchVideoList;
                    }

                    return GestureDetector(
                      onTap: () async {
                        global.showOnlyLoaderDialog(context);
                        await homeController.youtubePlayWatchVideos(videoList[index].youtubeLink);
                        global.hideLoader();
                        Get.to(() => BlogScreen(
                          title: 'Video',
                          link: videoList[index].youtubeLink,
                          controller: homeController.youtubePlayerController,
                          date: '${DateFormat("MMM d,yyyy").format(DateTime.parse(videoList[index].createdAt.toString()))}',
                          videoTitle: videoList[index].videoTitle,
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                    child: videoList[index].coverImage == ''
                                        ? Image.asset(
                                      Images.blog,
                                      height: 180,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fill,
                                    )
                                        : CustomNetworkImageWidget(height: 180,
                                    image: '${global.imgBaseurl}${videoList[index].coverImage}'),


                      // CachedNetworkImage(
                      //                 imageUrl: '${global.imgBaseurl}${videoList[index].coverImage}',
                      //                 imageBuilder: (context, imageProvider) => Image.network(
                      //                   "${global.imgBaseurl}${videoList[index].coverImage}",
                      //                   height: 180,
                      //                   width: MediaQuery.of(context).size.width,
                      //                   fit: BoxFit.fill,
                      //                 ),
                      //                 placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      //                 errorWidget: (context, url, error) => Image.asset(
                      //                   Images.blog,
                      //                   height: 180,
                      //                   width: MediaQuery.of(context).size.width,
                      //                   fit: BoxFit.fill,
                      //                 ),
                      //               ),
                                  ),
                                  Positioned(
                                    bottom: 40,
                                    left: 120,
                                    child: Image.asset(
                                      Images.youtube,
                                      height: 120,
                                      width: 120,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      videoList[index].videoTitle,
                                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                                      textAlign: TextAlign.start,
                                    ).tr(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          "${DateFormat("MMM d,yyyy").format(DateTime.parse(videoList[index].createdAt.toString()))}",
                                          style: Theme.of(context).primaryTextTheme.titleSmall!.copyWith(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )

            );
          }),
        ),
      ),
    );
  }
}
