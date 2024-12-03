import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../controllers/homeController.dart';
import '../../../model/home_Model.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/images.dart';
import '../../../utils/text_styles.dart';
import '../../blog_screen.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

class AstrologyVideoWidget extends StatelessWidget {
  final String title;
  final List<AstrologyVideo> videoDataList;
  final Function() onSeeAllTap;

   AstrologyVideoWidget({
    Key? key,
    required this.title,
    required this.videoDataList,
     required this.onSeeAllTap,
  }) : super(key: key);
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.only(top: 6),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              title,
                              style: openSansSemiBold.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context).dividerColor
                              )
                          ).tr(),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onSeeAllTap,
                      child: Text(
                        'See All',
                        style: openSansRegular.copyWith(
                            fontSize: Dimensions.fontSize14,
                            color: Theme.of(context).dividerColor
                        ),
                      ).tr(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: videoDataList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        global.showOnlyLoaderDialog(context);
                        await homeController.youtubPlay(videoDataList[index].youtubeLink);
                        global.hideLoader();
                        Get.to(() => BlogScreen(
                          link: videoDataList[index].youtubeLink,
                          title: 'Video',
                          controller: homeController.youtubePlayerController,
                          date: DateFormat("MMM d,yyyy").format(DateTime.parse(videoDataList[index].createdAt)),
                          videoTitle: videoDataList[index].videoTitle,
                        ));
                      },
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.only(right: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: '${global.imgBaseurl}${videoDataList[index].coverImage}',
                                      imageBuilder: (context, imageProvider) => Container(
                                        height: 110,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: imageProvider,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) => Image.asset(
                                        Images.blog,
                                        height: Get.height * 0.15,
                                        width: Get.width,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: Image.asset(
                                      Images.youtube,
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      videoDataList[index].videoTitle,
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Get.theme.textTheme.titleMedium!.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0,
                                      ),
                                    ).tr(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat("MMM d, yyyy").format(DateTime.parse(videoDataList[index].createdAt)),
                                          textAlign: TextAlign.center,
                                          style: Get.theme.textTheme.titleMedium!.copyWith(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[700],
                                            letterSpacing: 0,
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
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}