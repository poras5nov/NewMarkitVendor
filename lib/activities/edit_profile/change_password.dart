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
import '../../utils/shared_preferences.dart';
import '../../utils/utility.dart';
import '../../widgets/form_submit_widget.dart';

class ChangePasswordView extends StatefulWidget {
  ChangePasswordView({Key? key}) : super(key: key);

  @override
  State<ChangePasswordView> createState() {
    return _ResetPasswordView();
  }
}

class _ResetPasswordView extends State<ChangePasswordView>
    implements ApiInterface {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController(text: "");

  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController confirmPasswordController =
      TextEditingController(text: "");

  bool isLoader = false;
  bool isOldPasswordVisible = true;

  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  var token = "";
  @override
  void initState() {
    super.initState();
    getToken();
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
    });
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
                          .find('changePassword'),
                      style: Styles.loginPageTitleBlack,
                    ),
                    Dimens.boxHeight15,
                    Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('youCanChangePassword'),
                        style: Styles.loginPageSubTitleGrey),
                    Dimens.boxHeight20,
                    oldPasswordTextFormFiled(),
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

  oldPasswordTextFormFiled() {
    return TextFormField(
      obscureText: isOldPasswordVisible,
      controller: oldPasswordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.text,
      validator: (v) => Utility.checkIfPasswordIsValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('oldPassword'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isOldPasswordVisible = !isOldPasswordVisible;
              });
            },
            icon: isOldPasswordVisible
                ? Icon(CupertinoIcons.eye_slash,
                    color: AppColors.lightGreyHintText, size: Dimens.eighteen)
                : Icon(CupertinoIcons.eye,
                    color: AppColors.lightGreyHintText, size: Dimens.eighteen)),
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
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.text,
      validator: (v) => Utility.checkIfPasswordIsValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('newPassword'),
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
      ApiCall.vendorUpdatePassword(
          passwordController.text, token, this, context);
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
    Navigator.pop(context);
    Utility.successMessage(data['message'], context);
  }

  @override
  void onTokenExpired() {}
}
