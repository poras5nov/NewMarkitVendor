import 'package:flutter/material.dart';

import '../utils/strings/app_constants.dart';
import 'app_colors.dart';
import 'dimens.dart';

/// A chunk of styles used in the application.
/// Will be ignored for test since all are static values and would not change.
// coverage:ignore-file
abstract class Styles {
  static RoundedRectangleBorder buttonShapeBorder = RoundedRectangleBorder(
    side: BorderSide(
      color: Colors.white,
      width: Dimens.one,
      style: BorderStyle.solid,
    ),
    borderRadius: BorderRadius.circular(
      Dimens.fifty,
    ),
  );

  static RoundedRectangleBorder border15 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(
      Dimens.fifteen,
    ),
  );

  // light theme data
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    backgroundColor: AppColors.backgroundColor,
    primarySwatch: const MaterialColor(
      AppColors.primaryColorHex,
      AppColors.primaryColorSwatch,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: AppConstants.appRegularFontFamily,
    textTheme: TextTheme(
      bodyText1: bodyTextLight1,
      bodyText2: bodyTextLight2,
      subtitle1: subtitleLight1,
      subtitle2: subtitleLight2,
      caption: captionLight,
      button: buttonLight,
      headline1: headlineLight1,
      headline2: headlineLight2,
      headline3: headlineLight3,
      headline4: headlineLight4,
      headline5: headlineLight5,
      headline6: headlineLight6,
    ),
    buttonTheme: buttonThemeData,
    elevatedButtonTheme: elevatedButtonTheme,
    textButtonTheme: textButtonTheme,
  );

  static TextStyle mediumWhite16 = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    fontWeight: FontWeight.normal,
    color: AppColors.backgroundColor,
    fontSize: Dimens.sixTeen,
  );

  static var elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(
        mediumWhite16,
      ),
      padding: MaterialStateProperty.all(
        Dimens.edgeInsets15,
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Dimens.five,
          ),
        ),
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) => AppColors.primaryColor,
      ),
    ),
  );

  static var textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(
        normalWhite18,
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Dimens.fifty,
          ),
        ),
      ),
    ),
  );

  static TextStyle normalWhite18 = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: Colors.white,
    fontSize: Dimens.eighteen,
    fontWeight: FontWeight.normal,
  );

  static ButtonThemeData buttonThemeData = ButtonThemeData(
      buttonColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Dimens.fifty,
        ),
      ));

  static TextStyle whiteLight14 = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontSize: Dimens.fourteen,
    color: Colors.white,
    fontWeight: FontWeight.normal,
  );
  static TextStyle whiteLight12 = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontSize: Dimens.twelve,
    color: Colors.white,
    fontWeight: FontWeight.normal,
  );
  static TextStyle whiteLight10 = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontSize: Dimens.ten,
    color: Colors.white,
    fontWeight: FontWeight.normal,
  );

  // Different style used in the application
  // light
  static TextStyle bodyTextLight1 = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontSize: Dimens.fourteen,
    color: Colors.black,
    fontWeight: FontWeight.normal,
  );
  static TextStyle bodyTextLight2 = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontSize: Dimens.sixTeen,
    color: Colors.black,
    fontWeight: FontWeight.normal,
  );
  static TextStyle subtitleLight1 = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    color: AppColors.titleGreyColor,
    fontSize: Dimens.twelve,
    fontWeight: FontWeight.normal,
  );
  static TextStyle subtitleLight2 = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    color: AppColors.titleGreyColor,
    fontSize: Dimens.eighteen,
    fontWeight: FontWeight.normal,
  );

  static TextStyle captionLight = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    color: AppColors.titleGreyColor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.normal,
  );
  static TextStyle buttonLight = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontWeight: FontWeight.bold,
    fontSize: Dimens.sixTeen,
  );

  static TextStyle headlineLight1 = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontSize: Dimens.twentySix,
    color: AppColors.lightGreyColor2,
    fontWeight: FontWeight.bold,
  );
  static TextStyle headlineLight2 = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontSize: Dimens.twentyTwo,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static TextStyle headlineLight3 = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontSize: Dimens.twenty,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static TextStyle headlineLight4 = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontSize: Dimens.eighteen,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static TextStyle headlineLight5 = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontSize: Dimens.sixTeen,
    color: AppColors.lightGreyColor2,
    fontWeight: FontWeight.bold,
  );
  static TextStyle headlineLight6 = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontSize: Dimens.fourteen,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static TextStyle buttonTextStyle = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    color: Colors.white,
    fontSize: Dimens.eighteen,
    fontWeight: FontWeight.normal,
  );
  static TextStyle productTitle = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    fontSize: Dimens.twentyTwo,
    color: AppColors.addNewProductDarColor,
  );
  static TextStyle serviceTitle = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    fontSize: Dimens.twentyTwo,
    color: AppColors.addNewServiceDarkColor,
  );
  static TextStyle loginPageTitleBlack = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    fontSize: Dimens.twentyTwo,
    color: Colors.black,
  );
  static TextStyle loginPageTitleBlack2 = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    fontSize: Dimens.twentyTwo,
    color: Colors.black,
  );

  static TextStyle unsSelectedText12 = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    fontSize: Dimens.twelve,
    color: AppColors.greyColor,
  );
  static TextStyle selectedText12 = TextStyle(
      fontFamily: AppConstants.appMediumFontFamily,
      fontSize: Dimens.twelve,
      color: Colors.white,
      fontWeight: FontWeight.bold);

  static TextStyle daysTitleBlack = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    fontSize: Dimens.fourteen,
    color: Colors.black,
  );

  static TextStyle listItemTitleBlack = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    fontSize: Dimens.sixTeen,
    color: Colors.black,
  );
  static TextStyle listItemDesBlack = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontSize: Dimens.fourteen,
    color: AppColors.descriptionGreyColor,
    height: 1.2,
    letterSpacing: 0.5,
    fontWeight: FontWeight.bold,
  );

  static TextStyle toolBarTitleBlack = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    fontSize: Dimens.eighteen,
    color: Colors.black,
  );

  static TextStyle loginPageSubTitleGrey = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontSize: Dimens.fourteen,
    color: AppColors.blackColor,
    height: 1.4,
    letterSpacing: 1,
    fontWeight: FontWeight.bold,
  );

  static TextStyle pricestrickTitleGrey = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontSize: Dimens.fourteen,
    color: AppColors.blackColor,
    height: 1.4,
    letterSpacing: 1,
    decoration: TextDecoration.lineThrough,
    fontWeight: FontWeight.bold,
  );
  static TextStyle pricestrickTitle12Grey = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontSize: Dimens.fourteen,
    color: AppColors.blackColor,
    height: 1.4,
    letterSpacing: 1,
    decoration: TextDecoration.lineThrough,
    fontWeight: FontWeight.bold,
  );
  static TextStyle pricestrickTitleGrey12 = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontSize: Dimens.fourteen,
    color: AppColors.greyColor,
    height: 1.4,
    letterSpacing: 1,
    decoration: TextDecoration.lineThrough,
    fontWeight: FontWeight.bold,
  );
  static TextStyle boldWhite14 = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    fontSize: Dimens.fourteen,
    color: Colors.white,
  );
  static TextStyle boldWhite16 = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    fontSize: Dimens.sixTeen,
    color: Colors.white,
  );
  static TextStyle boldBlack30 = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    fontSize: Dimens.thirty,
    color: Colors.black,
  );

  static TextStyle boldBlack16 = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    fontSize: Dimens.sixTeen,
    color: Colors.black,
  );
  static TextStyle boldMenuText16 = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    fontSize: Dimens.sixTeen,
    color: AppColors.menuTextColor,
  );
  static TextStyle boldMenuText14 = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    fontSize: Dimens.sixTeen,
    color: AppColors.menuTextColor,
  );

  static TextStyle boldDarkGreen14 = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    fontSize: Dimens.fourteen,
    color: AppColors.darkGreenColor,
  );

  static TextStyle boldBlack14 = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    fontSize: Dimens.fourteen,
    color: Colors.black,
  );
  static TextStyle boldGreen14 = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    fontSize: Dimens.fourteen,
    color: Colors.green,
  );
  static TextStyle boldRed14 = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    fontSize: Dimens.fourteen,
    color: AppColors.primaryColor,
  );
  static TextStyle boldBlack18 = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    fontSize: Dimens.eighteen,
    color: Colors.black,
  );

  static TextStyle boldBlack12 = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    fontSize: Dimens.twelve,
    color: Colors.black,
  );
  static TextStyle mediumBlack16 = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    fontSize: Dimens.sixTeen,
    color: Colors.black,
  );
  static TextStyle mediumDarkGreen14 = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    fontSize: Dimens.fourteen,
    color: AppColors.darkGreenColor,
  );
  static TextStyle redMedium14 = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    fontSize: Dimens.fourteen,
    color: AppColors.redColor,
  );
  static TextStyle redLight14 = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    fontSize: Dimens.fourteen,
    color: AppColors.redColor,
  );

  static TextStyle redMedium16 = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    fontSize: Dimens.sixTeen,
    color: AppColors.redColor,
  );

  static TextStyle yellowMedium14 = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    fontSize: Dimens.fourteen,
    color: AppColors.yellowColor,
  );
  static TextStyle yellowMedium12 = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    fontSize: Dimens.fourteen,
    color: AppColors.yellowColor,
  );
  static TextStyle buttonBlackTextStyle = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    color: Colors.black,
    fontSize: Dimens.sixTeen,
    fontWeight: FontWeight.normal,
  );
  static TextStyle buttonWhiteTextStyle = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    color: Colors.white,
    fontSize: Dimens.sixTeen,
    fontWeight: FontWeight.normal,
  );

  static TextStyle grey14Underline = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: AppColors.greyColor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.underline,
  );

  static TextStyle grey14Medium = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    color: AppColors.greyColor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.normal,
  );

  static TextStyle darkGrey18Medium = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: AppColors.darkGreyColor.withOpacity(0.6),
    fontSize: Dimens.twenty,
    fontWeight: FontWeight.normal,
  );
  static TextStyle darkGrey14Medium = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    color: AppColors.darkGreyColor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.bold,
  );
  static TextStyle primary16Medium = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    color: AppColors.primaryColor,
    fontSize: Dimens.sixTeen,
    fontWeight: FontWeight.normal,
  );
  static TextStyle primary14Medium = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    color: AppColors.primaryColor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.normal,
  );
  static TextStyle primary13 = TextStyle(
    fontFamily: AppConstants.appLightFontFamily,
    color: AppColors.primaryColor,
    fontSize: Dimens.thirteen,
    fontWeight: FontWeight.normal,
  );

  static TextStyle primary14Bold = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    color: AppColors.primaryColor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.normal,
  );

  static TextStyle grey16Regular = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: AppColors.greyColor,
    fontSize: Dimens.sixTeen,
    fontWeight: FontWeight.normal,
  );
  static TextStyle grey14Regular = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: AppColors.greyColor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.normal,
  );
  static TextStyle grey12Regular = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: AppColors.greyColor,
    fontSize: Dimens.twelve,
    fontWeight: FontWeight.normal,
  );
  static TextStyle grey10Regular = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: AppColors.greyColor,
    fontSize: Dimens.twelve,
    fontWeight: FontWeight.normal,
  );

  static TextStyle primary14Underline = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: AppColors.primaryColor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.underline,
  );
  static TextStyle black14BoldUnderline = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    color: AppColors.blackColor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.underline,
  );
  static TextStyle black12BoldUnderline = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    color: AppColors.blackColor,
    fontSize: Dimens.twelve,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.underline,
  );
  static TextStyle blackMedium16 = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    color: AppColors.blackColor,
    fontSize: Dimens.sixTeen,
    fontWeight: FontWeight.w100,
  );
  static TextStyle blackMedium14 = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    color: AppColors.blackColor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.w100,
  );
  static TextStyle blackMedium12 = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    color: AppColors.blackColor,
    fontSize: Dimens.twelve,
    fontWeight: FontWeight.w100,
  );

  static TextStyle black12 = TextStyle(
      fontFamily: AppConstants.appRegularFontFamily,
      color: AppColors.blackColor,
      fontSize: Dimens.fourteen,
      height: 1,
      letterSpacing: 0.5);

  static TextStyle listItemDesGrey = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: AppColors.lightGreyHintText,
    fontSize: Dimens.fourteen,
  );

  static TextStyle lightGrey12 = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: AppColors.lightGreyHintText,
    fontSize: Dimens.twelve,
    fontWeight: FontWeight.normal,
  );

  static TextStyle lightGreyHint = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: AppColors.lightGreyHintText,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.normal,
  );

  static TextStyle lightRed14 = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: AppColors.redColor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.normal,
  );
  static TextStyle lightWhite14 = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: Colors.white,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.normal,
  );

  static TextStyle lightGrey14 = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: AppColors.lightGreyHintText,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.normal,
  );

  static TextStyle lightBlue14 = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: AppColors.lightBlueColor2,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.normal,
  );
  static TextStyle boldBlue16 = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: AppColors.lightBlueColor2,
    fontSize: Dimens.sixTeen,
    fontWeight: FontWeight.bold,
  );

  static TextStyle lightGreen14 = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: AppColors.greenColor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.normal,
  );
  static TextStyle darkGreen14 = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    color: Colors.green,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.normal,
  );

  static TextStyle errorStyle = TextStyle(
    fontFamily: AppConstants.appRegularFontFamily,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.normal,
    color: AppColors.textFieldErrorColor,
  );
  static TextStyle formFieldTextStyle = TextStyle(
    fontFamily: AppConstants.appMediumFontFamily,
    fontWeight: FontWeight.normal,
    color: AppColors.blackColor,
    fontSize: Dimens.sixTeen,
  );

  static BoxDecoration cardBlueDecoration = BoxDecoration(
    border: Border.all(
        width: Dimens.two, color: AppColors.darkBlueColor.withOpacity(0.5)),
    color: AppColors.darkBlueColor,
    borderRadius: BorderRadius.circular(Dimens.fifteen),
  );

  static BoxDecoration primaryBorderRadius15 = BoxDecoration(
    border: Border.all(width: Dimens.two, color: AppColors.primaryColor),
    borderRadius: BorderRadius.circular(Dimens.fifteen),
  );

  static BoxDecoration whiteBorderRadius15 = BoxDecoration(
    border: Border.all(width: Dimens.two, color: Colors.white),
    borderRadius: BorderRadius.circular(Dimens.fifteen),
  );

  static BoxDecoration whiteRadius15 = BoxDecoration(
    border: Border.all(width: Dimens.two, color: Colors.white),
    color: Colors.white,
    borderRadius: BorderRadius.circular(Dimens.fifteen),
  );

  static BoxDecoration primaryOpacityGradient = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
        AppColors.primaryColorOpacity20,
        Colors.white,
        Colors.white,
        Colors.white,
        Colors.white
      ]));

  static BoxDecoration tagGreyDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(Dimens.sixTeen),
    color: AppColors.darkGreyColor.withOpacity(0.8),
    border: Border.all(
      width: 0.5,
      color: AppColors.darkGreyColor,
    ),
  );

  static BoxDecoration transparentBlackRounded6 = BoxDecoration(
    borderRadius: BorderRadius.circular(Dimens.six),
    color: AppColors.blackColor.withOpacity(0.11),
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    boxShadow: [
      BoxShadow(
          color: AppColors.greyColor.withOpacity(0.15),
          offset: const Offset(1, 1),
          blurRadius: 12.0)
    ],
    border: Border.all(width: Dimens.one, color: Colors.transparent),
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
  );

  static TextStyle cardTitleBlack = TextStyle(
    fontFamily: AppConstants.appBoldFontFamily,
    fontSize: Dimens.eighteen,
    color: Colors.black,
  );
}
