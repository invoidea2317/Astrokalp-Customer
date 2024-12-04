import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../controllers/homeController.dart';
import '../../../model/live_video_model.dart';
import '../../../theme/nativeTheme.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/images.dart';
import '../../../utils/sizedboxes.dart';
import '../../../utils/text_styles.dart';
import '../../../widget/custom_network_image.dart';
import '../../../widget/custom_rows_widget.dart';
import 'live_video_player_screen.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
class LiveVideoAstrologersComponent extends StatelessWidget {
  final bool? isBlackColor;
  final String title;
  final List<VideoRecord> liveVideo;
   LiveVideoAstrologersComponent({super.key, this.isBlackColor = false, required this.title, required this.liveVideo});
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    print('LiveVideoAstrologersComponent ${liveVideo.length}');
    return   Container(
      color: isBlackColor! ? blackBgPrimary : Theme.of(context).cardColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(Images.icYellowPlay,height: 24,),
                    sizedBoxW10(),
                    Text(
                      title,
                      style: Get.theme.primaryTextTheme
                          .titleMedium!
                          .copyWith(
                        color: isBlackColor!? Theme.of(context).cardColor :  Theme.of(context).dividerColor,
                          fontWeight:
                          FontWeight.w500),
                    ).tr(),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'See All',
                    style: openSansRegular.copyWith(
                      color:  isBlackColor!? Theme.of(context).cardColor :  Theme.of(context).dividerColor,
                        fontSize: Dimensions.fontSize14
                    ),
                  ).tr(),
                )


              ],
            ),
          ),
          SizedBox(height: 150,
            child: ListView.separated(
                itemCount: liveVideo.length,padding: EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_,i) {
                  return GestureDetector(
                    onTap: () async {
                      print(liveVideo[i].youtubeLink.toString());
                      final youtubeUrl = liveVideo[i].youtubeLink.toString();

                      // Check if the youtubeUrl is valid
                      if (YoutubePlayer.convertUrlToId(youtubeUrl) == null) {
                        print("Invalid YouTube URL");
                        return;
                      }
                      print("YouTube URL: $youtubeUrl");
                      Get.to(LiveYouTubePlayer(youtubeUrl: youtubeUrl,));
                    },

                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(shape: BoxShape.circle,),
                          child: CustomRoundNetworkImage(
                              height: 130,
                              width: 130,
                              placeholder: Images.icAstrokalpLogo,
                              image: liveVideo[i].coverImage.toString()),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 10,
                          right: 10,
                          child: Row(
                            children: [
                              CustomDecoratedContainer(color: Theme.of(context).primaryColor,
                                  verticalPadding: 7,
                                  horizontalPadding: 12,
                                  child: Row(
                                    children: [
                                      Icon(Icons.play_circle_fill_outlined,size: Dimensions.fontSize14 ,color: Theme.of(context).dividerColor,),
                                      sizedBoxW10(),
                                      Text('WATCH NOW',style: openSansSemiBold.copyWith(fontSize: 8),)
                                    ],
                                  )),
                            ],
                          ),
                        ),

                      ],
                    ),
                  );
                }, separatorBuilder: (BuildContext context, int index) => sizedBoxW10(),),
          ),
          sizedBoxDefault(),

        ],
      ),
    );
  }
}
