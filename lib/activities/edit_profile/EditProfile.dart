import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
import '../home_page/model/profile_model.dart';

class EditProfileView extends StatefulWidget {
  EditProfileView({Key? key}) : super(key: key);
  @override
  State<EditProfileView> createState() {
    return _EditProfileView();
  }
}

class _EditProfileView extends State<EditProfileView> implements ApiInterface {
  bool _value = false;
  int val = 1;
  bool isLoader = false;
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  String filePath = "";

  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController phoneController = TextEditingController(text: "");

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  var profileData;
  ProfileModel model = ProfileModel();
  var token;
  @override
  void initState() {
    super.initState();
    SharedPref.getProfileData().then((value) {
      profileData = json.decode(value);
      model = ProfileModel.fromJson(profileData);
      filePath = model.data!.profile == null ? "" : model.data!.profile!;
      nameController.text = model.data!.name!;
      emailController.text = model.data!.email!;
      if (model.data!.gender == "Male") {
        val = 1;
      } else if (model.data!.gender == "Female") {
        val = 2;
      } else {
        val = 3;
      }
      // phoneController.text = model.data!.phone!.replaceAll("+91", "");
      print(model.data!.documents!.length);

      setState(() {});
    });
    getToken();
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.topColor,
                    Colors.white,
                  ],
                )),
              ),
              SafeArea(
                child: Form(
                  key: formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(
                                      Icons.arrow_back,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    NewMarkitVendorLocalizations.of(context)!
                                        .find('editYourProfile'),
                                    style: Styles.boldBlack16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                                    child: filePath.contains("http")
                                        ? CachedNetworkImage(
                                            imageUrl: filePath,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: Dimens.eighty,
                                              height: Dimens.eighty,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                Container(
                                              width: Dimens.eighty,
                                              height: Dimens.eighty,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                child: const CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            AppColors
                                                                .primaryColor)),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              alignment: Alignment.center,
                                              height: Dimens.eight,
                                              width: Dimens.eight,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Icon(
                                                Icons.perm_identity,
                                                size: 40,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          )
                                        : filePath == ""
                                            ? Container(
                                                child: const Icon(
                                                  Icons.perm_identity,
                                                  size: 40,
                                                  color: AppColors.primaryColor,
                                                ),
                                              )
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Column(
                        //       children: [
                        //         SizedBox(
                        //           height: Dimens.fiftynne,
                        //           child: CountryCodePicker(
                        //             onChanged: (val) {},
                        //             countryList: const [
                        //               {
                        //                 'name': 'भारत',
                        //                 'code': 'IN',
                        //                 'dial_code': '+91',
                        //               },
                        //             ],
                        //             padding: Dimens.edgeInsets2,
                        //             // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        //             initialSelection: 'IN',
                        //             flagWidth: Dimens.twenty,
                        //             // optional. Shows only country name and flag
                        //             showCountryOnly: false,
                        //             // optional. Shows only country name and flag when popup is closed.
                        //             showOnlyCountryWhenClosed: false,
                        //             // optional. aligns the flag and the Text left
                        //             alignLeft: false,
                        //             textStyle: Styles.formFieldTextStyle,
                        //           ),
                        //         ),
                        //         Container(
                        //           height: 0.6,
                        //           width: Dimens.ninety,
                        //           color: AppColors.blackColor,
                        //         )
                        //       ],
                        //     ),
                        //     Dimens.boxWidth15,
                        //     Expanded(child: phoneTextFormFiled()),
                        //   ],
                        // ),
                        // Dimens.boxHeight20,
                        nameTextFormFiled(),
                        Dimens.boxHeight20,
                        emailTextFormFiled(),
                        // Dimens.boxHeight20,
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
                                    .find('update'),
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
            ],
          ),
        ),
      );

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

  validateInput() {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      ApiCall.vendorUpdate(
          nameController.text,
          emailController.text,
          model.data!.phone!,
          val == 1
              ? "Male"
              : val == 2
                  ? "Female"
                  : "Other",
          filePath.contains("http") ? "" : filePath,
          token,
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
    print(data);
    Utility.successMessage(data['message'], context);
    var d = jsonEncode(data);
    SharedPref.saveProfileData(d);

    setState(() {
      isLoader = false;
    });
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
