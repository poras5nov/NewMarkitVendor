import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:market_vendor_app/activities/forgot_password/forgot_password_view.dart';
import 'package:market_vendor_app/activities/login_with_otp/login_with_otp_view.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/apiservice/key_string.dart';
import 'package:market_vendor_app/utils/new_market_vendor_localizations.dart';
import 'package:market_vendor_app/utils/utility.dart';
import 'package:page_transition/page_transition.dart';

import '../../apiservice/api_call.dart';
import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/asset_constants.dart';
import '../../utils/shared_preferences.dart';
import '../../widgets/form_submit_widget.dart';
import '../build_your_profile/build_your_profile_view.dart';
import '../create_business/set_up_business_profile.dart';
import '../verify_otp/login_with_otp_view.dart';
import '../../utils/globals.dart' as globals;

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() {
    return _LoginViewScreen();
  }
}

class _LoginViewScreen extends State<LoginView> implements ApiInterface {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  bool isLoader = false;
  bool isPasswordVisible = true;
  LatLng? currentPostion;

  @override
  void initState() {
    super.initState();
    // _getUserLocation();
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SafeArea(
              child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: Dimens.edgeInsets20,
              child: Form(
                key: formkey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('skip'),
                            textAlign: TextAlign.start,
                            style: Styles.boldBlack16),
                      ),
                      SizedBox(
                        width: Dimens.percentWidth(0.5),
                        height: Dimens.percentHeight(0.10),
                        child: SvgPicture.asset(
                          AssetConstants.loginLogo,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Dimens.boxHeight20,
                      Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('loginTitle'),
                        style: Styles.loginPageTitleBlack,
                      ),
                      Dimens.boxHeight15,
                      Text(
                          NewMarkitVendorLocalizations.of(context)!
                              .find('loginSubTitle'),
                          style: Styles.loginPageSubTitleGrey),
                      Dimens.boxHeight20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: Dimens.fiftynne,
                                child: CountryCodePicker(
                                  onChanged: print,
                                  padding: Dimens.edgeInsets2,
                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                  initialSelection: 'IN',
                                  countryList: [
                                    {
                                      'name': 'भारत',
                                      'code': 'IN',
                                      'dial_code': '+91',
                                    },
                                  ],
                                  flagWidth: Dimens.twenty,
                                  // optional. Shows only country name and flag
                                  showCountryOnly: false,
                                  // optional. Shows only country name and flag when popup is closed.
                                  showOnlyCountryWhenClosed: false,
                                  // optional. aligns the flag and the Text left
                                  alignLeft: false,
                                  textStyle: Styles.formFieldTextStyle,
                                ),
                              ),
                              Container(
                                height: 0.6,
                                width: Dimens.ninety,
                                color: AppColors.blackColor,
                              )
                            ],
                          ),
                          Dimens.boxWidth15,
                          Expanded(child: phoneTextFormFiled()),
                        ],
                      ),
                      Dimens.boxHeight20,
                      passwordTextFormFiled(),
                      Dimens.boxHeight10,
                      Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: ForgotPasswordView()));
                            },
                            child: Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('forgotPasswordWithQuestion'),
                                textAlign: TextAlign.start,
                                style: Styles.primary14Underline)),
                      ),
                      Dimens.boxHeight10,
                      isLoader
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            )
                          : FormSubmitWidget(
                              key: const Key('login-button'),
                              opacity: 1,
                              disableColor: AppColors.primaryColor,
                              padding: Dimens.edgeInsets0,
                              text: NewMarkitVendorLocalizations.of(context)!
                                  .find('login'),
                              textStyle: Styles.buttonWhiteTextStyle,
                              startColor: AppColors.primaryColor,
                              endColor: AppColors.primaryColor,
                              iconColor: Colors.white,
                              onTap: () {
                                validateInput();
                              },
                            ),
                      Dimens.boxHeight30,
                      FormSubmitWidget(
                        opacity: 1,
                        disableColor: AppColors.primaryColor,
                        padding: Dimens.edgeInsets0,
                        text: NewMarkitVendorLocalizations.of(context)!
                            .find('loginWithOTP'),
                        textStyle: Styles.buttonBlackTextStyle,
                        startColor: AppColors.lightGreyColor,
                        endColor: AppColors.lightGreyColor,
                        iconColor: Colors.white,
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: LoginWithOTPView()));
                        },
                      ),
                      Dimens.boxHeight20,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('doNotHaveAccount'),
                              style: Styles.grey14Regular),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: RegisterWithOTPView()));
                            },
                            child: Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('signUp')
                                    .toUpperCase(),
                                style: Styles.primary14Underline),
                          )
                        ],
                      ),
                    ]),
              ),
            ),
          ))));

  validateInput() {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      ApiCall.loginWithPasswordApi(
          "+91" + phoneController.text.replaceAll("-", ""),
          passwordController.text,
          this,
          context);
    }
  }

  phoneTextFormFiled() {
    return SizedBox(
      height: Dimens.sixty,
      width: Get.width,
      child: TextFormField(
        controller: phoneController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: AppColors.primaryColor,
        textAlignVertical: TextAlignVertical.center,
        style: Styles.formFieldTextStyle,
        keyboardType: TextInputType.number,
        onChanged: (v) {
          setState(() {});
        },
        validator: (v) => Utility.checkIfPhoneIsValid(v!, context),
        decoration: InputDecoration(
          labelText: (phoneController.text.length == 0 ||
                  phoneController.text.length == 10)
              ? NewMarkitVendorLocalizations.of(context)!.find('phoneNumber')
              : "",
          labelStyle: Styles.lightGrey14,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
        ),
      ),
    );
  }

  passwordTextFormFiled() {
    return TextFormField(
      obscureText: isPasswordVisible,
      controller: passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      validator: (v) => Utility.checkIfPasswordIsValid(v!, context),
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('password'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
            icon: isPasswordVisible
                ? Icon(CupertinoIcons.eye_slash,
                    color: AppColors.lightGreyHintText, size: Dimens.eighteen)
                : Icon(CupertinoIcons.eye,
                    color: AppColors.lightGreyHintText, size: Dimens.eighteen)),
      ),
    );
  }

  @override
  void onFailure(message) {
    Utility.errorMessage(message, context);

    print(message);
    setState(() {
      isLoader = false;
    });
  }

  @override
  void onSuccess(data) {
    setState(() {
      isLoader = false;
    });
    print(data);
    Utility.successMessage(data['message'], context);

    SharedPref.saveLoginToken(data['token']);
    var d = jsonEncode(data);
    SharedPref.saveProfileData(d);
    if (data['data']['businesses_count'] == 0) {
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.fade, child: SetUpBusinessProfile()));
    } else {
      if (data['data']['businesses']['is_verified'].toString() == "Yes") {
        SharedPref.setLoginStatus(KeyConstant.LOGINSTATUS, true);
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/TabScreen', (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/VerifiedScreen', (Route<dynamic> route) => false);
      }
      print(globals.msg);
    }
  }

  @override
  void onTokenExpired() {}
}
