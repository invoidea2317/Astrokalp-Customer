import 'package:AstrowayCustomer/controllers/astromallController.dart';
import 'package:AstrowayCustomer/widget/customAppbarWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

import 'daan_product_screen.dart';
class AllDaanViewScreen extends StatelessWidget {
  final bool? isPooja;
  const AllDaanViewScreen({super.key, this.isPooja = false});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(isPooja! == true) {
        Get.find<AstromallController>().getPoojaProducts();
        print('getPoojaProductsDetails');
      } else {
        Get.find<AstromallController>().getDaanProducts();
        print('getDaanProductsDetails');
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomApp(title:isPooja! ? 'All Pooja' :  'All Daan', isBackButtonExist: true,),
      body: SingleChildScrollView(
        child: GetBuilder<AstromallController>(builder: (astromallController) {
          return
            isPooja! ?
            GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 250, childAspectRatio: 3 / 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(8),
                shrinkWrap: true,
                itemCount: astromallController.poojaProducts.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      Get.to(() => DaanProductDetailsScreen(slug: astromallController.poojaProducts[index].slug,isPooja: true,),);
                    },
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: 300,
                      padding: index == 1 ? EdgeInsets.all(0) : EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4),
                            BlendMode.darken,
                          ),
                          image: NetworkImage("${global.imgBaseurl}${astromallController.poojaProducts[index].productImage}"),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: index == 1
                          ? Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  astromallController.poojaProducts[index].name,
                                  textAlign: TextAlign.center,
                                  style: Get.textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
                      )
                          : Text(
                        astromallController.poojaProducts[index].name,
                        textAlign: TextAlign.center,
                        style: Get.textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }):

            GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 250, childAspectRatio: 3 / 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(8),
              shrinkWrap: true,
              itemCount: astromallController.daanProducts.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    Get.to(() => DaanProductDetailsScreen(slug: astromallController.daanProducts[index].slug,),);
                  },
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height: 300,
                    padding: index == 1 ? EdgeInsets.all(0) : EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.darken,
                        ),
                        image: NetworkImage("${global.imgBaseurl}${astromallController.daanProducts[index].productImage}"),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: index == 1
                        ? Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                astromallController.daanProducts[index].name,
                                textAlign: TextAlign.center,
                                style: Get.textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    )
                        : Text(
                      astromallController.daanProducts[index].name,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              });
        })




      ),
    );
  }
}
