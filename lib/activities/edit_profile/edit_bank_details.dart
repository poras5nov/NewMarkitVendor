import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_vendor_app/activities/create_business/model/BankInfoModel.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';

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
import '../home_page/model/profile_model.dart';

class EditBankDetails extends StatefulWidget {
  ProfileModel? model;
  EditBankDetails({Key? key, required this.model}) : super(key: key);
  @override
  _EditBankDetailsState createState() => _EditBankDetailsState();
}

class _EditBankDetailsState extends State<EditBankDetails>
    implements ApiInterface {
  TextEditingController accountController = TextEditingController();
  TextEditingController checkController = TextEditingController();

  TextEditingController bankNameController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController holderNameController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String _imagePath = "";
  String _imageDupilcatePath = "";
  int speed = 0;
  Color c = AppColors.lightBlueColor2;
  var token;
  bool isUpload = false;
  bool isLoader = false;
  bool isClick = false;
  String whichApiCall = "";
  @override
  void initState() {
    super.initState();
    getToken();

    bankNameController.text = widget.model!.data!.businesses!.bankName!;

    ifscController.text = widget.model!.data!.businesses!.ifscCode!;

    accountController.text = widget.model!.data!.businesses!.bankAccount!;

    holderNameController.text =
        widget.model!.data!.businesses!.accountHolderName!;
    for (int i = 0; i < widget.model!.data!.documents!.length; i++) {
      if (widget.model!.data!.documents![i].name == "CANCELLED CHEQUE IMAGE") {
        _imagePath = widget.model!.data!.documents![i].image!;
        _imageDupilcatePath = widget.model!.data!.documents![i].image!;

        checkController.text = widget.model!.data!.documents![i].number!;
      }
    }

    if (_imagePath != "") {
      isUpload = true;
    }
  }

  showTransparentDialog(BuildContext context) async {
    showDialog(
        context: context,
        //It doesnt work: barrierColor: Colors.transparent,
        barrierColor: Color(0x00ffffff), //this works
        builder: (_) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        });
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        // if (bankNameController.text.isEmpty) {
        //   if (ifscController.text.isNotEmpty) {
        //     showTransparentDialog(context);
        //     whichApiCall = "getBankInfo";
        //     ApiCall.checkBankApi(ifscController.text, this, context);
        //   }
        // }
      },
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
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: formkey,
                      child: ListView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.zero,
                        children: <Widget>[
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
                                      "Bank Details",
                                      style: Styles.boldBlack16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Dimens.boxHeight20,
                          accountTextFormFiled(),
                          Dimens.boxHeight20,
                          ifscTextFormFiled(),
                          Dimens.boxHeight20,
                          bankTextFormFiled(),
                          Dimens.boxHeight20,
                          bankHolderNameFormFiled(),
                          Dimens.boxHeight20,
                          // checkNumberTextFormFiled(),
                          // Dimens.boxHeight20,
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('uploadCancelledCheque'),
                            style: Styles.lightBlue14,
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
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 140.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 200.0,
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            child:
                                                const CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            AppColors
                                                                .primaryColor)),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          alignment: Alignment.center,
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          AssetConstants.upload,
                                          width: Dimens.thirty,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          NewMarkitVendorLocalizations.of(
                                                  context)!
                                              .find('uploadCheque'),
                                          style: Styles.lightWhite14,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          Dimens.boxHeight30,
                          isClick
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

  checkNumberTextFormFiled() {
    return TextFormField(
      controller: checkController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('checkNumber'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  accountTextFormFiled() {
    return TextFormField(
      controller: accountController,
      obscureText: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('accountNumber'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  bankTextFormFiled() {
    return TextFormField(
      readOnly: true,
      controller: bankNameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('bankNameBranch'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  ifscTextFormFiled() {
    return TextFormField(
      controller: ifscController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onChanged: (v) {
        ifscController.text = v.toUpperCase();
        ifscController.selection = TextSelection.fromPosition(
            TextPosition(offset: ifscController.text.length));
        bankNameController.text = "";
        if (ifscController.text.length == 11) {
          whichApiCall = "getBankInfo";
          //showTransparentDialog(context);
          ApiCall.checkBankApi(v, this, context);
          setState(() {});
        }
      },
      onFieldSubmitted: (v) {},
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('IFSCCode'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  bankHolderNameFormFiled() {
    return TextFormField(
      controller: holderNameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('accountHolderName'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  validateInput() {
    if (formkey.currentState!.validate()) {
      if (isUpload) {
        // widget.model.bankAccount = accountController.text;
        // widget.model.bankName = bankNameController.text;
        // widget.model.ifscCode = ifscController.text;
        // widget.model.accountHolderName = holderNameController.text;
        // widget.model.cancelledChequeNumber = checkController.text;

        // widget.model.cancelledChequeImage = _imagePath;
        // widget.model.cancelledDuplicateChequeImage = _imageDupilcatePath;
        //
        //Navigator.pop(context, widget.model);
        setState(() {
          isClick = true;
        });
        whichApiCall = "edit_document";
        ApiCall.updateBankDetails(
            widget.model!.data!.businesses!.id.toString(),
            _imagePath,
            accountController.text.toString(),
            bankNameController.text.toString(),
            ifscController.text.toString(),
            holderNameController.text.toString(),
            token,
            this,
            context);
      } else {
        Utility.errorMessage(
            NewMarkitVendorLocalizations.of(context)!.find('uploadImage'),
            context);
      }
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
        whichApiCall = "upload";
        Utility.dialogLoader(context);
        ApiCall.uploadBusinessImage(croppedFile.path, this, context, token);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onFailure(message) {
    if (whichApiCall == "getBankInfo") {
      // Utility.errorMessage("Please enter valid IFSC code", context);
    } else if (whichApiCall == "upload") {
      Utility.errorMessage(message, context);
      Navigator.pop(context);
    }

    setState(() {
      isLoader = false;
      isClick = false;
    });
  }

  @override
  void onSuccess(data) {
    if (whichApiCall == "getBankInfo") {
      BankInfoModel model = BankInfoModel.fromJson(data);
      bankNameController.text = model.bRANCH!;
    } else if (whichApiCall == "upload") {
      speed = 2;
      c = AppColors.darkBlueColor;

      _imagePath = data['url'];
      _imageDupilcatePath = data['showImageUrl'];
      setState(() {
        isLoader = false;
      });

      hundler();
      Navigator.pop(context);
    } else {
      var d = jsonEncode(data);
      SharedPref.saveProfileData(d);
      Navigator.pop(context);
      setState(() {
        isLoader = false;
        isClick = false;
      });
    }
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
