import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/login/login_view.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:page_transition/page_transition.dart';

import '../../apiservice/api_call.dart';
import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../../utils/utility.dart';
import '../../widgets/form_submit_widget.dart';

class ResetPasswordView extends StatefulWidget {
  String? phoneNumber;

  ResetPasswordView({Key? key, this.phoneNumber}) : super(key: key);

  @override
  State<ResetPasswordView> createState() {
    return _ResetPasswordView();
  }
}

class _ResetPasswordView extends State<ResetPasswordView>
    implements ApiInterface {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController confirmPasswordController =
      TextEditingController(text: "");

  bool isLoader = false;
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  @override
  void initState() {
    print(widget.phoneNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: Dimens.edgeInsets20,
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                          .find('resetPasswordSubTitle'),
                      style: Styles.loginPageTitleBlack,
                    ),
                    Dimens.boxHeight15,
                    Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('youCanReset'),
                        style: Styles.loginPageSubTitleGrey),
                    Dimens.boxHeight20,
                    passwordTextFormFiled(),
                    Dimens.boxHeight20,
                    confirmPasswordTextFormFiled(),
                    Dimens.boxHeight50,
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
                                .find('submit'),
                            textStyle: Styles.buttonWhiteTextStyle,
                            startColor: AppColors.primaryColor,
                            endColor: AppColors.primaryColor,
                            iconColor: Colors.white,
                            onTap: () {
                              validateInput();
                            },
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  passwordTextFormFiled() {
    return TextFormField(
      obscureText: isPasswordVisible,
      controller: passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.text,
      validator: (v) => Utility.checkIfPasswordIsValid(v!, context),
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

  confirmPasswordTextFormFiled() {
    return TextFormField(
      obscureText: isConfirmPasswordVisible,
      controller: confirmPasswordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.text,
      validator: (v) => Utility.checkConfirmPasswordValid(
          passwordController.text, v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('confirmPassword'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isConfirmPasswordVisible = !isConfirmPasswordVisible;
              });
            },
            icon: isConfirmPasswordVisible
                ? Icon(CupertinoIcons.eye_slash,
                    color: AppColors.lightGreyHintText, size: Dimens.eighteen)
                : Icon(CupertinoIcons.eye,
                    color: AppColors.lightGreyHintText, size: Dimens.eighteen)),
      ),
    );
  }

  validateInput() {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      ApiCall.forgotApi(
          widget.phoneNumber!, passwordController.text, this, context);
    }
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
    Utility.successMessage(data['message'], context);

    Navigator.pushReplacement(context,
        PageTransition(type: PageTransitionType.fade, child: LoginView()));
  }

  @override
  void onTokenExpired() {}
}
