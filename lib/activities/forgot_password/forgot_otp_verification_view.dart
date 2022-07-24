import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/reset_password/reset_password_view.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/apiservice/url_string.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../apiservice/api_call.dart';
import '../../apiservice/key_string.dart';
import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../../utils/shared_preferences.dart';
import '../../utils/utility.dart';
import '../../widgets/form_submit_widget.dart';
import '../build_your_profile/build_your_profile_view.dart';
import '../create_business/set_up_business_profile.dart';
import '../../utils/globals.dart' as globals;

class ForgotOTPVerificationView extends StatefulWidget {
  String? phone;
  ForgotOTPVerificationView({Key? key, this.phone}) : super(key: key);

  @override
  State<ForgotOTPVerificationView> createState() {
    return _ForgotOTPVerificationView();
  }
}

class _ForgotOTPVerificationView extends State<ForgotOTPVerificationView>
    implements ApiInterface {
  bool isLoader = false;
  bool isResend = false;

  String otp = "";
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: Dimens.edgeInsets20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.blackColor,
                        size: Dimens.twentyEight,
                      ),
                    ),
                  ),
                  Dimens.boxHeight15,
                  Text(
                    NewMarkitVendorLocalizations.of(context)!
                        .find('verifyPhoneNumber'),
                    style: Styles.loginPageTitleBlack,
                  ),
                  Dimens.boxHeight15,
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: NewMarkitVendorLocalizations.of(context)!
                            .find('otpVerificationSubTitle'),
                        style: Styles.loginPageSubTitleGrey,
                      ),
                      TextSpan(
                        text: '${widget.phone}',
                        style: Styles.boldBlack16,
                      ),
                    ]),
                  ),
                  Dimens.boxHeight40,
                  Padding(
                    padding: Dimens.edgeInsets20_0_20_0,
                    child: PinCodeTextField(
                      length: 4,
                      appContext: context,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(Dimens.ten),
                          fieldHeight: Dimens.fifty,
                          fieldWidth: Dimens.fifty,
                          activeFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                          activeColor: AppColors.blackColor,
                          selectedColor: AppColors.blackColor,
                          inactiveColor: AppColors.blackColor.withOpacity(0.4),
                          borderWidth: Dimens.one),
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: AppColors.backgroundColor,
                      enableActiveFill: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      onCompleted: (v) {
                        otp = v;
                      },
                      onChanged: (value) {},
                      beforeTextPaste: (text) {
                        debugPrint('Allowing to paste $text');
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                  ),
                  Dimens.boxHeight20,
                  Dimens.boxHeight30,
                  isLoader
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : FormSubmitWidget(
                          key: const Key('send-link-button'),
                          opacity: 1,
                          disableColor: AppColors.primaryColor,
                          padding: Dimens.edgeInsets0,
                          text: NewMarkitVendorLocalizations.of(context)!
                              .find('verifyCode'),
                          textStyle: Styles.buttonWhiteTextStyle,
                          startColor: AppColors.primaryColor,
                          endColor: AppColors.primaryColor,
                          iconColor: Colors.white,
                          onTap: () {
                            validateInput();
                          },
                        ),
                  const Spacer(),
                  isResend
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            color: Color.fromARGB(255, 193, 18, 57),
                          ),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('havingProblem'),
                                style: Styles.grey14Regular),
                            TextButton(
                              key: const Key('sendCodeAgain'),
                              onPressed: () {
                                sendOtpAgain();
                              },
                              child: Text(
                                  NewMarkitVendorLocalizations.of(context)!
                                      .find('sendCodeAgain'),
                                  style: Styles.black14BoldUnderline),
                            )
                          ],
                        )
                ],
              ),
            ),
          ),
        ),
      );

  validateInput() {
    if (otp != "") {
      setState(() {
        isLoader = true;
      });
      ApiCall.verifyOtpApi(widget.phone!, otp, this, context);
    }
  }

  sendOtpAgain() {
    setState(() {
      isResend = true;
    });
    ApiCall.sendOtpApi(widget.phone!, this, context);
  }

  @override
  void onFailure(message) {
    Utility.errorMessage(message, context);

    setState(() {
      isLoader = false;
      isResend = false;
    });
  }

  @override
  void onSuccess(data) {
    Utility.successMessage(data['message'], context);

    if (isResend) {
    } else {
      print(data[KeyConstant.token]);
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: ResetPasswordView(
                phoneNumber: widget.phone,
              )));
    }
    setState(() {
      isLoader = false;
      isResend = false;
    });
  }

  @override
  void onTokenExpired() {
    // TODO: implement onTokenExpired
  }
}
