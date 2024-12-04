import 'package:AstrowayCustomer/controllers/themeController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Map<int, Color> color = {
  50: const Color.fromRGBO(198, 29, 36, .1),
  100: const Color.fromRGBO(198, 29, 36, .2),
  200: const Color.fromRGBO(198, 29, 36, .3),
  300: const Color.fromRGBO(198, 29, 36, .4),
  400: const Color.fromRGBO(198, 29, 36, .5),
  500: const Color.fromRGBO(198, 29, 36, .6),
  600: const Color.fromRGBO(198, 29, 36, .7),
  700: const Color.fromRGBO(198, 29, 36, .8),
  800: const Color.fromRGBO(198, 29, 36, .9),
  900: const Color.fromRGBO(198, 29, 36, 1),
};

ThemeController themeController = Get.find<ThemeController>();
ThemeData nativeTheme({bool? darkModeEnabled}) {
  if (darkModeEnabled == null) {
    darkModeEnabled = false;
  }
  if (darkModeEnabled) {
    return ThemeData(
      appBarTheme: AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent)),
      fontFamily: 'OpenSans',
      primaryColor: Color(0xffF1D900),
      primaryColorLight: Colors.black,
      primarySwatch: MaterialColor(themeController.pickColorInt, color),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
        primaryTextTheme: TextTheme(
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
    );
  }
  else {
    return ThemeData(
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      fontFamily: 'OpenSans',
      dividerColor: Colors.black,
      disabledColor: Colors.black.withOpacity(0.70),
      hoverColor: Color(0xff4D2A7C),
      primaryColor: Color(0xffF1D900),
      cardColor: Colors.white,
      primaryColorDark: Color(0xffBD7A2C),
      hintColor: Color(0xff4D2A7C).withOpacity(0.15),
      highlightColor: Color(0xff0E971C),
      primaryColorLight: themeController.pickColor,
      iconTheme: IconThemeData(color: Colors.black),
      primaryIconTheme: IconThemeData(color: Colors.black),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: Colors.black),
        displayMedium: TextStyle(color: Colors.black),
        displaySmall: TextStyle(color: Colors.black),
        headlineMedium: TextStyle(color: Colors.black),
        headlineSmall: TextStyle(color: Colors.black),
        titleLarge: TextStyle(color: Colors.black),
        bodySmall: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
        titleSmall: TextStyle(color: Colors.black),
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
      ),
      primaryTextTheme: TextTheme(
        displayLarge: TextStyle(color: Colors.black),
        displayMedium: TextStyle(color: Colors.black),
        displaySmall: TextStyle(color: Colors.black),
        headlineMedium: TextStyle(color: Colors.black),
        headlineSmall: TextStyle(color: Colors.black),
        titleLarge: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
        titleSmall: TextStyle(color: Colors.black),
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        bodySmall: TextStyle(color: Colors.black),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(themeController.pickColor),
          foregroundColor: WidgetStateProperty.all(const Color(0xFFF5F5F5)),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: MaterialColor(themeController.pickColorInt, color),
      ),
    );
  }
}
const Color redColor= Color(0xffDB292C);
const Color primaryGreenColor = Color(0xff0e971c);
const Color lightPrimary= Color(0xffFDF9D5);
const Color blackBgPrimary= Color(0xff212121);
const Color primarypinkColor= Color(0xffFFB19c);
