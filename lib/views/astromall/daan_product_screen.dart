import 'package:AstrowayCustomer/controllers/astromallController.dart';
import 'package:AstrowayCustomer/widget/customAppbarWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
class DaanProductDetailsScreen extends StatelessWidget {
  final String slug;
  final bool? isPooja;
  const DaanProductDetailsScreen({super.key, required this.slug,  this.isPooja = false});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(isPooja! == true) {
        Get.find<AstromallController>().getPoojaProductsDetails(slug);
        print('getPoojaProductsDetails');
      } else {
        Get.find<AstromallController>().getDaanProductsDetails(slug);
        print('getDaanProductsDetails');

      }

    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomApp(title:isPooja! ? 'Pooja' : 'Daan',isBackButtonExist: true,),
      body: SingleChildScrollView(
        child:
        isPooja! ?
        Column(
          children: [
            GetBuilder<AstromallController>(builder: (astromallController) {
              return Column(
                  children: [
                    astromallController.poojaProductDetails.length == 0 ?
                    Center(child: SizedBox(),)
                        : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          childAspectRatio: 3 / 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(8),
                        shrinkWrap: true,
                        itemCount: astromallController.poojaProductDetails.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {

                            },
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              height: 300,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
                                  image: NetworkImage("${global.imgBaseurl}${astromallController.poojaProductDetails[index].productImage}"),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    astromallController.poojaProductDetails[index].name,
                                    maxLines: 2,
                                    textAlign: TextAlign.start,
                                    style: Get.textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 12),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${astromallController.poojaProductDetails[index].amount}/-', style: Get.textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 11)),
                                      SizedBox(
                                        height: 30,
                                        child: TextButton(
                                            onPressed: () async {
                                            },
                                            child: Text(
                                              'Buy',
                                              style: Get.textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 11),
                                            ).tr(),
                                            style: ButtonStyle(
                                              padding: WidgetStateProperty.all(EdgeInsets.all(0)),
                                              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                                side: BorderSide(color: Colors.white),
                                                borderRadius: BorderRadius.circular(30.0),
                                              )),
                                            )),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ],
                );
            }),


          ],
        ) :

        Column(
          children: [
            GetBuilder<AstromallController>(builder: (astromallController) {
            return

                Column(
                  children: [
                    astromallController.daanProductDetails.length == 0
                      ?
                                  Center(
                    child: SizedBox(),
                                  )
                      : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250,
                        childAspectRatio: 3 / 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemCount: astromallController.daanProductDetails.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {

                          },
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            height: 300,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
                                image: NetworkImage("${global.imgBaseurl}${astromallController.daanProductDetails[index].productImage}"),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  astromallController.daanProductDetails[index].name,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  style: Get.textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 12),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${astromallController.daanProductDetails[index].amount}/-', style: Get.textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 11)),
                                    SizedBox(
                                      height: 30,
                                      child: TextButton(
                                          onPressed: () async {
                                          },
                                          child: Text(
                                            'Buy',
                                            style: Get.textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 11),
                                          ).tr(),
                                          style: ButtonStyle(
                                            padding: WidgetStateProperty.all(EdgeInsets.all(0)),
                                            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                              side: BorderSide(color: Colors.white),
                                              borderRadius: BorderRadius.circular(30.0),
                                            )),
                                          )),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                );
            }),


          ],
        ) ,
      ),
    );
  }
}
