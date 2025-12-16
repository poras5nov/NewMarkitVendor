import 'dart:io';
import 'dart:convert' show jsonDecode, json;

import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_vendor_app/activities/add_product/attribute.dart';
import 'package:market_vendor_app/activities/add_product/model/addproduct.dart';
import 'package:market_vendor_app/activities/add_product/model/attributes_model.dart';
import 'package:market_vendor_app/activities/add_product/model/brand_model.dart';
import 'package:market_vendor_app/activities/add_product/preview_Screen.dart';
import 'package:market_vendor_app/activities/add_product/specification.dart';
import 'package:market_vendor_app/activities/add_product/success_screen.dart';
import 'package:market_vendor_app/apiservice/api_call.dart';

import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

import '../../apiservice/url_string.dart';
import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import 'package:market_vendor_app/utils/new_market_vendor_localizations.dart';

import '../../utils/asset_constants.dart';
import '../../utils/strings/app_constants.dart';
import '../../utils/utility.dart';
import '../../widgets/cupertino_viewer.dart';
import '../../widgets/form_submit_widget.dart';
import '../../widgets/material_viewer.dart';
import '../home_page/model/profile_model.dart';
import 'model/hsn_model.dart';
import 'new_attribute.dart';

class ProductInformationsScreen extends StatefulWidget {
  AddProductModel? model;
  ProductInformationsScreen({Key? key, this.model}) : super(key: key);
  @override
  _ProductInformationsScreenState createState() =>
      _ProductInformationsScreenState();
}

class _ProductInformationsScreenState extends State<ProductInformationsScreen>
    implements ApiInterface {
  var token;
  Brand model = Brand();
  Attributes modelAttributes = Attributes();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController brandController = TextEditingController(text: "");
  TextEditingController productTitleController =
      TextEditingController(text: "");
  TextEditingController isWarrentyController = TextEditingController(text: "");
  TextEditingController hsnController = TextEditingController(text: "");
  TextEditingController hsnTypeController = TextEditingController(text: "");

  TextEditingController howMuchController = TextEditingController(text: "");
  TextEditingController howMuchRefundAbleController =
      TextEditingController(text: "");
  TextEditingController howMuchDaysWarrentyController =
      TextEditingController(text: "");

  TextEditingController estimatedController = TextEditingController(text: "");
  TextEditingController descriptionController = TextEditingController(text: "");
  TextEditingController billingController = TextEditingController(text: "");
  TextEditingController heightController = TextEditingController(text: "");
  TextEditingController lenghtController = TextEditingController(text: "");
  TextEditingController breadthController = TextEditingController(text: "");
  TextEditingController weightController = TextEditingController(text: "");
  TextEditingController deliveryHeavyController =
      TextEditingController(text: "");
  TextEditingController statusOfShipmentController =
      TextEditingController(text: "");
  TextEditingController maximumShipingCostController =
      TextEditingController(text: "");
  TextEditingController videoUrlController = TextEditingController(text: "");
  TextEditingController seoProductTitle = TextEditingController(text: "");
  TextEditingController seoMetaDescription = TextEditingController(text: "");
  TextEditingController targettedkeywords = TextEditingController(text: "");

  List<String> _items = [];

  List<String> imageList = [];
  List<bool> imageListType = [];

  List<String> imageListAws = [];
  var brandPostion;
  int val = 1;
  int value = 1;
  int hsnvalue = 1;
  int refund = 1;
  int cashOndelivery = 1;
  int warenty = 1;

  String whichApiCall = "";
  List<String> isWarentyTypeList = ["Days", "Months", "Years"];

  HsnModel hsnModel = HsnModel();

  AddProductModel addProductModel = AddProductModel();
  var tempProductModel;

  bool isLoader = false;
  Hsnata data = Hsnata();
  List<BData>? acData;
  List<BData>? sData;
  List<BData> allBData = [];

  String selectedValue = "Surface";
  List<String> ibillingModeList = ["Surface", "Express"];
  String selectedShipmentValue = "DTO";

  List<String> statusOfShipmentModeList = ["DTO", "RTO", 'Delivered'];
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
// Allows you to get a list of all the ItemTags

  @override
  void initState() {
    super.initState();
    addProductModel = widget.model!;
    if (addProductModel.variationsQuantity != null) {
      addProductModel.variationsQuantity!.clear();
      addProductModel.variationsQuantity = null;
      addProductModel.attribute_ids = "";
    }
    if (addProductModel.specifactions != null) {
      addProductModel.specifactions!.clear();
      addProductModel.specifactions = null;
      addProductModel.attribute_ids = "";
    }
    getData();
    getToken();
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
      ApiCall.brandList(token, this, context);
      hsnList(addProductModel.categoryId!, token);
    });
  }

  var profileData;

  ProfileModel pModel = ProfileModel();
  getData() {
    SharedPref.getProfileData().then((value) {
      profileData = json.decode(value);
      pModel = ProfileModel.fromJson(profileData);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
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
              bottom: false,
              child: Padding(
                padding: Dimens.edgeInsets20,
                child: Form(
                  key: formkey,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            // Text(
                            //     NewMarkitVendorLocalizations.of(context)!
                            //         .find('1/2 Steps'),
                            //     style: Styles.loginPageSubTitleGrey),
                          ],
                        ),
                        Dimens.boxHeight15,
                        Text(
                          NewMarkitVendorLocalizations.of(context)!
                              .find('product_information'),
                          style: Styles.loginPageTitleBlack,
                        ),
                        Dimens.boxHeight15,
                        Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('please_enter_procust_details'),
                            style: Styles.loginPageSubTitleGrey),
                        Dimens.boxHeight20,
                        Text(
                          NewMarkitVendorLocalizations.of(context)!
                              .find('general_information'),
                          style: Styles.lightBlue14,
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
                                      .find('uploadProductPhotos'),
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
                                                child: Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: imageListType[
                                                              index] ==
                                                          true
                                                      ? BoxDecoration(
                                                          border: Border.all(
                                                              width: 5,
                                                              color:
                                                                  Colors.green),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        )
                                                      : const BoxDecoration(),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      for (int i = 0;
                                                          i <
                                                              imageListType
                                                                  .length;
                                                          i++) {
                                                        imageListType[i] =
                                                            false;
                                                      }
                                                      imageListType[index] =
                                                          true;
                                                      widget.model!
                                                              .default_image =
                                                          imageListAws[index];
                                                      setState(() {});
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      child: Image.file(
                                                        File(imageList[index]),
                                                        alignment:
                                                            Alignment.center,
                                                        fit: BoxFit.fill,
                                                        width: 80,
                                                        height: 80,
                                                      ),
                                                    ),
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
                                                      imageListType
                                                          .removeAt(index);
                                                      imageListAws
                                                          .removeAt(index);
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.cancel,
                                                    color:
                                                        AppColors.primaryColor,
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
                        productTitleTextFormFiled(),
                        Dimens.boxHeight20,
                        brandTextFormFiled(),
                        Dimens.boxHeight20,
                        hsnTextFormFiled(context),
                        Dimens.boxHeight20,
                        Text(
                          NewMarkitVendorLocalizations.of(context)!
                              .find('product_taxable'),
                          style: Styles.lightGreyHint,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: hsnvalue,
                                  activeColor: AppColors.primaryColor,
                                  onChanged: (v) {
                                    setState(() {
                                      hsnvalue = int.parse(v.toString());
                                    });
                                  },
                                ),
                                Text(
                                  NewMarkitVendorLocalizations.of(context)!
                                      .find('yes'),
                                  style: Styles.boldBlack12,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 0,
                                  activeColor: AppColors.primaryColor,
                                  groupValue: hsnvalue,
                                  onChanged: (v) {
                                    setState(() {
                                      hsnvalue = int.parse(v.toString());
                                    });
                                  },
                                ),
                                Text(
                                  NewMarkitVendorLocalizations.of(context)!
                                      .find('no'),
                                  style: Styles.boldBlack12,
                                )
                              ],
                            ),
                          ],
                        ),
                        hsnvalue == 1
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  howMuchTextFormFiled(),
                                  Dimens.boxHeight20,
                                ],
                              )
                            : Container(),
                        Text(
                          NewMarkitVendorLocalizations.of(context)!
                              .find('is_same_as_delivery'),
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
                                  groupValue: value,
                                  activeColor: AppColors.primaryColor,
                                  onChanged: (v) {
                                    setState(() {
                                      value = int.parse(v.toString());
                                    });
                                  },
                                ),
                                Text(
                                  NewMarkitVendorLocalizations.of(context)!
                                      .find('yes'),
                                  style: Styles.boldBlack12,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 0,
                                  activeColor: AppColors.primaryColor,
                                  groupValue: value,
                                  onChanged: (v) {
                                    setState(() {
                                      value = int.parse(v.toString());
                                    });
                                  },
                                ),
                                Text(
                                  NewMarkitVendorLocalizations.of(context)!
                                      .find('no'),
                                  style: Styles.boldBlack12,
                                )
                              ],
                            ),
                          ],
                        ),
                        value == 1
                            ? Container()
                            : Column(
                                children: [
                                  estimatedTextFormFiled(),
                                  Dimens.boxHeight20,
                                ],
                              ),
                        Dimens.boxHeight20,
                        Text(
                          NewMarkitVendorLocalizations.of(context)!
                              .find('product_refundAble'),
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
                                  groupValue: refund,
                                  activeColor: AppColors.primaryColor,
                                  onChanged: (v) {
                                    setState(() {
                                      refund = int.parse(v.toString());
                                    });
                                  },
                                ),
                                Text(
                                  NewMarkitVendorLocalizations.of(context)!
                                      .find('yes'),
                                  style: Styles.boldBlack12,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 0,
                                  activeColor: AppColors.primaryColor,
                                  groupValue: refund,
                                  onChanged: (v) {
                                    setState(() {
                                      refund = int.parse(v.toString());
                                    });
                                  },
                                ),
                                Text(
                                  NewMarkitVendorLocalizations.of(context)!
                                      .find('no'),
                                  style: Styles.boldBlack12,
                                )
                              ],
                            ),
                          ],
                        ),
                        refund == 1
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  howMuchRefundAbleTextFormFiled(),
                                  Dimens.boxHeight20,
                                ],
                              )
                            : Container(),
                        Dimens.boxHeight20,
                        Text(
                          NewMarkitVendorLocalizations.of(context)!
                              .find('warrantyAvaliable'),
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
                                  groupValue: warenty,
                                  activeColor: AppColors.primaryColor,
                                  onChanged: (v) {
                                    setState(() {
                                      warenty = int.parse(v.toString());
                                    });
                                  },
                                ),
                                Text(
                                  NewMarkitVendorLocalizations.of(context)!
                                      .find('yes'),
                                  style: Styles.boldBlack12,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 0,
                                  activeColor: AppColors.primaryColor,
                                  groupValue: warenty,
                                  onChanged: (v) {
                                    setState(() {
                                      warenty = int.parse(v.toString());
                                    });
                                  },
                                ),
                                Text(
                                  NewMarkitVendorLocalizations.of(context)!
                                      .find('no'),
                                  style: Styles.boldBlack12,
                                )
                              ],
                            ),
                          ],
                        ),
                        warenty == 1
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child:
                                              howMuchWarrentyTypeTextFormFiled()),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: howWarrentyTextFormFiled(),
                                      )
                                    ],
                                  ),
                                  Dimens.boxHeight20,
                                ],
                              )
                            : Container(),
                        Dimens.boxHeight20,
                        Text(
                          NewMarkitVendorLocalizations.of(context)!
                              .find('payOnDelivery'),
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
                                  groupValue: cashOndelivery,
                                  activeColor: AppColors.primaryColor,
                                  onChanged: (v) {
                                    setState(() {
                                      cashOndelivery = int.parse(v.toString());
                                    });
                                  },
                                ),
                                Text(
                                  NewMarkitVendorLocalizations.of(context)!
                                      .find('yes'),
                                  style: Styles.boldBlack12,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 0,
                                  activeColor: AppColors.primaryColor,
                                  groupValue: cashOndelivery,
                                  onChanged: (v) {
                                    setState(() {
                                      cashOndelivery = int.parse(v.toString());
                                    });
                                  },
                                ),
                                Text(
                                  NewMarkitVendorLocalizations.of(context)!
                                      .find('no'),
                                  style: Styles.boldBlack12,
                                )
                              ],
                            ),
                          ],
                        ),
                        Dimens.boxHeight20,
                        billingTypeTypeTextFormFiled(),
                        Dimens.boxHeight20,
                        heightTextFormFiled(),
                        Dimens.boxHeight20,
                        lenghtTextFormFiled(),
                        Dimens.boxHeight20,
                        breadthTextFormFiled(),
                        Dimens.boxHeight20,
                        weightTextFormFiled(),
                        Dimens.boxHeight20,
                        deliveryHeavyTextFormFiled(),
                        Dimens.boxHeight20,
                        statusShipmentTextFormFiled(),
                        Dimens.boxHeight20,
                        maximumShipingTextFormFiled(),
                        Dimens.boxHeight20,
                        videoUrlTextFormFiled(),
                        Dimens.boxHeight20,
                        descirptionTextFormFiled(),
                        Dimens.boxHeight20,
                        seoProductTextFormFiled(),
                        Dimens.boxHeight20,
                        seoMetaTextFormFiled(),
                        Dimens.boxHeight20,
                        targettedTextFormFiled(),
                        Dimens.boxHeight20,
                        pinCodeTextFormFiled(),
                        Dimens.boxHeight20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('attributes'),
                              style: Styles.loginPageTitleBlack,
                            ),
                            GestureDetector(
                              onTap: () {
                                tempProductModel = addProductModel;
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: AttributeScreen(
                                          isNewProduct: true,
                                          dataModel: addProductModel,
                                        ))).then((value) {
                                  if (value != null) {
                                    addProductModel = value;

                                    setState(() {});
                                  } else {
                                    addProductModel = tempProductModel;
                                  }
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  addProductModel.variationsQuantity != null &&
                                          addProductModel
                                              .variationsQuantity!.isNotEmpty
                                      ? Container()
                                      : const Icon(
                                          Icons.add,
                                          color: AppColors.primaryColor,
                                        ),
                                  addProductModel.variationsQuantity != null &&
                                          addProductModel
                                              .variationsQuantity!.isNotEmpty
                                      ? Text(
                                          "Edit",
                                          style: Styles.boldBlack14,
                                        )
                                      : Text(
                                          NewMarkitVendorLocalizations.of(
                                                  context)!
                                              .find('addNew'),
                                          style: Styles.redMedium14,
                                        ),
                                ],
                              ),
                            )
                          ],
                        ),
                        addProductModel.variationsQuantity != null
                            ? Container(
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                child: Wrap(children: [
                                  for (int i = 0;
                                      i <
                                          addProductModel
                                              .variationsQuantity!.length;
                                      i++)
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: AppColors.greyColor
                                                    .withOpacity(0.6)),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: addProductModel
                                                            .variationsQuantity![
                                                                i]
                                                            .default_variation_image ==
                                                        null
                                                    ? ""
                                                    : addProductModel
                                                        .variationsQuantity![i]
                                                        .default_variation_image!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  width: 80,
                                                  height: 80.0,
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
                                                  width: 80,
                                                  height: 80.0,
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
                                                  width: 80,
                                                  height: 80.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                  ),
                                                  child: const Icon(Icons.error,
                                                      color: Colors.black,
                                                      size: 30),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Wrap(
                                                        children: [
                                                          for (int j = 0;
                                                              j <
                                                                  addProductModel
                                                                      .variationsQuantity![
                                                                          i]
                                                                      .attributes!
                                                                      .length;
                                                              j++)
                                                            Container(
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    addProductModel
                                                                            .variationsQuantity![i]
                                                                            .attributes![j]
                                                                            .attributeName! +
                                                                        ":- ",
                                                                    style: Styles
                                                                        .boldBlack14,
                                                                  ),
                                                                  addProductModel
                                                                              .variationsQuantity![i]
                                                                              .attributes![j]
                                                                              .attributeName ==
                                                                          "COLOR"
                                                                      ? Text(
                                                                          addProductModel
                                                                              .variationsQuantity![i]
                                                                              .attributes![j]
                                                                              .unit_name!,
                                                                          style:
                                                                              Styles.boldBlack12,
                                                                        )
                                                                      : Text(
                                                                          addProductModel
                                                                              .variationsQuantity![i]
                                                                              .attributes![j]
                                                                              .attributeValue!,
                                                                          style:
                                                                              Styles.boldBlack12,
                                                                        ),
                                                                  addProductModel
                                                                              .variationsQuantity![i]
                                                                              .attributes![j]
                                                                              .unit_id ==
                                                                          "0"
                                                                      ? Container()
                                                                      : addProductModel.variationsQuantity![i].attributes![j].attributeName == "COLOR"
                                                                          ? Container(
                                                                              width: 14,
                                                                              height: 14,
                                                                              decoration: BoxDecoration(shape: BoxShape.circle, color: Color(int.parse("0xFFF${addProductModel.variationsQuantity![i].attributes![j].attributeValue!.replaceAll("#", "")}"))),
                                                                            )
                                                                          : Text(
                                                                              addProductModel.variationsQuantity![i].attributes![j].unit_name!,
                                                                              style: Styles.blackMedium12,
                                                                            ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                              "Offer Price:- " +
                                                                  AppConstants
                                                                      .priceSign +
                                                                  addProductModel
                                                                      .variationsQuantity![
                                                                          i]
                                                                      .offerPrice!,
                                                              style: Styles
                                                                  .loginPageSubTitleGrey),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                              "Base Price:- " +
                                                                  AppConstants
                                                                      .priceSign +
                                                                  addProductModel
                                                                      .variationsQuantity![
                                                                          i]
                                                                      .basicPrice!,
                                                              style: Styles
                                                                  .loginPageSubTitleGrey),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "Qty:- " +
                                                                  addProductModel
                                                                      .variationsQuantity![
                                                                          i]
                                                                      .quantity!,
                                                              style: Styles
                                                                  .loginPageSubTitleGrey),
                                                          // GestureDetector(
                                                          //     onTap: () {
                                                          //       addProductModel
                                                          //           .variationsQuantity!
                                                          //           .removeAt(
                                                          //               i);
                                                          //       setState(() {});
                                                          //     },
                                                          //     child: const Icon(
                                                          //         Icons.delete,
                                                          //         color: AppColors
                                                          //             .primaryColor,
                                                          //         size: 30))
                                                        ],
                                                      ),
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    )
                                ]),
                              )
                            : Container(),
                        Dimens.boxHeight15,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('specifications'),
                              style: Styles.loginPageTitleBlack,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: SpecificationScreen(
                                          data: addProductModel.specifactions,
                                        ))).then((value) {
                                  if (value != null) {
                                    addProductModel.specifactions = value;

                                    setState(() {});
                                  }
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  addProductModel.specifactions != null
                                      ? Container()
                                      : const Icon(
                                          Icons.add,
                                          color: AppColors.primaryColor,
                                        ),
                                  addProductModel.specifactions != null
                                      ? Text(
                                          "Edit",
                                          style: Styles.boldBlack14,
                                        )
                                      : Text(
                                          NewMarkitVendorLocalizations.of(
                                                  context)!
                                              .find('addNew'),
                                          style: Styles.redMedium14,
                                        ),
                                ],
                              ),
                            )
                          ],
                        ),
                        addProductModel.specifactions != null
                            ? Container(
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color:
                                          AppColors.greyColor.withOpacity(0.6)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                  NewMarkitVendorLocalizations
                                                          .of(context)!
                                                      .find('title'),
                                                  style: Styles.boldBlack16),
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                  NewMarkitVendorLocalizations
                                                          .of(context)!
                                                      .find('value'),
                                                  style: Styles.boldBlack16),
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Wrap(children: [
                                      for (int i = 0;
                                          i <
                                              addProductModel
                                                  .specifactions!.length;
                                          i++)
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                        "${addProductModel.specifactions![i].title}",
                                                        style: Styles
                                                            .loginPageSubTitleGrey),
                                                  ),
                                                ),
                                                Text(":",
                                                    style: Styles.boldBlack14),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                        "${addProductModel.specifactions![i].specifactionValue}",
                                                        style: Styles
                                                            .loginPageSubTitleGrey),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        )
                                    ]),
                                  ],
                                ),
                              )
                            : Container(),
                        Dimens.boxHeight30,
                        FormSubmitWidget(
                          opacity: 1,
                          disableColor: AppColors.primaryColor,
                          padding: Dimens.edgeInsets0,
                          text: NewMarkitVendorLocalizations.of(context)!
                              .find('preview'),
                          textStyle: Styles.redMedium16,
                          startColor: Colors.white,
                          endColor: Colors.white,
                          borderColor: AppColors.primaryColor,
                          borderWidth: 1,
                          iconColor: Colors.white,
                          onTap: () {
                            _validateInputForPreview();
                          },
                        ),
                        Dimens.boxHeight20,
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
                                    .find('continueLabel'),
                                textStyle: Styles.buttonWhiteTextStyle,
                                startColor: AppColors.primaryColor,
                                endColor: AppColors.primaryColor,
                                iconColor: Colors.white,
                                onTap: () {
                                  _validateInput();
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _validateInputForPreview() {
    if (imageListAws.isEmpty) {
      Utility.errorMessage(
          NewMarkitVendorLocalizations.of(context)!
              .find('please_select_product_images'),
          context);
    } else if (addProductModel.variationsQuantity == null) {
      Utility.errorMessage(
          NewMarkitVendorLocalizations.of(context)!
              .find('please_add_attribute'),
          context);
    } else if (addProductModel.specifactions == null) {
      Utility.errorMessage(
          NewMarkitVendorLocalizations.of(context)!
              .find('please_add_specification'),
          context);
    } else {
      addProductModel.name = productTitleController.text;
      addProductModel.hsnNo = hsnController.text;
      // addProductModel.isPopular = isPopularController.text;
      addProductModel.isTaxable = hsnvalue == 1 ? "Yes" : "No";
      addProductModel.taxValue = hsnvalue == 1 ? howMuchController.text : "0";

      addProductModel.sameSayDelivery = value == 1 ? "yes" : "no";
      addProductModel.deliveryDay = value == 1 ? "0" : estimatedController.text;
      addProductModel.warranty = warenty == 1 ? "yes" : "no";
      addProductModel.warranty_month =
          warenty == 1 ? howMuchDaysWarrentyController.text : "0";
      addProductModel.warranty_type =
          warenty == 1 ? isWarrentyController.text : "";

      addProductModel.refundable = refund == 1 ? "yes" : "no";
      addProductModel.refend_day =
          refund == 1 ? howMuchRefundAbleController.text : "0";

      addProductModel.cash_on_delivery = cashOndelivery == 1 ? "yes" : "no";

      addProductModel.description = descriptionController.text;
      addProductModel.billing_mode_of_shipment = billingController.text;

      var image;
      for (int i = 0; i < imageListAws.length; i++) {
        if (image == null) {
          image = imageListAws[i];
        } else {
          image = image + "," + imageListAws[i];
        }
      }
      addProductModel.images = image;
      addProductModel.length_in_cm = lenghtController.text;
      addProductModel.breadth_in_cm = breadthController.text;
      addProductModel.height_in_cm = heightController.text;
      addProductModel.weight_in_grams = weightController.text;
      addProductModel.status_of_shipment = statusOfShipmentController.text;
      addProductModel.maximum_shipping_cost = maximumShipingCostController.text;

      addProductModel.video_url = videoUrlController.text;
      addProductModel.delivery_charges_for_above_30kg_items =
          deliveryHeavyController.text;
      String commaSeparatedString = _items.join(',');
      addProductModel.available_pin_code = commaSeparatedString;
      addProductModel.seo_product_title = seoProductTitle.text;

      addProductModel.seo_product_meta = seoMetaDescription.text;
      addProductModel.targetted_keywords = targettedkeywords.text;

      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: PreviewScreen(
                model: addProductModel,
                modelAttributes: modelAttributes,
              )));
    }
  }

  _validateInput() {
    if (formkey.currentState!.validate()) {
      if (imageListAws.isEmpty) {
        Utility.errorMessage(
            NewMarkitVendorLocalizations.of(context)!
                .find('please_select_product_images'),
            context);
      } else if (addProductModel.variationsQuantity == null) {
        Utility.errorMessage(
            NewMarkitVendorLocalizations.of(context)!
                .find('please_add_attribute'),
            context);
      } else if (addProductModel.specifactions == null) {
        Utility.errorMessage(
            NewMarkitVendorLocalizations.of(context)!
                .find('please_add_specification'),
            context);
      } else {
        addProductModel.name = productTitleController.text;
        addProductModel.hsnNo = hsnController.text;
        // addProductModel.isPopular = isPopularController.text;
        addProductModel.isTaxable = hsnvalue == 1 ? "Yes" : "No";
        addProductModel.taxValue = hsnvalue == 1 ? howMuchController.text : "0";

        addProductModel.sameSayDelivery = value == 1 ? "yes" : "no";
        addProductModel.deliveryDay =
            value == 1 ? "0" : estimatedController.text;

        addProductModel.warranty = warenty == 1 ? "yes" : "no";
        addProductModel.warranty_month =
            warenty == 1 ? howMuchDaysWarrentyController.text : "0";
        addProductModel.warranty_type =
            warenty == 1 ? isWarrentyController.text : "";
        addProductModel.refundable = refund == 1 ? "yes" : "no";
        addProductModel.refend_day =
            refund == 1 ? howMuchRefundAbleController.text : "0";

        addProductModel.cash_on_delivery = cashOndelivery == 1 ? "yes" : "no";

        addProductModel.description = descriptionController.text;
        addProductModel.billing_mode_of_shipment = billingController.text;

        var image;
        for (int i = 0; i < imageListAws.length; i++) {
          if (image == null) {
            image = imageListAws[i];
          } else {
            image = image + "," + imageListAws[i];
          }
        }
        addProductModel.images = image;
        addProductModel.length_in_cm = lenghtController.text;
        addProductModel.breadth_in_cm = breadthController.text;
        addProductModel.height_in_cm = heightController.text;
        addProductModel.weight_in_grams = weightController.text;
        addProductModel.status_of_shipment = statusOfShipmentController.text;
        addProductModel.video_url = videoUrlController.text;
        addProductModel.maximum_shipping_cost =
            maximumShipingCostController.text;

        addProductModel.delivery_charges_for_above_30kg_items =
            deliveryHeavyController.text;
        addProductModel.video_url = videoUrlController.text;
        String commaSeparatedString = _items.join(',');
        addProductModel.available_pin_code = commaSeparatedString;
        addProductModel.seo_product_title = seoProductTitle.text;

        addProductModel.seo_product_meta = seoMetaDescription.text;
        addProductModel.targetted_keywords = targettedkeywords.text;

        isLoader = true;
        setState(() {});
        whichApiCall = "add_product";
        ApiCall.uploadProductApi(addProductModel, token, this, context);
      }
    }
  }

  productTitleTextFormFiled() {
    return TextFormField(
      controller: productTitleController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('product_title'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  hsnTextFormFiled(BuildContext ctx) {
    return TextFormField(
      readOnly: false,
      controller: hsnController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      onTap: () {},
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('hsn'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        // suffixIcon: const Icon(
        //   Icons.arrow_drop_down,
        //   color: AppColors.lightGreyHintText,
        // )
      ),
    );
  }

  hsnTypeTextFormFiled() {
    return TextFormField(
      readOnly: true,
      controller: hsnTypeController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('product_taxable'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  brandTextFormFiled() {
    return TextFormField(
      readOnly: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: brandController,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => Utility.brandCategoryFiledValid(v!, context),
      onTap: () {
        brandBottomSheet(context, brandController);
      },
      decoration: InputDecoration(
          labelText: NewMarkitVendorLocalizations.of(context)!.find('brand'),
          labelStyle: Styles.lightGrey14,
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

  addInBrandView() {
    setState(() {});
  }

  addInWarrentyTypeView(String value) {
    isWarrentyController.text = value;

    setState(() {});
  }

  addInBillingTypeView(String value) {
    billingController.text = value;

    setState(() {});
  }

  addInsShipMentTypeView(String value) {
    statusOfShipmentController.text = value;

    setState(() {});
  }

  void _runFilterBrand(String enteredKeyword, StateSetter setState) {
    List<BData> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = allBData;
    } else {
      results = acData!
          .where((user) =>
              user.name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      acData = results;
    });
  }

  void brandBottomSheet(BuildContext ctx, TextEditingController c) {
    showModalBottomSheet(
        elevation: 10,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
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
                                  .find('brand'),
                              style: Styles.boldWhite16,
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
                    TextFormField(
                      onChanged: (v) {
                        _runFilterBrand(v, setState);
                      },
                      style: Styles.formFieldTextStyle,
                      decoration: const InputDecoration(
                          hintText: "Search brand",
                          contentPadding: EdgeInsets.all(16)),
                    ),
                    Expanded(
                        flex: 1,
                        child: ListView.builder(
                            itemCount: acData!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  c.text = acData![index].name!;
                                  addProductModel.brandId =
                                      acData![index].id.toString();
                                  addProductModel.bransName =
                                      acData![index].name!;
                                  _runFilterBrand("", setState);
                                  Navigator.pop(context);
                                  addInBrandView();
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
                                          c.text = acData![index].name!;
                                          addProductModel.brandId =
                                              acData![index].id.toString();
                                          addProductModel.bransName =
                                              acData![index].name!;
                                          _runFilterBrand("", setState);
                                          Navigator.pop(context);
                                          addInBrandView();
                                        },
                                        child: Text(
                                          acData![index].name!,
                                          style: Styles.boldBlack16,
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              );
                            }))
                  ],
                ),
              ),
            );
          });
        });
  }

  changeState() {
    setState(() {});
  }

  // void brandBottomSheet(BuildContext ctx) {
  //   showModalBottomSheet(
  //       elevation: 10,
  //       backgroundColor: Colors.white,
  //       context: ctx,
  //       builder: (ctx) {
  //         return StatefulBuilder(builder: (BuildContext context,
  //             StateSetter setState /*You can rename this!*/) {
  //           return Container(
  //             width: MediaQuery.of(context).size.width,
  //             height: MediaQuery.of(context).size.height / 2 - 100,
  //             color: Colors.white54,
  //             child: Column(
  //               children: [
  //                 Container(
  //                   height: 40,
  //                   color: AppColors.primaryColor,
  //                   padding: const EdgeInsets.only(left: 16, right: 16),
  //                   alignment: Alignment.centerRight,
  //                   width: MediaQuery.of(context).size.width,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () {},
  //                         child: Text(
  //                           NewMarkitVendorLocalizations.of(context)!
  //                               .find('brand'),
  //                           style: Styles.boldWhite16,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                   height: 1,
  //                   color: Colors.grey[400],
  //                   width: MediaQuery.of(context).size.width,
  //                 ),
  //                 Expanded(
  //                     flex: 1,
  //                     child: ListView.builder(
  //                         itemCount: model.data!.length,
  //                         itemBuilder: (context, index) {
  //                           return GestureDetector(
  //                             onTap: () {
  //                               addInBrandView(index);
  //                               Navigator.pop(context);
  //                             },
  //                             child: Container(
  //                               color: Colors.grey.withAlpha(2),
  //                               padding: const EdgeInsets.all(16),
  //                               alignment: Alignment.center,
  //                               width: MediaQuery.of(context).size.width,
  //                               child: Row(
  //                                 children: [
  //                                   GestureDetector(
  //                                     onTap: () {
  //                                       addInBrandView(index);
  //                                       Navigator.pop(context);
  //                                     },
  //                                     child: Text(
  //                                       model.data![index].name!,
  //                                       style: Styles.boldBlack16,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           );
  //                         }))
  //               ],
  //             ),
  //           );
  //         });
  //       });
  // }

  void isWarrentyTypeBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2 - 100,
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
                                .find('selectwarrenty'),
                            style: Styles.boldWhite16,
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
                          itemCount: isWarentyTypeList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                addInWarrentyTypeView(isWarentyTypeList[index]);
                                Navigator.pop(context);
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
                                        addInWarrentyTypeView(
                                            isWarentyTypeList[index]);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        isWarentyTypeList[index],
                                        style: Styles.boldBlack16,
                                      ),
                                    ),
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

  void billingModeBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2 - 100,
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
                                .find('billingModeOfShipment'),
                            style: Styles.boldWhite16,
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
                          itemCount: ibillingModeList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                addInBillingTypeView(ibillingModeList[index]);
                                Navigator.pop(context);
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
                                        addInBillingTypeView(
                                            ibillingModeList[index]);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        ibillingModeList[index],
                                        style: Styles.boldBlack16,
                                      ),
                                    ),
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

  void statusOfModeBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2 - 100,
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
                                .find('selectShipment'),
                            style: Styles.boldWhite16,
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
                          itemCount: statusOfShipmentModeList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                addInsShipMentTypeView(
                                    statusOfShipmentModeList[index]);
                                Navigator.pop(context);
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
                                        addInsShipMentTypeView(
                                            statusOfShipmentModeList[index]);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        statusOfShipmentModeList[index],
                                        style: Styles.boldBlack16,
                                      ),
                                    ),
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

  howMuchTextFormFiled() {
    return TextFormField(
      readOnly: false,
      controller: howMuchController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('how_much_taxable'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  howMuchRefundAbleTextFormFiled() {
    return TextFormField(
      controller: howMuchRefundAbleController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('refundableDays'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  howMuchWarrentyTypeTextFormFiled() {
    return TextFormField(
      readOnly: true,
      controller: isWarrentyController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      onTap: () {
        isWarrentyTypeBottomSheet(context);
      },
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
          labelText:
              NewMarkitVendorLocalizations.of(context)!.find('warrentyType'),
          labelStyle: Styles.lightGrey14,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.lightGreyHintText,
          )),
    );
  }

  billingTypeTypeTextFormFiled() {
    return TextFormField(
      readOnly: true,
      controller: billingController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      onTap: () {
        billingModeBottomSheet(context);
      },
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
          labelText: NewMarkitVendorLocalizations.of(context)!
              .find('billingModeOfShipment'),
          labelStyle: Styles.lightGrey14,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.lightGreyHintText,
          )),
    );
  }

  howWarrentyTextFormFiled() {
    return TextFormField(
      controller: howMuchDaysWarrentyController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            "How Much ${isWarrentyController.text.isEmpty ? "Days" : isWarrentyController.text} for warranty?",
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  estimatedTextFormFiled() {
    return TextFormField(
      controller: estimatedController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!
            .find('estimated_delivery'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  heightTextFormFiled() {
    return TextFormField(
      controller: heightController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      onChanged: (v) {
        calculateWeight();
      },
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('heightCM'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  calculateWeight() {
    var bb = num.parse(breadthController.text);
    var hh = num.parse(heightController.text);
    var ll = num.parse(lenghtController.text);

    var totalWeight1 = ((ll * bb * hh) / 5000) * 1000;
    if (totalWeight1 < 500) {
      weightController.text = '500';
    }

    weightController.text = totalWeight1.toStringAsFixed(2);

    // $('.weight_in_grams').val(totalWeight1);
    // if (totalWeight1 >= 30000) {
    //   $(".heavy_items_charge").removeClass('hide');
    // } else {
    //   $(".heavy_items_charge").addClass('hide');
    // }
    // if (totalWeight1 < 500) {
    //   $('.weight_in_grams').val(500);
    // }
  }

  lenghtTextFormFiled() {
    return TextFormField(
      controller: lenghtController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      onChanged: (v) {
        calculateWeight();
      },
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('lenghtCM'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  breadthTextFormFiled() {
    return TextFormField(
      controller: breadthController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      onChanged: (v) {
        calculateWeight();
      },
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('breadthCM'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  weightTextFormFiled() {
    return TextFormField(
      controller: weightController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('wightGrams'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  deliveryHeavyTextFormFiled() {
    return TextFormField(
      controller: deliveryHeavyController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!
            .find('deliveryChargesForHeavy'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  statusShipmentTextFormFiled() {
    return TextFormField(
      controller: statusOfShipmentController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      onTap: () {
        statusOfModeBottomSheet(context);
      },
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.text,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('statusOfShipment'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        suffixIcon: const Icon(
          Icons.arrow_drop_down,
          color: AppColors.lightGreyHintText,
        ),
      ),
    );
  }

  maximumShipingTextFormFiled() {
    return TextFormField(
      controller: maximumShipingCostController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('maximumShipment'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  videoUrlTextFormFiled() {
    return TextFormField(
      controller: videoUrlController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.text,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('videoUrl'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  seoProductTextFormFiled() {
    return TextFormField(
      controller: seoProductTitle,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.text,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('seoProductTitle'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  seoMetaTextFormFiled() {
    return TextFormField(
      controller: seoMetaDescription,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.text,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('seoMeta'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  targettedTextFormFiled() {
    return TextFormField(
      controller: targettedkeywords,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.text,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('targettedKeyword'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  pinCodeTextFormFiled() {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Tags(
        heightHorizontalScroll: 100,

        key: _tagStateKey,
        textField: TagsTextField(
          autofocus: false,
          keyboardType: TextInputType.number,
          hintText: NewMarkitVendorLocalizations.of(context)!
              .find('pinCodeAvailbility'),
          textStyle: TextStyle(fontSize: 14),
          onSubmitted: (String str) {
            print(str);
            setState(() {
              // required
              _items.add(str);
            });
          },
        ),
        itemCount: _items.length, // required
        itemBuilder: (int index) {
          final item = _items[index];

          return ItemTags(
            // Each ItemTags must contain a Key. Keys allow Flutter to
            // uniquely identify widgets.
            key: Key(index.toString()),
            index: index, // required
            title: item,

            textStyle: TextStyle(
              fontSize: 14,
            ),
            activeColor: AppColors.primaryColor,
            combine: ItemTagsCombine.withTextBefore,

            removeButton: ItemTagsRemoveButton(
              onRemoved: () {
                // Remove the item from the data source.
                setState(() {
                  // required
                  _items.removeAt(index);
                });
                //required
                return true;
              },
            ), // OR null,
            onPressed: (item) => print(item),
            onLongPressed: (item) => print(item),
          );
        },
      ),
    );
  }

  descirptionTextFormFiled() {
    return TextFormField(
      controller: descriptionController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!
            .find('product_description'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
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
        imageListType.add(false);
        imageListType[0] = true;

        setState(() {});
        Utility.dialogLoader(context);

        whichApiCall = "upload_image";
        ApiCall.uploadProductImage(croppedFile.path, this, context, token);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onFailure(message) {
    if (whichApiCall == "add_product") {
      Utility.errorMessage(message, context);
      isLoader = false;
      setState(() {});
    } else if (whichApiCall == "upload_image") {
      Navigator.pop(context);
    }
  }

  @override
  void onSuccess(data) {
    if (whichApiCall == "") {
      model = Brand.fromJson(data);
      acData = model.data!;
      allBData = model.data!;

      whichApiCall = "attribute";
      ApiCall.attributeList(token, this, context);
    } else if (whichApiCall == "attribute") {
      modelAttributes = Attributes.fromJson(data);
    } else if (whichApiCall == "add_product") {
      isLoader = false;
      addProductModel.variationsQuantity!.clear();
      addProductModel.specifactions!.clear();
      setState(() {});

      Utility.facebookEventWithParametter("add_product_screen", {
        "vendor_name": pModel.data!.businesses!.name!,
        "product_title": productTitleController.text
      });

      Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: SuccessScreen()))
          .then((value) {
        Navigator.pop(context, true);
      });
    } else if (whichApiCall == "upload_image") {
      Navigator.pop(context);
      imageListAws.add(data['url']);
      addProductModel.default_image = imageListAws[0];
    }
  }

  @override
  void onTokenExpired() {}

  Future<http.Response?> hsnList(
    String id,
    String token,
  ) async {
    print(id + " " + token);
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.get(Uri.parse(UrlConstant.hsnNumber + id), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });

        if (response.statusCode == 200) {
          print(response.body);
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            hsnModel = HsnModel.fromJson(data);
          } else if (data['status'] == 403) {
          } else {}

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          print(response.statusCode);
        }
      } catch (e) {
        print(NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      print(NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  void isHsnBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2 - 100,
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
                                .find('hsnNumber'),
                            style: Styles.boldWhite16,
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
                          itemCount: hsnModel.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                hsnView(hsnModel.data![index]);
                                Navigator.pop(context);
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
                                        hsnView(hsnModel.data![index]);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        hsnModel.data![index].number!,
                                        style: Styles.boldBlack16,
                                      ),
                                    ),
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

  hsnView(Hsnata value) {
    data = value;
    hsnController.text = data.number!;
    hsnTypeController.text = data.taxable!;
    howMuchController.text = data.howMuchTax!;

    setState(() {});
  }
}
