import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/homeController.dart';
import '../utils/sizedboxes.dart';

class LanguageDialogWidget extends StatelessWidget {
   LanguageDialogWidget({super.key});
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (h) {
      return AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        content: GetBuilder<HomeController>(builder: (h) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              sizedBoxDefault(),
              InkWell(
                onTap: () => Get.back(),
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 2,
                    top: 2,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: const Icon(Icons.close),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.all(6),
                  child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Choose your app language',
                          style: Get
                              .textTheme.titleMedium!
                              .copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ).tr(),
                        GetBuilder<HomeController>(
                            builder: (home) {
                              return Padding(
                                padding:
                                EdgeInsets.only(top: 15),
                                child: Wrap(
                                    children: List.generate(
                                        homeController.lan
                                            .length, (index) {
                                      return InkWell(
                                        onTap: () {
                                          //! LANGUAGE SET DILAOG
                                          homeController
                                              .updateLan(index);
                                          switch (index) {
                                            case 0:
                                              var newLocale =
                                              const Locale(
                                                  'en',
                                                  'US'); //ENGLISH

                                              context.setLocale(
                                                  newLocale);
                                              Get.updateLocale(
                                                  newLocale);
                                              homeController.refreshIt();

                                              break;
                                            case 1:
                                              var newLocale =
                                              const Locale(
                                                  'gu', 'IN');
                                              context.setLocale(
                                                  newLocale);
                                              Get.updateLocale(
                                                  newLocale);
                                              homeController.refreshIt();

                                              break;
                                            case 2:
                                              var newLocale =
                                              const Locale(
                                                  'hi',
                                                  'IN'); //HINDI
                                              context.setLocale(
                                                  newLocale);
                                              Get.updateLocale(
                                                  newLocale);
                                              homeController.refreshIt();

                                              break;
                                            case 3:
                                              var newLocale =
                                              const Locale(
                                                  'es',
                                                  'ES'); //Spanish
                                              context.setLocale(
                                                  newLocale);
                                              Get.updateLocale(
                                                  newLocale);
                                              homeController.refreshIt();

                                              break;
                                            case 4:
                                              var newLocale =
                                              const Locale(
                                                  'mr',
                                                  'IN'); //marathi
                                              context.setLocale(
                                                  newLocale);
                                              Get.updateLocale(
                                                  newLocale);
                                              homeController.refreshIt();

                                              break;
                                            case 5:
                                              var newLocale =
                                              const Locale(
                                                  'bn',
                                                  'IN'); //bengali
                                              context.setLocale(
                                                  newLocale);
                                              Get.updateLocale(
                                                  newLocale);
                                              homeController.refreshIt();

                                              break;

                                            case 6:
                                              var newLocale =
                                              const Locale(
                                                  'kn',
                                                  'IN'); //kannad
                                              context.setLocale(
                                                  newLocale);
                                              Get.updateLocale(
                                                  newLocale);
                                              homeController.refreshIt();

                                              break;

                                            case 7:
                                              var newLocale =
                                              const Locale(
                                                  'ml',
                                                  'IN'); //malayalam
                                              context.setLocale(
                                                  newLocale);
                                              Get.updateLocale(
                                                  newLocale);
                                              homeController.refreshIt();

                                              break;

                                            case 8:
                                              var newLocale =
                                              const Locale(
                                                  'ta',
                                                  'IN'); //tamil
                                              context.setLocale(
                                                  newLocale);
                                              Get.updateLocale(
                                                  newLocale);
                                              homeController.refreshIt();

                                              break;
                                          }
                                        },
                                        child: GetBuilder<
                                            HomeController>(
                                            builder: (h) {
                                              return Container(
                                                height: 80,
                                                alignment:
                                                Alignment.center,
                                                margin:
                                                EdgeInsets.only(
                                                    left: 7,
                                                    right: 7,
                                                    top: 10),
                                                width: 75,
                                                padding: EdgeInsets
                                                    .symmetric(
                                                    horizontal: 8,
                                                    vertical: 8),
                                                decoration:
                                                BoxDecoration(
                                                  color: homeController
                                                      .lan[index]
                                                      .isSelected
                                                      ? Color
                                                      .fromARGB(
                                                      255,
                                                      228,
                                                      217,
                                                      185)
                                                      : Colors
                                                      .transparent,
                                                  border: Border.all(
                                                      color: homeController
                                                          .lan[
                                                      index]
                                                          .isSelected
                                                          ? Get.theme
                                                          .primaryColor
                                                          : Colors
                                                          .black),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      10),
                                                ),
                                                child: Column(
                                                    mainAxisSize:
                                                    MainAxisSize
                                                        .min,
                                                    children: [
                                                      Text(
                                                        homeController
                                                            .lan[
                                                        index]
                                                            .title,
                                                        style: Get
                                                            .textTheme
                                                            .bodyMedium,
                                                      ),
                                                      Text(
                                                        homeController
                                                            .lan[
                                                        index]
                                                            .subTitle,
                                                        style: Get
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                            fontSize:
                                                            12),
                                                      )
                                                    ]),
                                              );
                                            }),
                                      );
                                    })),
                              );
                            }),
                      ])),
              sizedBoxDefault(),
            ],
          );
        }),
      );
    });
  }
}
