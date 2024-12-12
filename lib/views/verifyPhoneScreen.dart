// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:io';
import 'package:AstrowayCustomer/controllers/loginController.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/utils/sizedboxes.dart';
import 'package:AstrowayCustomer/views/settings/privacyPolicyScreen.dart';
import 'package:AstrowayCustomer/views/settings/termsAndConditionScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:otp_autofill/otp_autofill.dart';
import '../widget/custom_button_widget.dart';


class VerifyPhoneScreen extends StatefulWidget {
  final String phoneNumber;
  VerifyPhoneScreen(
      {Key? key, required this.phoneNumber,})
      : super(key: key);

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {

  final LoginController loginController = Get.find<LoginController>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final pinEditingControllerlogin = TextEditingController(text: '');
  late OTPTextEditController otpController;
  late OTPInteractor otpInteractor;

  @override
  void initState() {
    super.initState();
    otpInteractor = OTPInteractor();
    otpController = OTPTextEditController(
      codeLength: 6,
      onCodeReceive: (code) {
        print('Received OTP: $code');
      },
      otpInteractor: otpInteractor,
    );
    otpController.startListenUserConsent(
          (code) {
        final otpRegex = RegExp(r'(\d{6})');
        return otpRegex.firstMatch(code!)?.group(1) ?? '';
      },
    );
  }

  @override
  void dispose() {
    otpController.stopListen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        loginController.maxSecond=61;
        loginController.time!.cancel();
        loginController.update();
        return true;
      },
      child: Scaffold(
        appBar: kIsWeb
            ? AppBar(elevation: 0,
          leading: SizedBox(),
          backgroundColor: Theme.of(context).primaryColor,
        )
            : AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Verify Phone',
            style: Get.textTheme.titleMedium,
          ).tr(),
          leading: IconButton(
              onPressed: () {
                Get.delete<LoginController>(force: true);
                Get.back();
              },
              icon: Icon(
                kIsWeb
                    ? Icons.arrow_back
                    : Platform.isIOS
                    ? Icons.arrow_back_ios
                    : Icons.arrow_back,
                color: Colors.black,
              )),
        ),
        backgroundColor:  Theme.of(context).primaryColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Center(
                  child: Image.asset(
                    Images.icLogo,
                    fit: BoxFit.cover,
                    height: 160,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter OTP',
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withOpacity(0.70,),
                        fontSize: 14,),
                    ),
                    Text(
                      'We Have Sent Verification Code to ${widget.phoneNumber}',
                      maxLines: 2,
                      style: TextStyle(color: Colors.black.withOpacity(0.70,),
                      fontSize: 11,),
                    ).tr(),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                PinInputTextField(
                  pinLength: 6,
                  decoration: BoxLooseDecoration(
                    strokeColorBuilder: PinListenColorBuilder(
                        Theme.of(context).cardColor, Theme.of(context).cardColor),
                    bgColorBuilder: PinListenColorBuilder(
                        Colors.white, Colors.white),
                  ),
                  controller: otpController,
                  textInputAction: TextInputAction.done,
                  enabled: true,
                  keyboardType: TextInputType.number,
                  onSubmit: (pin) {
                    loginController.smsCode = pin;
                    loginController.update();
                  },
                  onChanged: (pin) {
                    loginController.smsCode = pin;
                    loginController.update();
                    // debugPrint('onChanged execute. pin:$pin');
                  },
                  enableInteractiveSelection: false,
                ),
                // OtpTextField(
                //   numberOfFields: 6,
                //   showFieldAsBox: true,
                //   onCodeChanged: (value) {},
                //   onSubmit: (value) {
                //     loginController.smsCode = value;
                //     loginController.update();
                //   },
                //   filled: true,
                //   fillColor: Theme.of(context).cardColor,
                //   fieldWidth: 48,
                //   borderColor: Colors.transparent,
                //   enabledBorderColor: Colors.transparent,
                //   focusedBorderColor: Colors.transparent,
                //   borderRadius: BorderRadius.circular(10),
                //   margin: EdgeInsets.only(right: 4),
                // ),
                sizedBoxDefault(),
                Center(
                  child: Text(textAlign: TextAlign.center,
                    'By logging in, you agree to our ',
                    style:
                    TextStyle(color: Colors.black, fontSize: 11),
                  ).tr(),
                ),
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
                SizedBox(
                  height: 15,
                ),

                SizedBox(
                  width: kIsWeb ? Get.width * 0.25 : double.infinity,
                  child: GetBuilder<LoginController>(builder: (c) {
                    return c.isLoading ?
                        Center(child: CircularProgressIndicator()) :
                    c.isLoading ?
                    Center(child: CircularProgressIndicator()) :
                    CustomButtonWidget(buttonText: 'Send Otp ',
                        onPressed: () {
                              loginController.verifyLoginOtp(otpController.text);
                        },
                        suffixIcon: Icons.arrow_forward_outlined,
                        color: Theme.of(context).dividerColor,
                        textColor: Theme.of(context).primaryColor);
                    //   ElevatedButton(
                    //   onPressed: () async {
                    //     loginController.verifyLoginOtp(pinEditingControllerlogin.text);
                    //   //   try {
                    //   //     Map<String, dynamic> arg = {};
                    //   //     arg["phone"] = "${phoneNumber}";
                    //   //     arg["countryCode"] = "+91";
                    //   //     arg["otp"] = "${loginController.smsCode}";
                    //   //     global.showOnlyLoaderDialog(context);
                    //   //     print('verificationId : ${loginController.verificationIdBySentOtp}');
                    //   //     PhoneAuthCredential credential =
                    //   //     PhoneAuthProvider.credential(
                    //   //       verificationId: loginController.verificationIdBySentOtp,smsCode: loginController.smsCode,
                    //   //     );
                    //   //     print('Check signInWithCredential');
                    //   //     global.showOnlyLoaderDialog(context);
                    //   //     await auth.signInWithCredential(credential);
                    //   //     print('Check Credientials');
                    //   //     print(credential);
                    //   //     print(credential.verificationId);
                    //   //     await loginController.loginAndSignupUser(int.parse(phoneNumber),"");
                    //   //   } catch (e) {
                    //   //     global.hideLoader();
                    //   //
                    //   //     global.showToast(
                    //   //       message: "OTP INVALID",
                    //   //       textColor: Colors.white,
                    //   //       bgColor: Colors.red,
                    //   //     );
                    //   //     print("Exception " + e.toString());
                    //   //   }
                    //   },
                    //   child: Text(
                    //     'SUBMIT',
                    //     style: TextStyle(color: Colors.white),
                    //   ).tr(),
                    //   style: ButtonStyle(
                    //     shape: MaterialStateProperty.all(
                    //       RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //     ),
                    //     padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                    //     backgroundColor:
                    //     MaterialStateProperty.all(Get.theme.primaryColorDark),
                    //     textStyle: MaterialStateProperty.all(
                    //         TextStyle(fontSize: 18, color: Colors.black)),
                    //   ),
                    // );
                  }
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                // GetBuilder<LoginController>(builder: (c) {
                //   return SizedBox(
                //       child: loginController.maxSecond != 0
                //           ? Row(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         mainAxisAlignment: kIsWeb
                //             ? MainAxisAlignment.center
                //             : MainAxisAlignment.start,
                //         children: [
                //           SizedBox(
                //             width: 15,
                //           ),
                //             Text(
                //             'Resend OTP Available in ${loginController.maxSecond} s',
                //             style: TextStyle(
                //                 color: Get.theme.primaryColorDark,
                //                 fontWeight: FontWeight.w500),
                //           ).tr()
                //         ],
                //       )
                //           : Column(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           crossAxisAlignment: kIsWeb
                //               ? CrossAxisAlignment.center
                //               : CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               'Resend OTP Available',
                //               style: TextStyle(
                //                   color: Colors.green,
                //                   fontWeight: FontWeight.w500),
                //             ).tr(),
                //             Row(
                //               mainAxisAlignment:
                //               MainAxisAlignment.spaceBetween,
                //               children: [
                //                 ElevatedButton(
                //                   onPressed: () {
                //                     loginController.maxSecond = 60;
                //                     // loginController.second = 0;
                //                     loginController.update();
                //                     loginController.timer();
                //                     loginController.phoneController.text =
                //                         phoneNumber;
                //                     global.showOnlyLoaderDialog(context);
                //                     loginController.startHeadlessWithWhatsapp('phone');
                //                   },
                //                   child: Text(
                //                     'Resend OTP on SMS',
                //                     style: TextStyle(
                //                         color: Colors.white,
                //                         fontWeight: FontWeight.w500),
                //                   ).tr(),
                //                   style: ButtonStyle(
                //                     shape: MaterialStateProperty.all(
                //                       RoundedRectangleBorder(
                //                         borderRadius:
                //                         BorderRadius.circular(10),
                //                       ),
                //                     ),
                //                     padding: MaterialStateProperty.all(
                //                         EdgeInsets.only(
                //                             left: 25, right: 25)),
                //                     backgroundColor:
                //                     MaterialStateProperty.all(
                //                         Get.theme.primaryColor),
                //                     textStyle: MaterialStateProperty.all(
                //                         TextStyle(
                //                             fontSize: 12,
                //                             color: Colors.black)),
                //                   ),
                //                 ),
                //               ],
                //             )
                //           ]));
                // })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
