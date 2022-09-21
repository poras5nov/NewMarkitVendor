import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_vendor_app/activities/edit_profile/model/business_other_details_model.dart';

import 'package:market_vendor_app/apiservice/api_call.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/asset_constants.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../../utils/utility.dart';
import '../../widgets/cupertino_viewer.dart';
import '../../widgets/form_submit_widget.dart';
import '../../widgets/material_viewer.dart';
import '../home_page/model/profile_model.dart';

class EditBusinessProfile extends StatefulWidget {
  @override
  _EditBusinessProfileState createState() => _EditBusinessProfileState();
}

class _EditBusinessProfileState extends State<EditBusinessProfile>
    implements ApiInterface {
  String whichApiCall = "upload_image";
  bool isLoading = false;
  TextEditingController businessNameController = TextEditingController();
  List<String> imageListAws = [];

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  var token = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController webSiteController = TextEditingController();
  List<TextEditingController> controller = List.empty(growable: true);
  bool isChecked = false;

  TextEditingController sharedController = TextEditingController(text: "0");
  TextEditingController freeController = TextEditingController(text: "0");
  var profileData;
  ProfileModel model = ProfileModel();
  bool isLoader = false;

  @override
  void initState() {
    super.initState();
    // controller.add(TextEditingController(text: ""));
    SharedPref.getProfileData().then((value) {
      profileData = json.decode(value);
      model = ProfileModel.fromJson(profileData);
      setData();
      setState(() {});
    });
    getToken();
  }

  setData() {
    if (model.data!.businesses!.storeImages != "null") {
      if (model.data!.businesses!.storeImages!.contains(",")) {
        for (int i = 0;
            i < model.data!.businesses!.storeImages!.split(",").length;
            i++) {
          imageListAws.add(model.data!.businesses!.storeImages!.split(",")[i]);
        }
      } else {
        imageListAws.add(model.data!.businesses!.storeImages!);
      }
    }

    businessNameController.text = model.data!.businesses!.name!;
    emailController.text = model.data!.businesses!.bussinessEmail!;
    webSiteController.text = model.data!.businesses!.website == "null"
        ? ""
        : model.data!.businesses!.website!;
    sharedController.text = model.data!.businesses!.sharedDelivery!;
    freeController.text = model.data!.businesses!.freeDelivery!;
    if (model.data!.businesses!.sharedDelivery == "0" &&
        model.data!.businesses!.freeDelivery == "0") {
      isChecked = true;
    }
    if (model.data!.businesses!.phone!.contains(",")) {
      for (int i = 0;
          i < model.data!.businesses!.phone!.split(",").length;
          i++) {
        controller.add(TextEditingController(
            text: model.data!.businesses!.phone!.split(",")[i]));
      }
    } else {
      controller
          .add(TextEditingController(text: model.data!.businesses!.phone!));
    }
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
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
                  top: true,
                  bottom: true,
                  child: Padding(
                    padding: Dimens.edgeInsets16,
                    child: Form(
                      key: formkey,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          Container(
                            height: 50,
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(
                                      Icons.arrow_back_rounded,
                                      color: AppColors.blackColor,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  NewMarkitVendorLocalizations.of(context)!
                                      .find('businessInformations'),
                                  style: Styles.boldBlack16,
                                ),
                              ],
                            ),
                          ),
                          Dimens.boxHeight15,
                          InkWell(
                            onTap: () {
                              if (imageListAws.length == 7) {
                              } else {
                                getUploadBottomSheet(context);
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 160,
                              decoration: const BoxDecoration(
                                  color: AppColors.darkBlueColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    AssetConstants.camera,
                                    width: Dimens.thirty,
                                    color: Colors.white,
                                  ),
                                  Dimens.boxHeight10,
                                  Text(
                                    NewMarkitVendorLocalizations.of(context)!
                                        .find('uploadStorePhotos'),
                                    style: Styles.boldWhite14,
                                  ),
                                  Dimens.boxHeight5,
                                  Text(
                                    NewMarkitVendorLocalizations.of(context)!
                                        .find('youCanUploadUpTo5Photos'),
                                    style: Styles.whiteLight12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          imageListAws.length == 0
                              ? Container()
                              : const SizedBox(
                                  height: 20,
                                ),
                          imageListAws.length == 0
                              ? Container()
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Wrap(
                                    children: List.generate(
                                      imageListAws.length,
                                      (index) {
                                        return Container(
                                            width: 100,
                                            height: 100,
                                            alignment: Alignment.center,
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.all(5),
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        imageListAws[index],
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      child: Container(
                                                        width: 100,
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      width: 100,
                                                      height: 100,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                        width: 30,
                                                        height: 30,
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
                                                      alignment:
                                                          Alignment.center,
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                      child: const Icon(
                                                          Icons.error,
                                                          color: Colors.black,
                                                          size: 30),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 100,
                                                  height: 100,
                                                  alignment: Alignment.topRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        imageListAws
                                                            .removeAt(index);

                                                        setState(() {});
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.cancel,
                                                      color: AppColors
                                                          .primaryColor,
                                                      size: 30,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ));
                                      },
                                    ),
                                  )),
                          Dimens.boxHeight20,
                          businessTextFormFiled(),
                          Dimens.boxHeight20,
                          Row(
                            children: [
                              Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('businessContact'),
                                style: Styles.lightGrey14,
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  controller
                                      .add(TextEditingController(text: ""));
                                  setState(() {});
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      color: AppColors.primaryColor,
                                    ),
                                    Text(
                                      NewMarkitVendorLocalizations.of(context)!
                                          .find('addMore'),
                                      style: Styles.redMedium14,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Wrap(
                            children: [
                              for (int i = 0; i < controller.length; i++)
                                setUpPhoneNumber(controller[i])
                            ],
                          ),
                          Dimens.boxHeight20,
                          emailTextFormFiled(),
                          Dimens.boxHeight20,
                          webSiteTextFormFiled(),
                          Dimens.boxHeight20,
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('sharedDelivery'),
                            style: Styles.lightBlue14,
                          ),
                          Dimens.boxHeight10,
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('minimumOrderAmountSharedDeliveryDes'),
                            style: Styles.loginPageSubTitleGrey,
                          ),
                          sharedTextFormFiled(),
                          Dimens.boxHeight20,
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('freeDelivery'),
                            style: Styles.lightBlue14,
                          ),
                          Dimens.boxHeight10,
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('minimumOrderAmountFreeDeliveryDes'),
                            style: Styles.loginPageSubTitleGrey,
                          ),
                          freeFormFiled(),
                          Dimens.boxHeight20,
                          Row(children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (v) {
                                isChecked = v!;
                                setState(() {
                                  sharedController.text = "0";
                                  freeController.text = "0";
                                });
                              },
                              activeColor: AppColors.primaryColor,
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('weWillNotShareDeliveryCharges'),
                                style: Styles.lightBlue14,
                                maxLines: 2,
                              ),
                            ),
                          ]),
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
                                  opacity: 1,
                                  disableColor: AppColors.primaryColor,
                                  padding: Dimens.edgeInsets0,
                                  text:
                                      NewMarkitVendorLocalizations.of(context)!
                                          .find('continueLabel'),
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
                  )),
            ],
          )),
    );
  }

  businessTextFormFiled() {
    return TextFormField(
      controller: businessNameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('businessName'),
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
            NewMarkitVendorLocalizations.of(context)!.find('businessEmailId'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  webSiteTextFormFiled() {
    return TextFormField(
      controller: webSiteController,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      // validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('businessWebsite'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  setUpPhoneNumber(TextEditingController i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox(
              height: Dimens.fiftyFive,
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
        Expanded(child: phoneTextFormFiled(i)),
      ],
    );
  }

  phoneTextFormFiled(TextEditingController i) {
    return SizedBox(
      height: Dimens.sixty,
      child: TextFormField(
        controller: i,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: AppColors.primaryColor,
        textAlignVertical: TextAlignVertical.center,
        style: Styles.formFieldTextStyle,
        keyboardType: TextInputType.number,
        validator: (v) => Utility.checkIfPhoneIsValid(v!, context),
        onChanged: (v) {
          setState(() {});
        },
        decoration: InputDecoration(
          labelText: (i.text.length == 0 || i.text.length == 10)
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

  sharedTextFormFiled() {
    return TextFormField(
      controller: sharedController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: const InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  freeFormFiled() {
    return TextFormField(
      controller: freeController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: const InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  @override
  void onFailure(message) {
    print(message);
    Utility.errorMessage(message, context);

    if (whichApiCall == "upload_image") {
      Navigator.pop(context);
    }
    setState(() {
      isLoader = false;
    });
  }

  @override
  void onSuccess(data) {
    if (whichApiCall == "upload_image") {
      Navigator.pop(context);

      imageListAws.add(data['url']);
    } else {
      print(data);
      var d = jsonEncode(data);
      SharedPref.saveProfileData(d);
      Utility.successMessage(data['message'], context);
    }
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
        cropStyle: CropStyle.rectangle,
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
        setState(() {});
        Utility.dialogLoader(context);

        whichApiCall = "upload_image";
        ApiCall.newploadBusinessImage(croppedFile.path, this, context, token);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  validateInput() {
    if (formkey.currentState!.validate()) {
      if (imageListAws.isEmpty) {
        Utility.errorMessage(
            NewMarkitVendorLocalizations.of(context)!.find('businessImage'),
            context);
      } else {
        BusinessOtherDetailsModel businessModel = BusinessOtherDetailsModel();
        businessModel.businessId = model.data!.businesses!.id!;
        businessModel.name = businessNameController.text;
        businessModel.bussinessEmail = emailController.text;
        businessModel.website = webSiteController.text;
        businessModel.sharedDelivery = sharedController.text;
        businessModel.freeDelivery = freeController.text;
        for (int i = 0; i < imageListAws.length; i++) {
          if (businessModel.storeImages != null) {
            businessModel.storeImages =
                businessModel.storeImages! + "," + imageListAws[i];
          } else {
            businessModel.storeImages = imageListAws[i];
          }
        }
        for (int i = 0; i < controller.length; i++) {
          if (businessModel.phone != null) {
            businessModel.phone =
                businessModel.phone! + "," + controller[i].text;
          } else {
            businessModel.phone = controller[i].text;
          }
        }
        whichApiCall = "businessUpdate";
        setState(() {
          isLoader = true;
        });
        ApiCall.businessUpdate(businessModel, token, this, context);
      }
    }
  }
}
