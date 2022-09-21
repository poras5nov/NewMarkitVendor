import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../apiservice/api_call.dart';
import '../../apiservice/api_interface.dart';
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
import 'model/business_model.dart';

class SignatureDocument extends StatefulWidget {
  BusinessModel model;
  SignatureDocument({Key? key, required this.model}) : super(key: key);
  @override
  _SignatureDocumentState createState() => _SignatureDocumentState();
}

class _SignatureDocumentState extends State<SignatureDocument>
    implements ApiInterface {
  bool isLoader = false;

  String _imagePath = "";
  String _imageDupilcatePath = "";

  int speed = 0;
  Color c = AppColors.lightBlueColor2;
  var token;
  bool isUpload = false;

  @override
  void initState() {
    super.initState();
    getToken();

    if (widget.model.signatureImage != null) {
      _imagePath = widget.model.signatureImage!;
      _imageDupilcatePath = widget.model.signatureDuplicateChequeImage!;
      if (_imagePath != "") {
        isUpload = true;
      }
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
          body: SafeArea(
              top: true,
              bottom: true,
              child: Padding(
                padding: Dimens.edgeInsets20,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
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
                          .find('uploadDocuments'),
                      style: Styles.loginPageTitleBlack,
                    ),
                    Dimens.boxHeight20,
                    isUpload
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: 140,
                            alignment: Alignment.center,
                            child: Stack(
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: _imageDupilcatePath,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 140.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200.0,
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      child: const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColors.primaryColor)),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                    ),
                                    child: const Icon(
                                      Icons.error,
                                      color: Colors.black,
                                      size: 60,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 140,
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isUpload = false;
                                        _imagePath = "";
                                        _imageDupilcatePath = "";

                                        c = AppColors.lightBlueColor2;
                                        speed = 0;
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
                            ))
                        : InkWell(
                            onTap: () {
                              getUploadBottomSheet(context);
                            },
                            child: AnimatedContainer(
                              duration: Duration(seconds: speed),
                              width: MediaQuery.of(context).size.width,
                              height: 140,
                              decoration: BoxDecoration(
                                  color: c,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    AssetConstants.upload,
                                    width: Dimens.thirty,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    NewMarkitVendorLocalizations.of(context)!
                                        .find('uploadYourCertificate'),
                                    style: Styles.lightWhite14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                    Dimens.boxHeight10,
                    Text(
                      NewMarkitVendorLocalizations.of(context)!
                          .find('uploadDocumentMsg'),
                      style: Styles.grey12Regular,
                    ),
                    Dimens.boxHeight30,
                    FormSubmitWidget(
                      opacity: 1,
                      disableColor: AppColors.primaryColor,
                      padding: Dimens.edgeInsets0,
                      text: NewMarkitVendorLocalizations.of(context)!
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
              ))),
    );
  }

  validateInput() {
    if (isUpload) {
      widget.model.signatureImage = _imagePath;
      widget.model.signatureDuplicateChequeImage = _imageDupilcatePath;
      Navigator.pop(context, widget.model);
    } else {
      Utility.errorMessage(
          NewMarkitVendorLocalizations.of(context)!.find('uploadImage'),
          context);
    }
  }

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
        // _imagePath = croppedFile.path;
        setState(() {
          isLoader = true;
        });
        Utility.dialogLoader(context);

        ApiCall.uploadBusinessImage(croppedFile.path, this, context, token);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onFailure(message) {
    Utility.errorMessage(message, context);
    Navigator.pop(context);
  }

  @override
  void onSuccess(data) {
    speed = 2;
    c = AppColors.darkBlueColor;
    Navigator.pop(context);
    _imagePath = data['url'];
    _imageDupilcatePath = data['showImageUrl'];

    hundler();
  }

  hundler() async {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        isUpload = true;
      });
    });
  }

  @override
  void onTokenExpired() {}
}
