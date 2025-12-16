import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:market_vendor_app/apiservice/key_string.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../theme/app_colors.dart';
import '../widgets/cupertino_viewer.dart';
import '../widgets/material_viewer.dart';
import 'new_market_vendor_localizations.dart';

// coverage:ignore-file
abstract class Utility {
  // coverage:ignore-start
  File? imageFile;

  static List<bool> passwordValidator(String password) {
    var validationStatus = <bool>[false, false, false, false];
    validationStatus[0] = password.length >= 8;
    validationStatus[1] = RegExp(r'(?=.*[A-Z])').hasMatch(password);
    validationStatus[2] = RegExp(r'(?=.*?[0-9])').hasMatch(password);
    validationStatus[3] =
        RegExp(r'(?=.*[_+,/:;<>`{}|"%!-@#\$&*~])').hasMatch(password);
    return validationStatus;
  }

  /// Show alert dialog
  static void showAlertDialog({
    required String message,
    required String title,
    required Function() onPress,
  }) async {
    await Get.dialog<dynamic>(
      CupertinoAlertDialog(
        title: Text('$title'),
        content: Text('$message'),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: onPress,
            child: const Text('Yes'),
          ),
          const CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: closeDialog,
            child: Text('No'),
          )
        ],
      ),
    );
  }

  /// Close any open snack bar.
  static void closeSnackBar() {
    if (Get.isSnackbarOpen) Get.back<void>();
  }

  /// Show error dialog from response model

  static String? validatePassword(String value) {
    if (value.trim().isNotEmpty) {
      if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        if (value.contains(RegExp(r'[A-Z]'))) {
          if (value.contains(RegExp(r'[0-9]'))) {
            if (value.length < 6) {
              return 'shouldBe6Characters'.tr;
            } else {
              return null;
            }
          } else {
            return 'shouldHaveOneDigit'.tr;
          }
        } else {
          return 'shouldHaveOneUppercaseLetter'.tr;
        }
      } else {
        return 'shouldHaveOneSpecialCharacter'.tr;
      }
    } else {
      return 'passwordRequired'.tr;
    }
  }

  /// Show error dialog from response model
  static void showDialog(String message) async {
    await Get.dialog<dynamic>(
      CupertinoAlertDialog(
        title: const Text('SUCCESS'),
        content: Text(
          message,
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: Get.back,
            isDefaultAction: true,
            child: const Text(
              'Okay',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  static bool emailValidator(String email) => EmailValidator.validate(email);

  static void dialogLoader(BuildContext context) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        });
  }

  /// Close any open dialog.
  static void closeDialog() {
    if (Get.isDialogOpen ?? false) Get.back<void>();
  }

  /// Returns true if the internet connection is available.
  static Future<bool> isNetworkAvailable() async =>
      await InternetConnectionChecker().hasConnection;

  /// Close any open snackbar
  static void closeSnackbar() {
    if (Get.isSnackbarOpen) Get.back<void>();
  }

  /// Print info log.
  ///
  /// [message] : The message which needed to be print.
  static void printLog(dynamic message) {
    Logger().log(Level.info, message);
  }

  /// Show loader
  static void showLoader() async {
    await Get.dialog<dynamic>(
      const Center(
        child: SizedBox(
          height: 60,
          width: 60,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static String getWeekFullDayFromInt(BuildContext context, int? value) {
    var day = NewMarkitVendorLocalizations.of(context)!.find('monday');
    switch (value) {
      case 0:
        day = NewMarkitVendorLocalizations.of(context)!.find('monday');
        break;
      case 1:
        day = NewMarkitVendorLocalizations.of(context)!.find('tuesday');
        break;
      case 2:
        day = NewMarkitVendorLocalizations.of(context)!.find('wednesday');
        break;
      case 3:
        day = NewMarkitVendorLocalizations.of(context)!.find('thursday');
        break;
      case 4:
        day = NewMarkitVendorLocalizations.of(context)!.find('friday');
        break;
      case 5:
        day = NewMarkitVendorLocalizations.of(context)!.find('saturday');
        break;
      case 6:
        day = NewMarkitVendorLocalizations.of(context)!.find('sunday');
        break;
    }
    return day;
  }

  static checkTextFiledValid(String phone, BuildContext context) {
    if (phone.isEmpty) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('thisFieldIsRequired');
    } else {
      return null;
    }
  }

  static checkGSTValid(String phone, BuildContext context) {
    if (phone.isEmpty) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('thisFieldIsRequired');
    }
    if (phone.length != 15) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('adharCardValidations');
    } else {
      return null;
    }
  }

  static checkPanValid(String phone, BuildContext context) {
    if (phone.isEmpty) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('thisFieldIsRequired');
    }
    if (phone.length != 10) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('adharCardValidations');
    } else {
      return null;
    }
  }

  static checkAdharNumberValid(String phone, BuildContext context) {
    if (phone.isEmpty) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('thisFieldIsRequired');
    }
    if (phone.length != 12) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('adharCardValidations');
    } else {
      return null;
    }
  }

  static checkOfferTextFiledValid(
      String bPrice, String oPrice, BuildContext context) {
    if (oPrice.isEmpty) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('thisFieldIsRequired');
    } else if (bPrice.isNotEmpty) {
      if (int.parse(oPrice) > int.parse(bPrice)) {
        return NewMarkitVendorLocalizations.of(context)!
            .find('offerPriceError');
      }
    } else {
      return null;
    }
  }

  static checkTimeFiledValid(String phone, BuildContext context) {
    if (phone.isEmpty) {
      return NewMarkitVendorLocalizations.of(context)!.find('selectTime');
    } else {
      return null;
    }
  }

  static checkEmailValid(String phone, BuildContext context) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);
    if (phone.isEmpty) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('thisFieldIsRequired');
    } else {
      if (!regExp.hasMatch(phone)) {
        return NewMarkitVendorLocalizations.of(context)!
            .find('pleaseEnterValidEmail');
      } else {
        return null;
      }
    }
  }

  static checkIfPhoneIsValid(String phone, BuildContext context) {
    String patttern = r'^(\+91[\-\s]?)?[0]?(91)?[6789]\d{9}$';
    RegExp regExp = RegExp(patttern);
    if (phone.isEmpty) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('thisFieldIsRequired');
    } else if (!regExp.hasMatch(phone)) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('pleaseEnterValidPhone');
    } else {
      return null;
    }
  }

  static checkIfPasswordIsValid(String password, BuildContext context) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (password.isEmpty) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('thisFieldIsRequired');
    } else {
      if (!regex.hasMatch(password)) {
        return NewMarkitVendorLocalizations.of(context)!
            .find('passwordKeyValidate');
      } else {
        return null;
      }
    }
  }

  static checkConfirmPasswordValid(
      String password, String confirmPassword, BuildContext context) {
    if (password.isEmpty) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('thisFieldIsRequired');
    } else if (password != confirmPassword) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('passwordsDoNotMatch');
    } else {
      return null;
    }
  }

  static checkIfConfirmPasswordIsValid(
      String password, String confirmPassword, BuildContext context) {
    if (confirmPassword.isEmpty) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('thisFieldIsRequired');
    } else {
      if (password != confirmPassword) {
        return NewMarkitVendorLocalizations.of(context)!
            .find('passwordAndConfirmPasswordShouldBeSame');
      } else {
        return null;
      }
    }
  }

  static brandCategoryFiledValid(String phone, BuildContext context) {
    if (phone.isEmpty) {
      return NewMarkitVendorLocalizations.of(context)!.find('error_brand');
    } else {
      return null;
    }
  }

  static ispopularFiledValid(String phone, BuildContext context) {
    if (phone.isEmpty) {
      return NewMarkitVendorLocalizations.of(context)!.find('error_ispopular');
    } else {
      return null;
    }
  }

  static selectAttributesFiledValid(String phone, BuildContext context) {
    if (phone.isEmpty) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('please_select_attributes');
    } else {
      return null;
    }
  }

  static selectCategoryFiledValid(String phone, BuildContext context) {
    if (phone.isEmpty) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('error_category_msg');
    } else {
      return null;
    }
  }

  static selectParentCategoryFiledValid(String phone, BuildContext context) {
    if (phone.isEmpty) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('error_parent_category_msg');
    } else {
      return null;
    }
  }

  static selectSubCategoryFiledValid(String phone, BuildContext context) {
    if (phone.isEmpty) {
      return NewMarkitVendorLocalizations.of(context)!
          .find('error_parent_sub_category_msg');
    } else {
      return null;
    }
  }

  static successMessage(String message, BuildContext context) {
   ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(message),
    backgroundColor: Colors.green,   // optional
    duration: Duration(seconds: 2),  // how long it stays visible
    behavior: SnackBarBehavior.floating, // makes it float above bottom nav
  ),
);
  }

  static errorMessage(String message, BuildContext context) {
   ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,   // red for error
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
  ),
);
  }

  // static String? userName() {
  //   return jsonDecode(SharedPref.getProfileData())[KeyConstant.name];
  // }

  // static String? userId() {
  //   return jsonDecode(SharedPref.getProfileData())[KeyConstant.id].toString();
  // }

  // static String? businessCount() {
  //   return jsonDecode(SharedPref.getProfileData())[KeyConstant.businessesCount]
  //       .toString();
  // }

  // static String? email() {
  //   return jsonDecode(SharedPref.getProfileData())[KeyConstant.email]
  //       .toString();
  // }

  // static String? phone() {
  //   return jsonDecode(SharedPref.getProfileData())[KeyConstant.phone]
  //       .toString();
  // }

  // static String? gender() {
  //   return jsonDecode(SharedPref.getProfileData())[KeyConstant.gender]
  //       .toString();
  // }

  // static String? profile() {
  //   return jsonDecode(SharedPref.getProfileData())[KeyConstant.profile]
  //       .toString();
  // }

  static String getPrettyJSONString(jsonObject) {
    var encoder = const JsonEncoder.withIndent("     ");
    return encoder.convert(jsonObject);
  }

  static facebookEvent(var eventName) {
    final facebookAppEvents = FacebookAppEvents();
    facebookAppEvents.logEvent(
      name: eventName,
    );
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.logEvent(
      name: eventName,
    );
  }

  static facebookEventWithParametter(
      var eventName, Map<String, dynamic> param) {
    final facebookAppEvents = FacebookAppEvents();
    facebookAppEvents.logEvent(
      name: eventName,
      parameters: param,
    );
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.logEvent(
      name: eventName,
      parameters: param,
    );
  }
}
