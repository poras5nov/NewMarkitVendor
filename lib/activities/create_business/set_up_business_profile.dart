import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_vendor_app/activities/create_business/document_page.dart';
import 'package:market_vendor_app/activities/create_business/model/service_list.dart';
import 'package:market_vendor_app/activities/create_business/set_up_contact.dart';
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
import 'model/business_model.dart';

class SetUpBusinessProfile extends StatefulWidget {
  @override
  _SetUpBusinessProfileState createState() => _SetUpBusinessProfileState();
}

class _SetUpBusinessProfileState extends State<SetUpBusinessProfile>
    implements ApiInterface {
  String whichApiCall = "service_list";
  bool isLoading = false;
  TextEditingController businessNameController = TextEditingController();
  BusinessModel model = BusinessModel();
  List<String> imageList = [];
  List<String> imageListAws = [];
  int val = 1;
  List<Retail> retailerList = [];
  List<Services> serviceProviderList = [];
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  var token = "";

  @override
  void initState() {
    super.initState();
    getToken();
    ApiCall.getBusinessList(this, context);
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
                child: Form(
                  key: formkey,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
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
                      // ),Documen
                      Dimens.boxHeight15,
                      Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('setUpStoreInformation'),
                        style: Styles.loginPageTitleBlack,
                      ),
                      Dimens.boxHeight15,
                      Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('fillBusinessInfo'),
                        style: Styles.loginPageSubTitleGrey,
                      ),
                      Dimens.boxHeight20,
                      InkWell(
                        onTap: () {
                          if (imageList.length == 7) {
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
                      imageList.length == 0
                          ? Container()
                          : const SizedBox(
                              height: 20,
                            ),
                      imageList.length == 0
                          ? Container()
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              child: Wrap(
                                children: List.generate(
                                  imageList.length,
                                  (index) {
                                    return Container(
                                        width: 100,
                                        height: 100,
                                        alignment: Alignment.center,
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              width: 100,
                                              height: 100,
                                              alignment: Alignment.center,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: Image.file(
                                                  File(imageList[index]),
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.fill,
                                                  width: 80,
                                                  height: 80,
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
                                                    imageList.removeAt(index);
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

                      Dimens.boxHeight20,

                      businessTextFormFiled(),
                      Dimens.boxHeight20,
                      Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('businessType'),
                        style: Styles.lightGreyHint,
                      ),
                      Dimens.boxHeight5,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: val,
                                activeColor: AppColors.primaryColor,
                                onChanged: (v) {
                                  setState(() {
                                    val = int.parse(v.toString());
                                  });
                                },
                              ),
                              Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('retailer'),
                                style: Styles.boldBlack12,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 2,
                                activeColor: AppColors.primaryColor,
                                groupValue: val,
                                onChanged: (v) {
                                  setState(() {
                                    val = int.parse(v.toString());
                                  });
                                },
                              ),
                              Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('serviceProvider'),
                                style: Styles.boldBlack12,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 3,
                                activeColor: AppColors.primaryColor,
                                groupValue: val,
                                onChanged: (v) {
                                  setState(() {
                                    val = int.parse(v.toString());
                                  });
                                },
                              ),
                              Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('both'),
                                style: Styles.boldBlack12,
                              )
                            ],
                          ),
                        ],
                      ),
                      val == 3
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Dimens.boxHeight10,
                                chooseCategoryRetailerTextFormFiled(),
                                Dimens.boxHeight10,
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: [
                                    for (int i = 0;
                                        i < retailerList.length;
                                        i++)
                                      retailerList[i].isSelected
                                          ? Container(
                                              margin: const EdgeInsets.all(5),
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: AppColors
                                                      .lightBlueColor2),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    retailerList[i].name!,
                                                    style: Styles.whiteLight14,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      retailerList[i]
                                                          .isSelected = false;
                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                        Icons.close,
                                                        size: 24,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container()
                                  ],
                                ),
                                Dimens.boxHeight20,
                                chooseCategoryServiceTextFormFiled(),
                                Dimens.boxHeight10,
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: [
                                    for (int i = 0;
                                        i < serviceProviderList.length;
                                        i++)
                                      serviceProviderList[i].isSelected
                                          ? Container(
                                              margin: const EdgeInsets.all(5),
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: AppColors
                                                      .lightBlueColor2),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    serviceProviderList[i]
                                                        .name!,
                                                    style: Styles.whiteLight14,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      serviceProviderList[i]
                                                          .isSelected = false;
                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                        Icons.close,
                                                        size: 24,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container()
                                  ],
                                ),
                              ],
                            )
                          : val == 2
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Dimens.boxHeight10,
                                    chooseCategoryServiceTextFormFiled(),
                                    Dimens.boxHeight10,
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      children: [
                                        for (int i = 0;
                                            i < serviceProviderList.length;
                                            i++)
                                          serviceProviderList[i].isSelected
                                              ? Container(
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: AppColors
                                                          .lightBlueColor2),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        serviceProviderList[i]
                                                            .name!,
                                                        style:
                                                            Styles.whiteLight14,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          serviceProviderList[i]
                                                                  .isSelected =
                                                              false;
                                                          setState(() {});
                                                        },
                                                        child: const Icon(
                                                            Icons.close,
                                                            size: 24,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : Container()
                                      ],
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Dimens.boxHeight10,
                                    chooseCategoryRetailerTextFormFiled(),
                                    Dimens.boxHeight10,
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      children: [
                                        for (int i = 0;
                                            i < retailerList.length;
                                            i++)
                                          retailerList[i].isSelected
                                              ? Container(
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: AppColors
                                                          .lightBlueColor2),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        retailerList[i].name!,
                                                        style:
                                                            Styles.whiteLight14,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          retailerList[i]
                                                                  .isSelected =
                                                              false;
                                                          setState(() {});
                                                        },
                                                        child: const Icon(
                                                            Icons.close,
                                                            size: 24,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : Container()
                                      ],
                                    ),
                                  ],
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
                ),
              ))),
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

  chooseCategoryRetailerTextFormFiled() {
    return TextFormField(
      readOnly: true,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      onTap: () {
        retailerBottomSheet(context);
      },
      decoration: InputDecoration(
          labelText: NewMarkitVendorLocalizations.of(context)!
              .find('chooseCategoryForRetails'),
          labelStyle: Styles.lightGrey14,
          hintText: NewMarkitVendorLocalizations.of(context)!
              .find('chooseBusinessTypeServices'),
          hintStyle: Styles.lightGrey14,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.lightGreyHintText,
          )),
    );
  }

  chooseCategoryServiceTextFormFiled() {
    return TextFormField(
      readOnly: true,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      onTap: () {
        serviceBottomSheet(context);
      },
      decoration: InputDecoration(
          labelText: NewMarkitVendorLocalizations.of(context)!
              .find('chooseCategoryForServices'),
          labelStyle: Styles.lightGrey14,
          hintText: NewMarkitVendorLocalizations.of(context)!
              .find('chooseServiceTypeServices'),
          hintStyle: Styles.lightGrey14,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.lightGreyHintText,
          )),
    );
  }

  @override
  void onFailure(message) {
    print(message);
    if (whichApiCall == "upload_image") {
      Navigator.pop(context);

      imageList.removeLast();
    }
    setState(() {});
  }

  @override
  void onSuccess(data) {
    if (whichApiCall == "service_list") {
      retailerList = ServiceListModel.fromJson(data).retail!;
      serviceProviderList = ServiceListModel.fromJson(data).services!;
    } else {
      Navigator.pop(context);
      imageListAws.add(data['url']);
    }
  }

  @override
  void onTokenExpired() {}

  void retailerBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              color: Colors.white54,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    color: AppColors.primaryColor,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('retailer'),
                            style: Styles.boldWhite16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            changeState();

                            Navigator.pop(context);
                          },
                          child: Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('done'),
                            style: Styles.boldWhite14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[400],
                    width: MediaQuery.of(context).size.width,
                  ),
                  Expanded(
                      flex: 1,
                      child: ListView.builder(
                          itemCount: retailerList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (retailerList[index].isSelected) {
                                  retailerList[index].isSelected = false;
                                } else {
                                  retailerList[index].isSelected = true;
                                }
                                setState(() {});
                              },
                              child: Container(
                                color: Colors.grey.withAlpha(2),
                                padding: const EdgeInsets.all(16),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (retailerList[index].isSelected) {
                                          retailerList[index].isSelected =
                                              false;
                                        } else {
                                          retailerList[index].isSelected = true;
                                        }
                                        setState(() {});
                                      },
                                      child: Text(
                                        retailerList[index].name!,
                                        style: Styles.boldBlack16,
                                      ),
                                    ),
                                    const Spacer(),
                                    retailerList[index].isSelected == false
                                        ? Container()
                                        : const Icon(
                                            Icons.check_circle_rounded,
                                            size: 25,
                                            color: AppColors.redColor,
                                          )
                                  ],
                                ),
                              ),
                            );
                          }))
                ],
              ),
            );
          });
        });
  }

  changeState() {
    setState(() {});
  }

  void serviceBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              color: Colors.white54,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    color: AppColors.primaryColor,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('serviceProvider'),
                            style: Styles.boldWhite16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            changeState();

                            Navigator.pop(context);
                          },
                          child: Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('done'),
                            style: Styles.boldWhite14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[400],
                    width: MediaQuery.of(context).size.width,
                  ),
                  Expanded(
                      flex: 1,
                      child: ListView.builder(
                          itemCount: serviceProviderList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (serviceProviderList[index].isSelected) {
                                  serviceProviderList[index].isSelected = false;
                                } else {
                                  serviceProviderList[index].isSelected = true;
                                }
                                setState(() {});
                              },
                              child: Container(
                                color: Colors.grey.withAlpha(2),
                                padding: const EdgeInsets.all(16),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (serviceProviderList[index]
                                            .isSelected) {
                                          serviceProviderList[index]
                                              .isSelected = false;
                                        } else {
                                          serviceProviderList[index]
                                              .isSelected = true;
                                        }
                                        setState(() {});
                                      },
                                      child: Text(
                                        serviceProviderList[index].name!,
                                        style: Styles.boldBlack16,
                                      ),
                                    ),
                                    const Spacer(),
                                    serviceProviderList[index].isSelected ==
                                            false
                                        ? Container()
                                        : const Icon(
                                            Icons.check_circle_rounded,
                                            size: 25,
                                            color: AppColors.redColor,
                                          )
                                  ],
                                ),
                              ),
                            );
                          }))
                ],
              ),
            );
          });
        });
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
        imageList.add(croppedFile.path);
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
      if (imageList.isEmpty) {
        Utility.errorMessage(
            NewMarkitVendorLocalizations.of(context)!.find('businessImage'),
            context);
      } else if (val == 3) {
        bool isRetailer = false;
        bool isService = false;
        for (int i = 0; i < retailerList.length; i++) {
          if (retailerList[i].isSelected == true) {
            print(true);
            isRetailer = true;
            break;
          }
        }
        for (int i = 0; i < serviceProviderList.length; i++) {
          if (serviceProviderList[i].isSelected == true) {
            isService = true;
            break;
          }
        }
        if (isRetailer == false) {
          Utility.errorMessage(
              NewMarkitVendorLocalizations.of(context)!.find('selectRetailer'),
              context);
        } else if (isService == false) {
          Utility.errorMessage(
              NewMarkitVendorLocalizations.of(context)!.find('selectService'),
              context);
        } else {
          callNextPage();
        }
      } else if (val == 2) {
        bool isService = false;
        for (int i = 0; i < serviceProviderList.length; i++) {
          if (serviceProviderList[i].isSelected == true) {
            isService = true;
            break;
          }
        }
        if (isService == false) {
          Utility.errorMessage(
              NewMarkitVendorLocalizations.of(context)!.find('selectService'),
              context);
        } else {
          callNextPage();
        }
      } else if (val == 1) {
        bool isRetailer = false;
        for (int i = 0; i < retailerList.length; i++) {
          if (retailerList[i].isSelected == true) {
            isRetailer = true;
            break;
          }
        }
        if (isRetailer == false) {
          Utility.errorMessage(
              NewMarkitVendorLocalizations.of(context)!.find('selectRetailer'),
              context);
        } else {
          callNextPage();
        }
      }
    }
  }

  callNextPage() {
    addDataIntoModel();
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade, child: SetUpContact(model: model)));
  }

  addDataIntoModel() {
    model.name = businessNameController.text;
    model.type = val;
    if (val == 2) {
      for (int i = 0; i < retailerList.length; i++) {
        if (retailerList[i].isSelected) {
          if (model.categoryId != null) {
            model.categoryId =
                model.categoryId! + "," + retailerList[i].id.toString();
          } else {
            model.categoryId = retailerList[i].id.toString();
          }
        }
      }
      for (int i = 0; i < serviceProviderList.length; i++) {
        if (serviceProviderList[i].isSelected) {
          if (model.categoryId != null) {
            model.categoryId = model.categoryId.toString() +
                "," +
                serviceProviderList[i].id.toString();
          } else {
            model.categoryId = serviceProviderList[i].id.toString();
          }
        }
      }
    } else if (val == 2) {
      for (int i = 0; i < serviceProviderList.length; i++) {
        if (serviceProviderList[i].isSelected) {
          if (model.categoryId != null) {
            model.categoryId = model.categoryId.toString() +
                "," +
                serviceProviderList[i].id.toString();
          } else {
            model.categoryId = serviceProviderList[i].id.toString();
          }
        }
      }
    } else {
      for (int i = 0; i < retailerList.length; i++) {
        if (retailerList[i].isSelected) {
          if (model.categoryId != null) {
            model.categoryId = model.categoryId.toString() +
                "," +
                retailerList[i].id.toString();
          } else {
            model.categoryId = retailerList[i].id.toString();
          }
        }
      }
    }
    for (int i = 0; i < imageListAws.length; i++) {
      if (model.storeImages != null) {
        model.storeImages =
            model.storeImages.toString() + "," + imageListAws[i];
      } else {
        model.storeImages = imageListAws[i];
      }
    }
  }
}
