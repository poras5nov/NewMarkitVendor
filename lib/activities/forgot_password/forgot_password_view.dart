import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/forgot_password/forgot_otp_verification_view.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:page_transition/page_transition.dart';

import '../../apiservice/api_call.dart';
import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../../utils/utility.dart';
import '../../widgets/form_submit_widget.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  State<ForgotPasswordView> createState() {
    return _ForgotPasswordView();
  }
}

class _ForgotPasswordView extends State<ForgotPasswordView>
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
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
                            .find('forgotPassword'),
                        style: Styles.loginPageTitleBlack,
                      ),
                      Dimens.boxHeight15,
                      Text(
                          NewMarkitVendorLocalizations.of(context)!
                              .find('forgotPasswordSubTitle'),
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
                                validateInput();
                              },
                            )
                    ]),
              ),
            ),
          )));

  validateInput() {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      ApiCall.sendOtpApi(
          "+91" + phoneController.text.replaceAll("-", ""), this, context);
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
            child: ForgotOTPVerificationView(
              phone: "+91" + phoneController.text.replaceAll("-", ""),
            )));
  }

  @override
  void onTokenExpired() {
    // TODO: implement onTokenExpired
  }
}
