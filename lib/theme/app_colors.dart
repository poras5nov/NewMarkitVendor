// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A list of custom color used in the application.
///
/// Will be ignored for test since all are static values and would not change.
abstract class AppColors {
  static const Map<int, Color> primaryColorSwatch = {
    50: Color.fromRGBO(193, 18, 57, 0.1),
    100: Color.fromRGBO(193, 18, 57, 0.2),
    200: Color.fromRGBO(193, 18, 57, 0.3),
    300: Color.fromRGBO(193, 18, 57, 0.4),
    400: Color.fromRGBO(193, 18, 57, 0.5),
    500: Color.fromRGBO(193, 18, 57, 0.6),
    600: Color.fromRGBO(193, 18, 57, 0.7),
    700: Color.fromRGBO(193, 18, 57, 0.8),
    800: Color.fromRGBO(193, 18, 57, 0.9),
    900: Color.fromRGBO(193, 18, 57, 1.0),
  };

  static const Color primaryColorRgb = Color.fromRGBO(193, 18, 57, 1);

  static const Color primaryColorLight1Rgbo = Color.fromRGBO(1, 75, 147, .1);

  static const Color primaryColor = Color(
    0xffC11239,
  );
  static const Color primaryColorOpacity20 = Color(
    0xffFFEADA,
  );

  static const Color redColor = Color(
    0xffE92020,
  );
  static const Color greenColor = Color(
    0xff42CF3F,
  );
  static const Color formFieldBorderColor = Color(0xff5F527A);
  static const Color topColor = Color.fromARGB(255, 247, 210, 184);

  static Color greyColor = Colors.black.withOpacity(0.6);

  static Color blackColorOpacity20 = Colors.black.withOpacity(0.2);

  static const Color lightGreyColor = Color(
    0xFFF1F1F1,
  );
  static const Color lightGreyHintText = Color(
    0xFFA7A7A7,
  );

  static const Color lightPurple = Color(0xFFF1F6FE);

  static const Color textFieldErrorColor = Color(
    0xffe63f36,
  );

  static const Color textFieldColor = Color(
    0xFFFFFFFF,
  );
  static const Color blackColor = Color(
    0xff000000,
  );

  static const Color iconDefaultColor = Color(
    0xff4D4D4D,
  );

  static const Color descriptionGreyColor = Color(0xFFA7A7A7);

  static const Color resentOrderBackColor = Color(0xFFF1F6FE);

  static const Color borderColor = Colors.transparent;

  static Color backgroundColor = const Color(0xffffffff);

  static const int primaryColorHex = 0xffC11239;

  static const Color transparent = Color.fromARGB(0, 255, 255, 255);

  static const Color titleGreyColor = Color(
    0xFFB2AEAE,
  );
  static const Color lightGreyColor2 = Color(
    0xFF43586B,
  );
  static const Color lightBlueColor2 = Color(
    0xFF8293AF,
  );
  static const Color darkBlueColor = Color(
    0xFF173058,
  );
  static const Color darkGreyColor = Color(0xFF8293AF);

  static Color themeOppositeColor() =>
      Get.isDarkMode ? Colors.white : backgroundColor;

  static const Color revenuBackColor = Color(
    0xFF8293AF,
  );

  static const Color darkGreenColor = Color(
    0xFF126C72,
  );

  static const Color addNewProductColor = Color(
    0xFFE7CAAE,
  );

  static const Color addNewProductDarColor = Color(
    0xFFB67E49,
  );
  static const Color addNewServiceColor = Color(
    0xFFECDBDA,
  );
  static const Color addNewServiceDarkColor = Color(
    0xFF99615D,
  );

  static const Color yellowColor = Color(
    0xFFE9B020,
  );

  static const Color menuTextColor = Color(
    0xFF3E444F,
  );

  static const Color upgradeBoxColor = Color(
    0xFFC9D3E2,
  );
}
