// ignore_for_file: must_be_immutable

import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/life_cycle_controller.dart';
import '../utils/images.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);
  final splashController = Get.put(SplashController());
  final homeCheckController = Get.put(HomeCheckController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(Images.icSplash),
      ),
    );
  }
}
