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
            // Card(shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(Dimensions.radius15), // Apply radius to Card
            // ),
            //   child: Column(
            //     children: [
            //       sizedBox10(),
            //       Container(
            //         height: 200,
            //         clipBehavior: Clip.hardEdge,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(Dimensions.radius15)
            //         ),
            //         child: CachedNetworkImage(
            //           fit: BoxFit.cover,
            //           imageUrl: 'https://img.youtube.com/vi/RUqEZ9ySIVo/maxresdefault.jpg',
            //           placeholder: (context, url) => const Center(
            //             child: CircularProgressIndicator(),
            //           ),
            //           errorWidget: (context, url, error) => Image.asset(
            //             Images.deafultUser,
            //             fit: BoxFit.cover,
            //           ),
            //         ),
            //       ),
            //       Text('Lorem ipsum dolor sit amet, consectetr a...',
            //       maxLines: 2,
            //       overflow: TextOverflow.ellipsis,
            //       style: openSansRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
            //       Text('Lorem ipsum dolor sit amet, consectetr a...',
            //         maxLines: 2,
            //         overflow: TextOverflow.ellipsis,
            //         style: openSansRegular.copyWith(fontSize: Dimensions.fontSize12,
            //         color: Theme.of(context).hintColor),),
            //     ],
            //   ),
            // ),
            GetBuilder<HomeController>(builder: (homeController) {
              return homeController.astrologyVideo.length == 0
                  ? SizedBox()
                  : AstrologyVideoWidget(title: 'Astrology Latest',
                videoDataList: homeController.astrologyVideo,
                onSeeAllTap: () {
                  Get.to(() => AstrologerVideoScreen());
                  }, );

              // SizedBox(
              //   height: 300,
              //   child: Card(
              //     elevation: 0,
              //     margin: EdgeInsets.only(top: 6),
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.zero),
              //     child: Padding(
              //       padding:
              //       const EdgeInsets.only(top: 10, bottom: 5),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 10),
              //             child: Row(
              //               mainAxisAlignment:
              //               MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Container(
              //                   margin: EdgeInsets.symmetric(
              //                       horizontal: 10),
              //                   child: Column(
              //                     crossAxisAlignment:
              //                     CrossAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         'Astrology Latest',
              //                         style: openSansSemiBold.copyWith(
              //                           fontSize: Dimensions.fontSizeDefault,
              //                           color: Theme.of(context).dividerColor
              //                         )
              //                       ).tr(),
              //                     ],
              //                   ),
              //                 ),
              //                 GestureDetector(
              //                   onTap: () {
              //                     Get.to(() =>
              //                         AstrologerVideoScreen());
              //                   },
              //                   child: Text(
              //                     'See All',
              //                     style: openSansRegular.copyWith(
              //                       fontSize: Dimensions.fontSize14,
              //                       color: Theme.of(context).dividerColor
              //                     ),
              //                   ).tr(),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           Expanded(
              //               child: ListView.builder(
              //                 itemCount:
              //                 homeController.astrologyVideo.length,
              //                 shrinkWrap: true,
              //                 scrollDirection: Axis.horizontal,
              //                 padding: EdgeInsets.only(
              //                     top: 10, left: 10, bottom: 10),
              //                 itemBuilder: (context, index) {
              //                   return GestureDetector(
              //                     onTap: () async {
              //                       global
              //                           .showOnlyLoaderDialog(context);
              //                       await homeController.youtubPlay(
              //                           homeController
              //                               .astrologyVideo[index]
              //                               .youtubeLink);
              //                       global.hideLoader();
              //                       Get.to(() => BlogScreen(
              //                         link: homeController
              //                             .astrologyVideo[index]
              //                             .youtubeLink,
              //                         title: 'Video',
              //                         controller: homeController
              //                             .youtubePlayerController,
              //                         date:
              //                         '${DateFormat("MMM d,yyyy").format(DateTime.parse(homeController.astrologyVideo[index].createdAt))}',
              //                         videoTitle: homeController
              //                             .astrologyVideo[index]
              //                             .videoTitle,
              //                       ));
              //                     },
              //                     child: Card(
              //                       elevation: 4,
              //                       margin: EdgeInsets.only(right: 12),
              //                       shape: RoundedRectangleBorder(
              //                         borderRadius:
              //                         BorderRadius.circular(20),
              //                       ),
              //                       child: Container(
              //                         width: 180,
              //                         decoration: BoxDecoration(
              //                           color: Colors.white,
              //                           borderRadius:
              //                           BorderRadius.circular(20),
              //                         ),
              //                         child: Column(
              //                           crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                           mainAxisSize: MainAxisSize.min,
              //                           children: [
              //                             Stack(
              //                               alignment: Alignment.center,
              //                               children: [
              //                                 ClipRRect(
              //                                   borderRadius:
              //                                   BorderRadius.only(
              //                                     topLeft:
              //                                     Radius.circular(
              //                                         20),
              //                                     topRight:
              //                                     Radius.circular(
              //                                         20),
              //                                   ),
              //                                   child:
              //                                   CachedNetworkImage(
              //                                     imageUrl:
              //                                     '${global.imgBaseurl}${homeController.astrologyVideo[index].coverImage}',
              //                                     imageBuilder: (context,
              //                                         imageProvider) =>
              //                                         Container(
              //                                           height: 110,
              //                                           width: Get.width,
              //                                           decoration:
              //                                           BoxDecoration(
              //                                             borderRadius:
              //                                             BorderRadius
              //                                                 .circular(
              //                                                 10),
              //                                             image:
              //                                             DecorationImage(
              //                                               fit:
              //                                               BoxFit.fill,
              //                                               image:
              //                                               imageProvider,
              //                                             ),
              //                                           ),
              //                                         ),
              //                                     placeholder: (context,
              //                                         url) =>
              //                                     const Center(
              //                                         child:
              //                                         CircularProgressIndicator()),
              //                                     errorWidget: (context,
              //                                         url, error) =>
              //                                         Image.asset(
              //                                           Images.blog,
              //                                           height: Get.height *
              //                                               0.15,
              //                                           width: Get.width,
              //                                           fit: BoxFit.fill,
              //                                         ),
              //                                   ),
              //                                 ),
              //                                 Positioned(
              //                                   child: Image.asset(
              //                                     Images.youtube,
              //                                     height: 40,
              //                                     width: 40,
              //                                   ),
              //                                 )
              //                               ],
              //                             ),
              //                             Padding(
              //                               padding:
              //                               const EdgeInsets.only(
              //                                   left: 5,
              //                                   right: 5,
              //                                   top: 3,
              //                                   bottom: 3),
              //                               child: Column(
              //                                 crossAxisAlignment:
              //                                 CrossAxisAlignment
              //                                     .start,
              //                                 children: [
              //                                   Text(
              //                                     homeController
              //                                         .astrologyVideo[
              //                                     index]
              //                                         .videoTitle,
              //                                     textAlign:
              //                                     TextAlign.start,
              //                                     maxLines: 2,
              //                                     overflow:
              //                                     TextOverflow
              //                                         .ellipsis,
              //                                     style: Get
              //                                         .theme
              //                                         .textTheme
              //                                         .titleMedium!
              //                                         .copyWith(
              //                                       fontSize: 13,
              //                                       fontWeight:
              //                                       FontWeight
              //                                           .w500,
              //                                       letterSpacing: 0,
              //                                     ),
              //                                   ).tr(),
              //                                   Text(
              //                                     homeController
              //                                         .astrologyVideo[
              //                                     index]
              //                                         .videoTitle,
              //                                     textAlign:
              //                                     TextAlign.start,
              //                                     maxLines: 2,
              //                                     overflow:
              //                                     TextOverflow
              //                                         .ellipsis,
              //                                     style: Get
              //                                         .theme
              //                                         .textTheme
              //                                         .titleMedium!
              //                                         .copyWith(
              //                                       fontSize: 13,
              //                                       fontWeight:
              //                                       FontWeight
              //                                           .w500,
              //                                       letterSpacing: 0,
              //                                     ),
              //                                   ).tr(),
              //                                   Row(
              //                                     mainAxisAlignment:
              //                                     MainAxisAlignment
              //                                         .start,
              //                                     children: [
              //                                       Text(
              //                                         "${DateFormat("MMM d, yyyy").format(DateTime.parse(homeController.astrologyVideo[index].createdAt))}",
              //                                         textAlign:
              //                                         TextAlign
              //                                             .center,
              //                                         style: Get
              //                                             .theme
              //                                             .textTheme
              //                                             .titleMedium!
              //                                             .copyWith(
              //                                           fontSize: 10,
              //                                           fontWeight:
              //                                           FontWeight
              //                                               .w500,
              //                                           color: Colors
              //                                               .grey[700],
              //                                           letterSpacing:
              //                                           0,
              //                                         ),
              //                                       ),
              //                                     ],
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                   );
              //                 },
              //               ))
              //         ],
              //       ),
              //     ),
              //   ),
              // );
            }),
            GetBuilder<HomeController>(builder: (homeController) {
              return homeController.astrologyVideo.length == 0
                  ? SizedBox()
                  : AstrologyVideoWidget(title: 'Trending Reels',
                                  videoDataList: homeController.astrologyVideo,
                                  onSeeAllTap: () {
                  Get.to(() => AstrologerVideoScreen());
                                  },
                isColor: true,
              );
            }),
            GetBuilder<HomeController>(builder: (homeController) {
              return homeController.astrologyVideo.length == 0
                  ? SizedBox()
                  : AstrologyVideoWidget(title: 'Daily Horoscope',
                videoDataList: homeController.astrologyVideo,
                onSeeAllTap: () {
                  Get.to(() => AstrologerVideoScreen());
                }, );
            }),
            GetBuilder<HomeController>(builder: (homeController) {
              return homeController.astrologyVideo.length == 0
                  ? SizedBox()
                  : AstrologyVideoWidget(title: 'Monthly Horoscope',
                videoDataList: homeController.astrologyVideo,
                isColor: true,
                onSeeAllTap: () {
                  Get.to(() => AstrologerVideoScreen());
                }, );
            }),
            GetBuilder<HomeController>(builder: (homeController) {
              return homeController.astrologyVideo.length == 0
                  ? SizedBox()
                  : AstrologyVideoWidget(title: 'Yearly Horoscope',
                videoDataList: homeController.astrologyVideo,
                onSeeAllTap: () {
                  Get.to(() => AstrologerVideoScreen());
                }, );
            }),
          ],
        ),
      ),
    );
  }
}
