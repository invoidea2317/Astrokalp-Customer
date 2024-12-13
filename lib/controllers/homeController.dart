
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/model/Allstories.dart';
import 'package:AstrowayCustomer/model/app_review_model.dart';
import 'package:AstrowayCustomer/model/home_Model.dart';
import 'package:AstrowayCustomer/model/viewStories.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart' as material;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import '../model/language.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:http/http.dart' as http;
import '../model/live_video_model.dart';
import '../model/membership_plan_model.dart';

class HomeController extends GetxController {
  List<Language> lan = [];
  APIHelper apiHelper = APIHelper();
  var bannerList = <Banner>[];
  var blogList = <Blog>[];
  var astroNews = <AstrotalkInNews>[];
  var astrologyVideo = <AstrologyVideo>[];
  var clientReviews = <AppReviewModel>[];
  var viewSingleStory = <ViewStories>[];
  var allStories = <AllStories>[];
  var myOrders = <TopOrder>[];
  final material.TextEditingController feedbackController =
      material.TextEditingController();
  final SplashController splashController = Get.find<SplashController>();
  final BottomNavigationController bottomNavigationController =
      Get.find<BottomNavigationController>();
  material.PageController pageController = material.PageController().obs();
  int reviewChange = 0.obs();
  VideoPlayerController? videoPlayerController;
  VideoPlayerController? homeVideoPlayerController;
  YoutubePlayerController? youtubePlayerController;

  @override
  void onInit() async {
    _init();
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
          '${global.imgBaseurl}${global.getSystemFlagValueForLogin(global.systemFlagNameList.behindScenes)}'),
    )..initialize().then((_) {
        videoPlayerController!.pause();
        videoPlayerController!.setLooping(true);

        update();
      });

    super.onInit();
  }

  _init() async {
    try {
      await Future.wait([
        getAllStories(),
        getBanner(),
        getBlog(),
        getAstroNews(),
        getMyOrder(),
        getAstrologyVideos(),
        getClientsTestimonals(),
        getLiveWebinarVideos(),
        getLiveVastuVideos(),
        getLiveRemedyVideos(),
        // getMembershipPlans(),

        // getAstrologyTrendingReelsVideos(),
        // getAstrologyDailyHoroscopeVideos(),
        // getAstrologyMonthlyHoroscopeVideos(),
        // getAstrologyYearlyHoroscopeVideos(),
      ]);
      bottomNavigationController.astrologerList.clear();
      await bottomNavigationController.getAstrologerList(isLazyLoading: false);
      await bottomNavigationController.getSkillAstrologerList(isLazyLoading: false,skills: [35]);
      await bottomNavigationController.getTarotAstrologerList(isLazyLoading: false,skills: [56]);
    } catch (e) {
      print("Exception -Homecontroller init future.wait: $e");
    }
  }

  int activeBannerIndex = 0;

  void setActiveBannerIndex(int index) {
    activeBannerIndex = index;
    update(); // Notify listeners
  }

  DateTime? currentBackPressTime;
  Future<bool> onBackPressed() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;

      global.showToast(
        message: 'Press again to exit',
        textColor: global.textColor,
        bgColor: global.toastBackGoundColor,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  void playPauseVideo() {
    if (videoPlayerController!.value.isPlaying) {
      videoPlayerController!.pause();
      update();
    } else {
      videoPlayerController!.play();
      update();
    }
  }

  void blogplayPauseVideo(VideoPlayerController controller) {
    if (controller.value.isPlaying) {
      controller.pause();
      update();
    } else {
      controller.play();
      update();
    }
  }

  String? extractVideoId(String url) {
    final regex = RegExp(
      r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/|youtube\.com\/live\/)([^"&?\/\s]{11})',
    );
    final match = regex.firstMatch(url);
    return match?.group(1);
  }
  bool isValidYoutubeLiveUrl(String url) {
    final regex = RegExp(
        r'^(https?\:\/\/)?(www\.)?(youtube\.com\/live\/)[^"&?\/\s]{11}');
    return regex.hasMatch(url);
  }

  Future youtubPlay(String url) async {
    // Validate live stream link
    if (!isValidYoutubeLiveUrl(url)) {
      throw Exception("Invalid YouTube live stream link");
    }

    // Extract video ID
    String? videoId = extractVideoId(url);
    if (videoId == null) {
      throw Exception("Could not extract video ID from the link");
    }



    // Initialize YouTube player
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        showLiveFullscreenButton: true,
      ),
    );
    update();
  }


  Future youtubePlayWatchVideos(String url) async {
    String? videoId;
    videoId = YoutubePlayer.convertUrlToId(url);
    youtubePlayerController = YoutubePlayerController(
        initialVideoId: '$videoId',
        flags: YoutubePlayerFlags(
          autoPlay: true,
          showLiveFullscreenButton: true,
        ));
    update();
  }

  homeBlogVideo(String link) {
    homeVideoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse('${global.imgBaseurl}$link'),
    )..initialize().then((_) {
        homeVideoPlayerController!.pause();
        homeVideoPlayerController!.setLooping(true);
        update();
      });
  }

  int selectedIndex = 0;
  updateLan(int index) {
    selectedIndex = index;
    lan[index].isSelected = true;
    update();
    for (int i = 0; i < lan.length; i++) {
      if (i == index) {
        continue;
      } else {
        lan[i].isSelected = false;
        update();
      }
    }
    update();
  }

  Future<void> updateLanIndex() async {
    global.sp = await SharedPreferences.getInstance();
    var currentLan = global.sp!.getString('currentLanguage') ?? 'en';
    for (int i = 0; i < lan.length; i++) {
      if (lan[i].lanCode == currentLan) {
        selectedIndex = i;
        lan[i].isSelected = true;
        update();
      } else {
        lan[i].isSelected = false;
        update();
      }
    }
    print(selectedIndex);
  }

  bool checkBannerValid(
      {required DateTime startDate, required DateTime endDate}) {
    DateTime now = DateTime.now();
    // end date is after or today and sart date is before or today show add
    if (startDate.isBefore(now) && endDate.isAfter(now)) {
      return true;
    }
    return false;
  }

  Future<void> getBanner() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHomeBanner().then((result) {
            if (result.status == "200") {
              bannerList = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get banner',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getBanner:-" + e.toString());
    }
  }

  Future<void> getBlog() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHomeBlog().then((result) {
            if (result.status == "200") {
              blogList = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get Blogs',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getBlog:-" + e.toString());
    }
  }

  Future<void> getAstroNews() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstroNews().then((result) {
            if (result.status == "200") {
              astroNews = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get astro news',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getAstroNews:-" + e.toString());
    }
  }

  Future<void> getMyOrder() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHomeOrder().then((result) {
            if (result.status == "200") {
              myOrders = result.recordList;
              update();
            } else {
              // global.showToast(
              //   message: 'Failed to get my orders',
              //   textColor: global.textColor,
              //   bgColor: global.toastBackGoundColor,
              // );
            }
          });
        }
      });
    } catch (e) {
      myOrders.clear();
      update();
      print("Exception in getMyOrder:-" + e.toString());
    }
  }

  Future<void> getAstrologyVideos() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstroVideos().then((result) {
            if (result.status == "200") {
              astrologyVideo = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get Astrology video',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getAstrologyVideos:-" + e.toString());
    }
  }

  Future<void> getClientsTestimonals() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAppReview().then((result) {
            if (result.status == "200") {
              clientReviews = result.recordList;
              update();
            } else {
              // global.showToast(
              //   message: 'Failed to get client testimonals',
              //   textColor: global.textColor,
              //   bgColor: global.toastBackGoundColor,
              // );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getClientsTestimonals:-" + e.toString());
    }
  }

  incrementBlogViewer(int id) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.viewerCount(id).then((result) {
            if (result.status == "200") {
              print('success');
            } else {
              global.showToast(
                message: 'Faild to increment blog viewer',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in incrementBlogViewer:- " + e.toString());
    }
  }

  addFeedback(String review) async {
    var appReviewModel = {
      "appId": global.appId,
      "review": review,
    };
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.addAppFeedback(appReviewModel).then((result) {
            if (result.status == "200") {
              feedbackController.text = '';

              global.showToast(
                message: 'Thank you!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showToast(
                message: 'Failed to add feedback',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in addFeedback():- " + e.toString());
    }
  }

  Future<void> getLanguages() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog(Get.context);
          await apiHelper.getLanguagesForMultiLanguage().then((result) {
            global.hideLoader();
            if (result.status == "200") {
              lan.addAll(result.recordList);
              update();
            } else {
              global.showToast(
                message: 'Failed to get language!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getLanguages():- " + e.toString());
    }
  }

  Future<void> getAllStories() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAllStory().then((result) {
            if (result.status == "200") {
              allStories = result.recordList;
              update();
            } else {
              // global.showToast(
              //   message: 'Failed to get client testimonals',
              //   textColor: global.textColor,
              //   bgColor: global.toastBackGoundColor,
              // );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getClientsTestimonals:-" + e.toString());
    }
  }

  Future<void> getAstroStory(String astroId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstroStory(astroId).then((result) {
            if (result.status == "200") {
              viewSingleStory = result.recordList;
              update();
            } else {
              // global.showToast(
              //   message: 'Failed to get client testimonals',
              //   textColor: global.textColor,
              //   bgColor: global.toastBackGoundColor,
              // );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getClientsTestimonals:-" + e.toString());
    }
  }

  Future<void> viewStory(String storyId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.storyViewed(storyId).then((result) {
            if (result.status == "200") {
              update();
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  storyViewed:-" + e.toString());
    }
  }
  void refreshIt() async {
    splashController.currentLanguageCode =
        lan[selectedIndex].lanCode;
    splashController.update();
    global.spLanguage = await SharedPreferences.getInstance();
    global.spLanguage!
        .setString('currentLanguage', splashController.currentLanguageCode);
    refresh();
    Get.back();
  }
  var freeLiveWebinarVideo = <VideoRecord>[];
  var freeLiveVastuVideo = <VideoRecord>[];
  var freeLiveRemediesVideo = <VideoRecord>[];


  bool _isWebinarLoading = false;
  bool get isWebinarLoading => _isWebinarLoading;

  Future<void> getLiveWebinarVideos() async {
    try {
      _isWebinarLoading = true;
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getLiveAstrologers("1").then((result) {
            if (result["status"] == 200) {
              freeLiveWebinarVideo = result["recordList"];
            } else {
              global.showToast(
                message: result["message"] ?? 'Failed to get live videos',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getBanner:- $e");
    } finally {
      _isWebinarLoading = false; // Set loading to false
      update(); // Notify listeners
    }
  }

  bool _isVastuLoading = false;
  bool get isVastuLoading => _isVastuLoading;

  Future<void> getLiveVastuVideos() async {
    try {
      _isVastuLoading = true;
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getLiveAstrologers("2").then((result) {
            if (result["status"] == 200) {
              freeLiveVastuVideo = result["recordList"];
            } else {
              global.showToast(
                message: result["message"] ?? 'Failed to get live videos',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getBanner:- $e");
    } finally {
      _isVastuLoading = false; // Set loading to false
      update(); // Notify listeners
    }
  }


  bool _isRemedyLoading = false;
  bool get isRemedyLoading => _isRemedyLoading;
  Future<void> getLiveRemedyVideos() async {
    try {
      _isRemedyLoading = true;
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getLiveAstrologers("3").then((result) {
            if (result["status"] == 200) {
              freeLiveRemediesVideo = result["recordList"];
            } else {
              global.showToast(
                message: result["message"] ?? 'Failed to get live videos',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getBanner:- $e");
    } finally {
      _isRemedyLoading = false; // Set loading to false
      update(); // Notify listeners
    }
  }

  bool _isLatestVideoLoading = false;
  bool get isLatestVideoLoading => _isLatestVideoLoading;
  var getAstrologyLatestVideo = <WatchVideoModel>[];

  Future<void> getAstrologyLatestVideos() async {
    print('running');
    try {
      _isLatestVideoLoading = true;
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getWatchVideos('1').then((result) {
            print("API Result: $result");

            if (result.status == "200" && result.recordList != null) {
              getAstrologyLatestVideo = List<WatchVideoModel>.from(result.recordList);
              print("Updated getAstrologyLatestVideo: $getAstrologyLatestVideo");
              update();
            } else {
              global.showToast(
                message: 'Failed to get Astrology video',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getAstrologyLatestVideos: $e");
    } finally {
      _isLatestVideoLoading = false; // Set loading to false
      update(); //
    }
  }

  var getAstrologyTrendingReelsVideo = <WatchVideoModel>[];
  bool _isTrendingReelsLoading = false;
  bool get isTrendingReelsLoading => _isTrendingReelsLoading;
  Future<void> getAstrologyTrendingReelsVideos() async {
    try {
      _isTrendingReelsLoading = true;
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getWatchVideos('2').then((result) {
            if (result.status == "200") {
              getAstrologyTrendingReelsVideo = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get Astrology video',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getAstrologyVideos:-" + e.toString());
    }  finally {
      _isTrendingReelsLoading = false; // Set loading to false
      update(); //
    }
  }
  var getAstrologyDailyHoroscopeVideo = <WatchVideoModel>[];
  bool _isDailyHoroscopeLoading = false;
  bool get isDailyHoroscopeLoading => _isDailyHoroscopeLoading;
  Future<void> getAstrologyDailyHoroscopeVideos() async {
    try {
      _isDailyHoroscopeLoading = true;
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getWatchVideos('3').then((result) {
            if (result.status == "200") {
              getAstrologyDailyHoroscopeVideo = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get Astrology video',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getAstrologyVideos:-" + e.toString());
    }  finally {
      _isDailyHoroscopeLoading = false; // Set loading to false
      update(); //
    }
  }

  bool _isMonthlyHoroscopeLoading = false;
  bool get isMonthlyHoroscopeLoading => _isMonthlyHoroscopeLoading;
  var getAstrologyMonthlyHoroscopeVideo = <WatchVideoModel>[];
  Future<void> getAstrologyMonthlyHoroscopeVideos() async {
    try {
      _isMonthlyHoroscopeLoading = true;
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getWatchVideos('4').then((result) {
            if (result.status == "200") {
              getAstrologyMonthlyHoroscopeVideo = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get Astrology video',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getAstrologyVideos:-" + e.toString());
    }  finally {
      _isMonthlyHoroscopeLoading = false; // Set loading to false
      update(); //
    }
  }

  var getAstrologyYearlyHoroscopeVideo = <WatchVideoModel>[];
  bool _isYearlyHoroscopeLoading = false;
  bool get isYearlyHoroscopeLoading => _isYearlyHoroscopeLoading;
  Future<void> getAstrologyYearlyHoroscopeVideos() async {
    try {
      _isYearlyHoroscopeLoading = true;
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getWatchVideos('5').then((result) {
            if (result.status == "200") {
              getAstrologyYearlyHoroscopeVideo = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get Astrology video',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getAstrologyVideos:-" + e.toString());
    }  finally {
      _isYearlyHoroscopeLoading = false; // Set loading to false
      update(); //
    }
  }

  var watchVideoList = <WatchVideoModel>[];


  List<MembershipPlanModel> membershipPlan = <MembershipPlanModel>[];

  Future<void> getMembershipPlans() async {
    global.showOnlyLoaderDialog(Get.context);
    update();

    try {
      var headers = {
        'Cookie': 'PHPSESSID=9ho9sa1vl67rc39larcrp4mlo1; XSRF-TOKEN=eyJpdiI6Im1iWjhlTW1URGxpTktGM2prc1JvSGc9PSIsInZhbHVlIjoidlZobHdkcGs4RWNBYjhLOE1xZ1dwL3ZibnRkTHFJcUFYVVpXM3dMemhWV3M0ZnBGNlI3ZGNPUjNSS2k5WnRVbFhXUUVtWU1SNHVoMUNGN1F5UjdYQTBucXFLYUwwSVh2NjhpMjFmMytua1plcG1jRFEvVXBQdDRpbjBTM2Z3S3MiLCJtYWMiOiI1MDY4NTgxMTY3MmI4NjZhZDVmZjJhNDBmNDIxODQ5NDQyMTFjMzNkZjViMTZkZjUyZWViYmNkMDJjZTYxYmFhIiwidGFnIjoiIn0%3D; astrokalp_session=eyJpdiI6ImJjdmlMdXZzNDhqTk5yOGpOVVhxaFE9PSIsInZhbHVlIjoiejlsa1VqUUZqUENXWHRMeXM3NTVUOWRTVktPVWc5RjhXNkVRc25FZW5oeGloRjBSbC8wL25ZZnBreDVFSXNvSzZWUXJlYWxJZ3VCa0Vra1grWlZtMzhrRnVjTE1PV3dzbE9MaVNwK0lLR3M3OFc3NnBXb3p4U3IwSVdKVFVPd1QiLCJtYWMiOiI3MzNhZmU2NjM3Yzk3NDAxNDI3NTgxNjM5NzNiNWJkMTQ3Y2FjZjUxYjUxNGZjM2E5MDFiOWQxODNmZTgyNjAxIiwidGFnIjoiIn0%3D',
        'Content-Type': 'application/json',
      };

      var request = http.Request('GET', Uri.parse('https://invoidea.work/astrokalp/api/get-plans'));
      request.headers.addAll(headers);

      // Log the request URL and headers
      print('Sending request to URL: ${request.url}');
      print('Request headers: ${request.headers}');

      // Send the request
      http.StreamedResponse response = await request.send();

      // Log the response status
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();

        // Log the raw response body
        print('Response body: $responseBody');

        var jsonData = json.decode(responseBody);

        // Log the decoded JSON data
        print('Decoded JSON data: $jsonData');

        membershipPlan.clear();

        // Ensure 'recordList' is an object and not a list, then map the response to the model
        if (jsonData['recordList'] != null && jsonData['recordList'] is Map) {
          var record = jsonData['recordList'];  // This should be a map, not a list
          membershipPlan.add(MembershipPlanModel.fromJson(record));  // Assuming your model can handle this

          // Log the membership plan
          print('Membership Plan: ${membershipPlan.map((e) => e.planName).toList()}');
        } else {
          print('Error: recordList is null or not a Map');
          membershipPlan = [];
        }
      } else {
        print('Error: ${response.reasonPhrase}');
        membershipPlan = [];
      }
    } catch (e) {
      // Handle any errors during the request
      print('Exception: $e');
      membershipPlan = []; // Ensure the list is empty on exception
    }

    global.hideLoader();
    update();
  }




}
