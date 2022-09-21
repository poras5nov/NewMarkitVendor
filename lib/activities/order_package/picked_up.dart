import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_vendor_app/activities/login/login_view.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:page_transition/page_transition.dart';

import '../../apiservice/api_call.dart';
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

class PickedUpScreen extends StatefulWidget {
  var id;
  var name;
  var orderTypeId;
  var type;
  PickedUpScreen({Key? key, this.id, this.name, this.orderTypeId, this.type})
      : super(key: key);

  @override
  State<PickedUpScreen> createState() {
    return _PickedUpScreenState();
  }
}

class _PickedUpScreenState extends State<PickedUpScreen>
    implements ApiInterface {
  var token = "";
  TextEditingController orderStatusController = TextEditingController();
  bool isLoader = false;
  String whichApiCall = "upload_image";

  List<String> imageListAws = [];
  @override
  void initState() {
    super.initState();
    orderStatusController.text = widget.name!;
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
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
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
                            .find('orderStatus'),
                        style: Styles.loginPageTitleBlack,
                      ),
                      Dimens.boxHeight15,
                      Text(
                          NewMarkitVendorLocalizations.of(context)!
                              .find('pickedUpMsg'),
                          style: Styles.loginPageSubTitleGrey),
                      Dimens.boxHeight30,
                      orderStatusTextFormFiled(),
                      Dimens.boxHeight30,
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
                                    .find('uploadPhotos'),
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
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: imageListAws[index],
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    Container(
                                                  width: 100,
                                                  height: 100,
                                                  alignment: Alignment.center,
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
                                                  alignment: Alignment.center,
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: const Icon(Icons.error,
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
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.cancel,
                                                  color: AppColors.primaryColor,
                                                  size: 30,
                                                ),
                                              ),
                                            )
                                          ],
                                        ));
                                  },
                                ),
                              )),
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
          ],
        ),
      );

  orderStatusTextFormFiled() {
    return TextFormField(
      readOnly: true,
      controller: orderStatusController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.text,
      validator: (v) => Utility.checkIfPasswordIsValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('orderStatus'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  validateInput() {
    whichApiCall = "changeStatus";
    setState(() {
      isLoader = true;
    });
    String imageList = "";
    for (int i = 0; i < imageListAws.length; i++) {
      if (imageList == "") {
        imageList = imageListAws[i];
      } else {
        imageList = imageList + "," + imageListAws[i];
      }
    }
    if (widget.type == "new") {
      ApiCall.changeStatus(widget.orderTypeId, widget.id.toString(), "", "",
          imageList, token, this, context);
    } else {
      ApiCall.changeOrderStatus(widget.name, widget.id.toString(),
          widget.orderTypeId.toString(), "", imageList, token, this, context);
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
    if (whichApiCall == "upload_image") {
      Navigator.pop(context);
      imageListAws.add(data['url']);
    } else {
      Navigator.pop(context, true);
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
}
