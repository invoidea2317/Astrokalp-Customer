import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/utils/sizedboxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../utils/images.dart';

class MembershipComponent extends StatelessWidget {
  const MembershipComponent({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<HomeController>().getMembershipPlans();

    });
    return GetBuilder<HomeController>(builder: (homeController) {
      return  Container(
        padding: EdgeInsets.only(left: 20,top: 20,bottom: 20),
        child: SizedBox(height: 300,
          child: ListView.separated(
              itemCount: homeController.membershipPlan.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_,i) {
                return Stack(
                  children: [
                    Container(
                      height: 300,
                      width: 200,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: Image.asset(Images.icMembershipBg,fit: BoxFit.cover,),
                    ),
                    Positioned(
                        top: 10,
                        child: Text(homeController.membershipPlan[i].planName!))
                  ],
                );
              }, separatorBuilder: (BuildContext context, int index) => sizedBoxW15(),),
        ),
      );

    });



  }
}
