import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_vendor_app/apiservice/api_call.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';

import '../../apiservice/key_string.dart';
import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/asset_constants.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../../utils/shared_preferences.dart';
import '../../utils/utility.dart';
import '../../widgets/cupertino_viewer.dart';
import '../../widgets/form_submit_widget.dart';
import '../../widgets/material_viewer.dart';
import '../create_business/set_up_business_profile.dart';

class BuildYourProfileView extends StatefulWidget {
  var phone;

  BuildYourProfileView({Key? key, this.phone}) : super(key: key);
  @override
  State<BuildYourProfileView> createState() {
    return _BuildYourProfileView();
  }
}

class _BuildYourProfileView extends State<BuildYourProfileView>
    implements ApiInterface {
  bool _value = false;
  int val = 1;
  bool isLoader = false;
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  String filePath = "";

  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController confirmPasswordController =
      TextEditingController(text: "");

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String version = "";
  @override
  void initState() {
    super.initState();
    Utility.facebookEvent("register_screen");

    versionName();
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
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          // Container(
                          //   alignment: Alignment.centerLeft,
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       Navigator.pop(context);
                          //     },
                          //     child: Icon(
                          //       Icons.arrow_back_rounded,
                          //       color: AppColors.blackColor,
                          //       size: Dimens.twentyEight,
                          //     ),
                          //   ),
                          // ),
                          Dimens.boxHeight15,
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('buildYourProfile'),
                            style: Styles.loginPageTitleBlack,
                          ),
                          Dimens.boxHeight15,
                          Text(
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('fillInfo'),
                              style: Styles.loginPageSubTitleGrey),
                          Dimens.boxHeight30,
                          GestureDetector(
                            onTap: () {
                              getUploadBottomSheet(context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: Dimens.eighty,
                                  height: Dimens.eighty,
                                  child: DottedBorder(
                                    borderType: BorderType.Circle,
                                    strokeCap: StrokeCap.round,
                                    dashPattern: [6, 3, 6, 3],
                                    strokeWidth: 1,
                                    color: AppColors.lightGreyHintText,
                                    radius: Radius.circular(Dimens.fourtyEight),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: filePath == ""
                                          ? SvgPicture.asset(
                                              AssetConstants.camera)
                                          : CircleAvatar(
                                              backgroundImage:
                                                  FileImage(File(filePath)),
                                              radius: Dimens.eighty,
                                            ),
                                    ),
                                  ),
                                ),
                                Dimens.boxHeight10,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      NewMarkitVendorLocalizations.of(context)!
                                          .find('uploadPhoto'),
                                      style: Styles.loginPageSubTitleGrey,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Dimens.boxHeight20,
                          nameTextFormFiled(),
                          Dimens.boxHeight20,
                          emailTextFormFiled(),
                          Dimens.boxHeight20,
                          // Text(
                          //   NewMarkitVendorLocalizations.of(context)!
                          //       .find('gender'),
                          //   style: Styles.lightGreyHint,
                          // ),
                          // Dimens.boxHeight5,
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Row(
                          //       children: [
                          //         Radio(
                          //           value: 1,
                          //           groupValue: val,
                          //           activeColor: AppColors.primaryColor,
                          //           onChanged: (v) {
                          //             setState(() {
                          //               val = int.parse(v.toString());
                          //             });
                          //           },
                          //         ),
                          //         Text(
                          //           NewMarkitVendorLocalizations.of(context)!
                          //               .find('male'),
                          //           style: Styles.boldBlack14,
                          //         )
                          //       ],
                          //     ),
                          //     Dimens.boxWidth10,
                          //     Row(
                          //       children: [
                          //         Radio(
                          //           value: 2,
                          //           activeColor: AppColors.primaryColor,
                          //           groupValue: val,
                          //           onChanged: (v) {
                          //             setState(() {
                          //               val = int.parse(v.toString());
                          //             });
                          //           },
                          //         ),
                          //         Text(
                          //           NewMarkitVendorLocalizations.of(context)!
                          //               .find('female'),
                          //           style: Styles.boldBlack14,
                          //         )
                          //       ],
                          //     ),
                          //     Dimens.boxWidth10,
                          //     Row(
                          //       children: [
                          //         Radio(
                          //           value: 3,
                          //           activeColor: AppColors.primaryColor,
                          //           groupValue: val,
                          //           onChanged: (v) {
                          //             setState(() {
                          //               val = int.parse(v.toString());
                          //             });
                          //           },
                          //         ),
                          //         Text(
                          //           NewMarkitVendorLocalizations.of(context)!
                          //               .find('others'),
                          //           style: Styles.boldBlack14,
                          //         )
                          //       ],
                          //     ),
                          //   ],
                          // ),
                          passwordTextFormFiled(),
                          Dimens.boxHeight20,
                          confirmPasswordTextFormFiled(),
                          Dimens.boxHeight20,
                          Text(
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('buildScreenNote'),
                              textAlign: TextAlign.left,
                              style: Styles.grey12Regular),
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
                                  text:
                                      NewMarkitVendorLocalizations.of(context)!
                                          .find('register'),
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
                  ))),
        ),
      );

  nameTextFormFiled() {
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

  emailTextFormFiled() {
    return TextFormField(
      controller: emailController,
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
      validator: (v) => Utility.checkIfConfirmPasswordIsValid(
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
      ApiCall.createVendorRegister(
          widget.phone,
          nameController.text,
          emailController.text,
          passwordController.text,
          val == 1
              ? "Male"
              : val == 2
                  ? "Female"
                  : "Other",
          filePath,
          version,
          this,
          context);
    }
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

    SharedPref.saveLoginToken(data['token']);
    var d = jsonEncode(data['data']);
    SharedPref.saveProfileData(d);
    Utility.facebookEvent("register_vendor");
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
    }
  }

  @override
  void onTokenExpired() {}
  void getUploadBottomSheet(BuildContext context) async {
    final buttons = [
      {
        'buttonName':
            NewMarkitVendorLocalizations.of(context)!.find('openCamera'),
        'buttonIcon': Icons.camera_alt_outlined,
        'onTap': () {
          getImage(ImageSource.camera);
          Navigator.pop(context);
        },
        'isCancelButton': false,
      },
      {
        'buttonName':
            NewMarkitVendorLocalizations.of(context)!.find('openGallery'),
        'buttonIcon': CupertinoIcons.photo_on_rectangle,
        'onTap': () async {
          getImage(ImageSource.gallery);
          Navigator.pop(context);
        },
        'isCancelButton': false,
      },
    ];
    if (Platform.isIOS) {
      await showCupertinoModalPopup<dynamic>(
        context: context,
        builder: (context) => CupertinoViewer(
          buttons: buttons,
        ),
      );
    } else {
      await showModalBottomSheet<dynamic>(
        context: context,
        backgroundColor: Theme.of(context).canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        builder: (_) => MaterialViewer(
          buttons: buttons,
        ),
      );
    }
  }

  void getImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();

      var pickedFile = await picker.pickImage(source: source);

      var croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile!.path,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: AppColors.primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      debugPrint(croppedFile!.path);
      if (croppedFile.path.isNotEmpty) {
        filePath = croppedFile.path;
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
