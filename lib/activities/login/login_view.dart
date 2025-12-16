import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:market_vendor_app/activities/forgot_password/forgot_password_view.dart';
import 'package:market_vendor_app/activities/login_with_otp/login_with_otp_view.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/apiservice/key_string.dart';
import 'package:market_vendor_app/utils/new_market_vendor_localizations.dart';
import 'package:market_vendor_app/utils/notification_receiver.dart';
import 'package:market_vendor_app/utils/utility.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../apiservice/api_call.dart';
import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/asset_constants.dart';
import '../../utils/notification_show.dart';
import '../../utils/shared_preferences.dart';
import '../../utils/strings/app_constants.dart';
import '../../widgets/form_submit_widget.dart';
import '../build_your_profile/build_your_profile_view.dart';
import '../create_business/set_up_business_profile.dart';
import '../verify_otp/login_with_otp_view.dart';
import '../../utils/globals.dart' as globals;
import 'package:http/http.dart' as http;

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() {
    return _LoginViewScreen();
  }
}

class _LoginViewScreen extends State<LoginView>
    implements ApiInterface, NotificationInterface {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  bool isLoader = false;
  bool isPasswordVisible = true;
  // LatLng? currentPostion;
  String version = "";
  String whichApiCall = "login";
  bool isSocialLoader = false;

  GlobalKey<FormState> formkey1 = GlobalKey<FormState>();
  TextEditingController phoneController1 = TextEditingController(text: "");
  TextEditingController emailontroller = TextEditingController(text: "");
  TextEditingController nameController = TextEditingController(text: "");

  String email = "";
  String name = "";
  String socialToken = "";
  String type = "";

  //---------Facebook variable-----------------
  final fb = FacebookLogin();

//-------------Google variable----------------
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    NotificationShow.initPlatformState(this);
    Utility.facebookEvent("login_screen");

    versionName();
    // _getUserLocation();
  }

  versionName() async {
    await PackageInfo.fromPlatform().then((value) {
      version = value.version;
      print(version);
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
                        // child: Text(
                        //     NewMarkitVendorLocalizations.of(context)!
                        //         .find('skip'),
                        //     textAlign: TextAlign.start,
                        //     style: Styles.boldBlack16),
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
                                FocusScope.of(context).unfocus();
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              facebookLogin();
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              child: Image.asset(AssetConstants.facebook),
                            ),
                          ),
                          if (Platform.isIOS)
                            Container(
                              width: 60,
                              height: 60,
                              child: SignInWithAppleButton(
                                borderRadius: BorderRadius.circular(30),
                                onPressed: () async {
                                  final credential = await SignInWithApple
                                      .getAppleIDCredential(
                                    scopes: [
                                      AppleIDAuthorizationScopes.email,
                                      AppleIDAuthorizationScopes.fullName,
                                    ],
                                  );
                                  whichApiCall = "social";
                                  type = "apple";
                                  socialToken = credential.identityToken!;
                                  if (credential.givenName != "") {
                                    name = credential.givenName!;
                                  }
                                  if (credential.email != "") {
                                    email = credential.email!;
                                  }

                                  ApiCall.checkUser(
                                      type,
                                      credential.identityToken!,
                                      "vendor",
                                      this,
                                      context);
                                  print(credential);

                                  // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                                  // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                                },
                              ),
                            ),
                          GestureDetector(
                            onTap: () {
                              signup(context);
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              child: Image.asset(AssetConstants.google),
                            ),
                          ),
                        ],
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
      whichApiCall = "login";
      setState(() {
        isLoader = true;
      });
      Utility.facebookEventWithParametter(
          "login_screen", {'type': 'Login with password'});

      ApiCall.loginWithPasswordApi(phoneController.text,
          passwordController.text, version, this, context);
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

  phoneTextFormFiled1() {
    return SizedBox(
      height: Dimens.sixty,
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: phoneController1,
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

  emailTextFormFiled() {
    emailontroller.text = email;
    return TextFormField(
      controller: emailontroller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (v) => Utility.checkEmailValid(v!, context),
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('emailAddress'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
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

  nameTextFormFiled() {
    nameController.text = name;
    return TextFormField(
      controller: nameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('name'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  @override
  void onFailure(message) {
    if (whichApiCall == "login") {
      Utility.errorMessage(message, context);
    } else {
      whichApiCall = "signUp";
      _showDialog();
    }

    print(message);
    setState(() {
      isLoader = false;
      isSocialLoader = false;
    });
  }

  @override
  void onSuccess(data) {
    setState(() {
      isLoader = false;
    });
    print(data);
    if (whichApiCall == "login") {
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
        SharedPref.setLoginStatus(KeyConstant.LOGINSTATUS, true);

        if (data['data']['businesses']['is_verified'].toString() == "Yes") {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/TabScreen', (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/VerifiedScreen', (Route<dynamic> route) => false);
        }
        print(globals.msg);
      }
    } else if (whichApiCall == "signUp") {
      isSocialLoader = false;
      Navigator.pop(context);
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
        SharedPref.setLoginStatus(KeyConstant.LOGINSTATUS, true);

        if (data['data']['businesses']['is_verified'].toString() == "Yes") {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/TabScreen', (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/VerifiedScreen', (Route<dynamic> route) => false);
        }
        print(globals.msg);
      }
    } else {}
  }

  @override
  void onTokenExpired() {}

  @override
  void onClick(id, type, requestId) {
    // TODO: implement onClick
  }

  @override
  void onMessageReceived(id, type) {
    // TODO: implement onMessageReceived
  }

  //----------------- google method--------------------------
  Future<void> signup(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User user = result.user!;
      print(user.displayName);
      name = user.displayName!;

      email = user.email!;
      setState(() {});
      whichApiCall = "social";
      type = "google";
      socialToken = googleSignInAuthentication.accessToken!;

      ApiCall.checkUser(type, socialToken, "vendor", this, context);
    }
  }

  //--------------------facebook method----------------------
  facebookLogin() async {
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

// Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:
        // Logged in

        // Send access token to server for validation and auth
        final FacebookAccessToken accessToken = res.accessToken!;
        print('Access token: ${accessToken.token}');

        // Get profile data
        final profile = await fb.getUserProfile();
        print('Hello, ${profile!.name!}! You ID: ${profile.userId}');

        // Get user profile image url
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        print('Your profile image: $imageUrl');

        // Get email (since we request email permission)
        final fbemail = await fb.getUserEmail();
        // But user can decline permission
        if (fbemail != null) {
          print('And your email is $fbemail');
          email = fbemail;
          setState(() {});
        }
        name = profile.name!;

        whichApiCall = "social";
        socialToken = accessToken.token;
        type = "facebook";
        ApiCall.checkUser(type, accessToken.token, "vendor", this, context);

        break;
      case FacebookLoginStatus.cancel:
        // User cancel log in
        break;
      case FacebookLoginStatus.error:
        // Log in failed
        print('Error while log in: ${res.error}');
        break;
    }
  }

  //----------------dialog for social signup--------------------
  _showDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                backgroundColor: Colors.white,
                content: Container(
                    child: Form(
                  key: formkey1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: Dimens.percentWidth(0.6),
                        height: Dimens.percentHeight(0.14),
                        child: SvgPicture.asset(
                          AssetConstants.loginLogo,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(
                          NewMarkitVendorLocalizations.of(context)!
                              .find('socialSignup'),
                          style: TextStyle(
                            fontFamily: AppConstants.appLightFontFamily,
                            fontSize: Dimens.sixTeen,
                            color: Colors.black,
                            height: 1.4,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                          )),
                      Dimens.boxHeight20,
                      nameTextFormFiled(),
                      Dimens.boxHeight20,
                      emailTextFormFiled(),
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
                          Expanded(child: phoneTextFormFiled1()),
                        ],
                      ),
                      Dimens.boxHeight20,
                      isSocialLoader
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
                                  .find('signUp'),
                              textStyle: Styles.buttonWhiteTextStyle,
                              startColor: AppColors.primaryColor,
                              endColor: AppColors.primaryColor,
                              iconColor: Colors.white,
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                if (formkey1.currentState!.validate()) {
                                  setState(() {
                                    isSocialLoader = true;
                                  });
                                  ApiCall.socialSignUpUser(
                                      type,
                                      socialToken,
                                      "vendor",
                                      emailontroller.text,
                                      phoneController1.text,
                                      nameController.text,
                                      this,
                                      context);
                                }
                                // validateInput();
                              },
                            ),
                      Dimens.boxHeight20,
                    ],
                  ),
                )),
              ));
        });
      },
    );
  }
}
