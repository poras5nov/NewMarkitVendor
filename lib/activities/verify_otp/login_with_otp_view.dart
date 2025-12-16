import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/login/login_view.dart';
import 'package:market_vendor_app/activities/verify_otp/otp_verification_view.dart';
import 'package:market_vendor_app/apiservice/api_call.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:page_transition/page_transition.dart';

import '../../apiservice/url_string.dart';
import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/asset_constants.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../../utils/utility.dart';
import '../../widgets/form_submit_widget.dart';
import '../build_your_profile/build_your_profile_view.dart';
import '../home_page/drawer_screen/common_page_screen.dart';

class RegisterWithOTPView extends StatefulWidget {
  @override
  State<RegisterWithOTPView> createState() {
    return _RegisterWithOTPView();
  }
}

class _RegisterWithOTPView extends State<RegisterWithOTPView>
    implements ApiInterface {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController(text: "");
  bool isLoader = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: Dimens.edgeInsets20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text('',
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
                                    onChanged: (val) {},
                                    countryList: [
                                      {
                                        'name': 'भारत',
                                        'code': 'IN',
                                        'dial_code': '+91',
                                      },
                                    ],
                                    padding: Dimens.edgeInsets2,
                                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                    initialSelection: 'IN',
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
                            Expanded(
                                child: Form(
                                    key: formkey, child: phoneTextFormFiled())),
                          ],
                        ),
                        Dimens.boxHeight40,
                        isLoader
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : FormSubmitWidget(
                                key: const Key('send-otp-button'),
                                opacity: 1,
                                disableColor: AppColors.primaryColor,
                                padding: Dimens.edgeInsets0,
                                text: NewMarkitVendorLocalizations.of(context)!
                                    .find('sendOTP'),
                                textStyle: Styles.buttonWhiteTextStyle,
                                startColor: AppColors.primaryColor,
                                endColor: AppColors.primaryColor,
                                iconColor: Colors.white,
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  validateInput();
                                },
                              ),
                        Dimens.boxHeight30,
                        if (true)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  NewMarkitVendorLocalizations.of(context)!
                                      .find('alreadyRegister'),
                                  style: Styles.grey14Regular),
                              TextButton(
                                key: const Key('NavigateToLogin'),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          child: LoginView()));
                                },
                                child: Text(
                                    NewMarkitVendorLocalizations.of(context)!
                                        .find('login')
                                        .toUpperCase(),
                                    style: Styles.primary14Underline),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                )),
                Padding(
                  padding: Dimens.edgeInsets20_0_20_0,
                  child: Column(
                    children: [
                      Dimens.boxHeight10,
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: NewMarkitVendorLocalizations.of(context)!
                                .find('byClickingTxt'),
                            style: Styles.grey12Regular,
                          ),
                          TextSpan(
                            text: NewMarkitVendorLocalizations.of(context)!
                                .find('privacyPolicy'),
                            style: Styles.black12BoldUnderline,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: CommonViewScreen(
                                          title:
                                              NewMarkitVendorLocalizations.of(
                                                      context)!
                                                  .find('privacyPolicy'),
                                          url: UrlConstant.privacyPolicy,
                                        ))).then((value) {});
                              },
                          ),
                          TextSpan(
                            text: NewMarkitVendorLocalizations.of(context)!
                                .find('and'),
                            style: Styles.grey12Regular,
                          ),
                          TextSpan(
                            text: NewMarkitVendorLocalizations.of(context)!
                                .find('termsAndConditions'),
                            style: Styles.black12BoldUnderline,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: CommonViewScreen(
                                          title:
                                              NewMarkitVendorLocalizations.of(
                                                      context)!
                                                  .find('termsAndConditions'),
                                          url: UrlConstant.termAndConditions,
                                        ))).then((value) {});
                              },
                          ),
                        ]),
                      ),
                      Dimens.boxHeight20
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );

  validateInput() {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      ApiCall.sendOtpApi(phoneController.text, this, context);
    }
  }

  phoneTextFormFiled() {
    return SizedBox(
      height: Dimens.sixty,
      width: MediaQuery.of(context).size.width,
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

  @override
  void onFailure(message) {
    Utility.errorMessage(message, context);

    setState(() {
      isLoader = false;
    });
  }

  @override
  void onSuccess(data) {
    Utility.successMessage(data['message'], context);

    setState(() {
      isLoader = false;
    });
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: OTPVerificationView(
              phone: phoneController.text,
            )));
  }

  @override
  void onTokenExpired() {
    // TODO: implement onTokenExpired
  }
}
