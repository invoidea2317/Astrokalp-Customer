import 'dart:developer';
import 'dart:math';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/controllers/loginController.dart';
import 'package:AstrowayCustomer/utils/dimensions.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/utils/sizedboxes.dart';
import 'package:AstrowayCustomer/utils/text_styles.dart';
import 'package:AstrowayCustomer/views/settings/privacyPolicyScreen.dart';
import 'package:AstrowayCustomer/views/settings/termsAndConditionScreen.dart';
import 'package:AstrowayCustomer/widget/custom_button_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/Strings.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin{
  final LoginController loginController = Get.find<LoginController>();

  final HomeController homeController = Get.find<HomeController>();

  final _initialPhone = PhoneNumber(isoCode: "IN");
  late String? codeVerifier;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
       duration: const Duration(seconds: 8), // Double the duration
      vsync: this,
    )..repeat();
  }

  late AnimationController _controller;



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        print('call on will pop');
        SystemNavigator.pop();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.yellow.shade100, // Light yellow at the top
                  Theme.of(context).primaryColor, // Darker yellow at the bottom
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor, // Yellow shadow
                  blurRadius: 30,
                  spreadRadius: 10,
                  offset: Offset(0, 10), // Shadow positioned at the bottom
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Get.height * 0.06,
                      ),
                      Image.asset(
                        Images.icOfferTag,
                        width: 200,
                      ),
                      SizedBox(
                        height: Get.height * 0.06,
                      ),
                      Center(
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _controller.value * 2 * pi,
                              child: Image.asset(
                                Images.icLogo,
                                height: 160,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                     
                     
                     
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Text(Strings.appName,
                                      style: openSansMedium.copyWith(fontSize: Dimensions.fontSize24,
                                      color: Theme.of(context).primaryColorDark),
                                      textAlign: TextAlign.center),
                                  Container(
                                    height: 2,
                                    width: Get.width * 0.20,
                                    color: Theme.of(context).primaryColorDark,
                                  )
                                ],
                              ),
                            ),
                            Text('Login ',
                              style: openSansBold.copyWith(
                                  fontSize: Dimensions.fontSize30
                              ),),
                            SizedBox(
                              height: Get.height * 0.01,
                            ),
                            Text('Enter Your Phone Number to Login',
                              style: openSansRegular.copyWith(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: Dimensions.fontSize14
                              ),),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            GetBuilder<LoginController>(builder: (loginController) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 2),
                                      child: SizedBox(
                                        child: Theme(
                                          data: ThemeData(
                                            dialogTheme: DialogTheme(
                                              contentTextStyle: const TextStyle(
                                                  color: Colors.white),
                                              backgroundColor: Colors.grey[800],
                                              surfaceTintColor: Colors.grey[800],
                                            ),
                                          ),
                                          //MOBILE
                                          child: SizedBox(
                                            child: InternationalPhoneNumberInput(
                                              textFieldController:
                                                  loginController.phoneController,
                                              inputDecoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Phone number',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontFamily: "verdana_regular",
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                              onInputValidated: (bool value) {
                                                // log('$value');
                                              },
                                              selectorConfig: const SelectorConfig(
                                                leadingPadding: 2,
                                                selectorType: PhoneInputSelectorType
                                                    .BOTTOM_SHEET,
                                              ),
                                              ignoreBlank: false,
                                              autoValidateMode:
                                                  AutovalidateMode.disabled,
                                              selectorTextStyle: const TextStyle(
                                                  color: Colors.black),
                                              searchBoxDecoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(2.w)),
                                                    borderSide: const BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  hintText: "Search",
                                                  hintStyle: const TextStyle(
                                                    color: Colors.black,
                                                  )),
                                              initialValue: _initialPhone,
                                              formatInput: false,
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  signed: true, decimal: false),
                                              inputBorder: InputBorder.none,
                                              onSaved: (PhoneNumber number) {
                                                loginController.updateCountryCode(
                                                    number.dialCode);
                                                loginController.updateCountryCode(
                                                    number.dialCode);
                                              },
                                              onFieldSubmitted: (value) {
                                                FocusScope.of(context).unfocus();
                                              },
                                              onInputChanged: (PhoneNumber number) {
                                                loginController.updateCountryCode(
                                                    number.dialCode);
                                                loginController.updateCountryCode(
                                                    number.dialCode);
                                              },
                                              onSubmit: () {
                                                FocusScope.of(context).unfocus();
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                 sizedBoxDefault(),
                                        InkWell(
                                      onTap: (){
                                        global.showOnlyLoaderDialog(context);
                                        loginController.startHeadlessWithWhatsapp("GMAIL");
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey
                                            ),
                                            borderRadius: BorderRadius.circular(10.sp)
                                        ),
                                        width: 100.w,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset("assets/images/gmail.png",
                                              height:5.h,
                                              width: 7.w,
                                              fit: BoxFit.fitWidth,),
                                            SizedBox(width: 3.w,),
                                            Text('Continue with Gmail'),
                                          ],
                                        ),
                                      ),
                                    ),
                                 sizedBoxDefault(),
                                  CustomButtonWidget(buttonText: 'Send Otp ',
                                  onPressed: () {
                                      bool isValid = loginController.validedPhone();
                            
                                      if (isValid) {
                                        global.showOnlyLoaderDialog(context);
                                        loginController
                                            .startHeadlessWithWhatsapp('phone');
                                      } else {
                                        global.showToast(
                                          message: loginController.errorText!,
                                          textColor: global.textColor,
                                          bgColor: global.toastBackGoundColor,
                                        );
                                      }
                                  },
                                  suffixIcon: Icons.arrow_forward_outlined,
                                  color: Theme.of(context).dividerColor,
                                  textColor: Theme.of(context).primaryColor),
                                  // SizedBox(
                                  //   height: 1.h,
                                  // ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     global.showOnlyLoaderDialog(context);
                                  //     loginController.startHeadlessWithWhatsapp("WHATSAPP");
                                  //   },
                                  //   child: Container(
                                  //     alignment: Alignment.center,
                                  //     decoration: BoxDecoration(
                                  //         border: Border.all(
                                  //             color: Colors.grey
                                  //         ),
                                  //         borderRadius: BorderRadius.circular(10.sp)
                                  //     ),
                                  //     width: 100.w,
                                  //     child: Row(
                                  //       mainAxisAlignment: MainAxisAlignment.center,
                                  //       children: [
                                  //         Image.asset("assets/images/whatsapp.png",
                                  //           height:6.h,
                                  //           width: 16.w,
                                  //           fit: BoxFit.cover,),
                                  //         Text('Continue with Whatsapp'),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Text(
                                    'By logging in, you agree to our ',
                                    style:
                                        TextStyle(color: Colors.black, fontSize: 11),
                                  ).tr(),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => TermAndConditionScreen());
                                          },
                                          child: Text(' Terms of Service',
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: Theme.of(context).dividerColor)).tr(),
                                        ),
                                        Text(' and ',
                                                style: TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.black,
                                                    fontSize: 11))
                                            .tr(),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => PrivacyPolicyScreen());
                                          },
                                          child: Text(
                                            ' Privacy Policy',
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: Theme.of(context).dividerColor),
                                          ).tr(),
                                        ),
                                      
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                            SizedBox(height: Get.height * 0.03),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                        // height: 19.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                color: Theme.of(context).primaryColor,
                                elevation: 0,
                                margin: EdgeInsets.only(top: 6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 6)
                                      .copyWith(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            height: 68,
                                            width: 70,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              color: Theme.of(context).hintColor,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Image.asset(
                                                Images.confidential,
                                                height: 45,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            'Private &\nConfidential',
                                            textAlign: TextAlign.center,
                                            style: Get
                                                .theme.textTheme.titleMedium!
                                                .copyWith(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.0,
                                            ),
                                          ).tr(),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            height: 65,
                                            width: 70,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              color: Theme.of(context).hintColor,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Image.asset(
                                                Images.verifiedAccount,
                                                height: 45,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            'Verified\nAstrologers',
                                            textAlign: TextAlign.center,
                                            style: Get
                                                .theme.textTheme.titleMedium!
                                                .copyWith(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.0,
                                            ),
                                          ).tr(),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            height: 65,
                                            width: 70,
                                            decoration: BoxDecoration(
                                             shape: BoxShape.circle,
                                              color: Theme.of(context).hintColor,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Image.asset(
                                                Images.payment,
                                                height: 45,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            'Secure\nPayments',
                                            textAlign: TextAlign.center,
                                            style: Get
                                                .theme.textTheme.titleMedium!
                                                .copyWith(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.0,
                                            ),
                                          ).tr(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 5.0;

  @override
  Path getClip(Size size) {
    Path path_1 = Path();
    path_1.moveTo(size.width * -0.0034000, size.height * -0.0005200);
    path_1.lineTo(size.width * 1.0044000, size.height * 0.0041400);
    path_1.quadraticBezierTo(size.width * 1.0017750, size.height * 0.6117900,
        size.width * 1.0009000, size.height * 0.8143400);
    path_1.cubicTo(
        size.width * 0.7438000,
        size.height * 1.0302400,
        size.width * 0.3289375,
        size.height * 1.0551400,
        size.width * 0.0006000,
        size.height * 0.8136600);
    path_1.quadraticBezierTo(size.width * -0.0010250, size.height * 0.6101200,
        size.width * -0.0034000, size.height * -0.0005200);
    path_1.close();

    return path_1;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class LeftTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white; // Triangle color

    Path path = Path();
    path.moveTo(size.width, size.height / 2);
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class RightTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white; // Triangle color

    Path path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
