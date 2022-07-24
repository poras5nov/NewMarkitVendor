import 'dart:io';
import 'dart:convert' show jsonDecode, json;

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
import 'package:market_vendor_app/activities/home_page/model/HomeModel.dart';

import '../add_product/model/addproduct.dart';
import '../add_product/model/hsn_model.dart';

class EditProductScreen extends StatefulWidget {
  ProductData? data;

  EditProductScreen({Key? key, this.data}) : super(key: key);
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen>
    implements ApiInterface {
  var token;
  Brand model = Brand();
  Attributes modelAttributes = Attributes();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController brandController = TextEditingController(text: "");
  TextEditingController productTitleController =
      TextEditingController(text: "");
  // TextEditingController isPopularController = TextEditingController(text: "");
  TextEditingController hsnController = TextEditingController(text: "");
  TextEditingController hsnTypeController = TextEditingController(text: "");

  TextEditingController howMuchController = TextEditingController(text: "");
  TextEditingController estimatedController = TextEditingController(text: "");
  TextEditingController descriptionController = TextEditingController(text: "");
  TextEditingController howMuchRefundAbleController =
      TextEditingController(text: "");
  TextEditingController howMuchDaysWarrentyController =
      TextEditingController(text: "");
  List<String> imageList = [];
  List<String> imageListAws = [];
  List<bool> imageListType = [];

  List<String> isPopluarList = ["Yes", "No"];
  var brandPostion;
  int val = 1;
  int value = 1;
  String whichApiCall = "";
  List<String> isWarentyTypeList = ["Days", "Months", "Years"];

  HsnModel hsnModel = HsnModel();
  int refund = 1;
  int cashOndelivery = 1;
  int warenty = 1;

  AddProductModel addProductModel = AddProductModel();
  bool isLoader = false;
  ProductData productModel = ProductData();
  var productId;
  Hsnata data = Hsnata();

  TextEditingController isWarrentyController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    productModel = widget.data!;
    setDataInModel();
    getToken();
  }

  setDataInModel() {
    productId = productModel.id.toString();
    addProductModel.product_id = productId;
    addProductModel.name = productModel.name;
    productTitleController.text = addProductModel.name!;
    addProductModel.categoryId = productModel.categoryId.toString();
    addProductModel.subCategoryId = productModel.subCategoryId.toString();
    addProductModel.childCategoryId = productModel.childCategoryId.toString();
    addProductModel.hsnNo = productModel.hsnNo.toString();
    hsnController.text = addProductModel.hsnNo!;

    addProductModel.isTaxable = productModel.isTaxable!;
    hsnTypeController.text = addProductModel.isTaxable!;

    addProductModel.taxValue = productModel.taxValue;
    howMuchController.text = addProductModel.taxValue!;
    addProductModel.sameSayDelivery = productModel.sameSayDelivery;
    print(productModel.sameSayDelivery);
    if (addProductModel.sameSayDelivery == "yes") {
      value = 1;
    } else {
      value = 0;
    }
    addProductModel.brandId = productModel.brandId.toString();
    addProductModel.bransName = productModel.brand!.name;
    brandController.text = addProductModel.bransName!;
    addProductModel.description = productModel.description;
    descriptionController.text = addProductModel.description!;

    addProductModel.deliveryDay = productModel.deliveryDay;
    estimatedController.text = addProductModel.deliveryDay!;

    descriptionController.text = addProductModel.description!;

    addProductModel.images = productModel.images;
    addProductModel.default_image = productModel.default_image!;
    print("fdwfwdf " + productModel.default_image!);
    for (int i = 0; i < addProductModel.images!.split(",").length; i++) {
      imageListAws.add(addProductModel.images!.split(",")[i]);
      imageListType.add(false);
    }
    for (int i = 0; i < imageListAws.length; i++) {
      if (imageListAws[i] == productModel.default_image!) {
        imageListType[i] = true;
      }
    }
    addProductModel.attribute_ids = productModel.attributeIds;

    addProductModel.warranty = productModel.warranty;
    if (addProductModel.warranty == "yes") {
      warenty = 1;
    } else {
      warenty = 0;
    }
    addProductModel.warranty_month = productModel.warranty_month == "null"
        ? ""
        : productModel.warranty_month;
    howMuchDaysWarrentyController.text = addProductModel.warranty_month!;
    addProductModel.warranty_type = productModel.warranty_type!;
    isWarrentyController.text = addProductModel.warranty_type!;
    addProductModel.refundable = productModel.refundable;
    if (addProductModel.refundable == "yes") {
      refund = 1;
    } else {
      refund = 0;
    }
    addProductModel.refend_day =
        productModel.refend_day == "null" ? "" : productModel.refend_day;
    howMuchRefundAbleController.text = addProductModel.refend_day!;

    addProductModel.cash_on_delivery = productModel.cash_on_delivery;
    if (addProductModel.cash_on_delivery == "yes") {
      cashOndelivery = 1;
    } else {
      cashOndelivery = 0;
    }
    //-------------------Variation listmake for edit---------------
    List<VariationsQuantity>? variations = List.empty(growable: true);

    for (int i = 0; i < productModel.variations!.length; i++) {
      VariationsQuantity v = VariationsQuantity();
      v.offerPrice = productModel.variations![i].offerPrice.toString();
      v.basicPrice = productModel.variations![i].basicPrice.toString();
      v.quantity = productModel.variations![i].quantity.toString();
      v.images = productModel.variations![i].images.toString();
      v.default_variation_image =
          productModel.variations![i].default_variation_image == null
              ? ""
              : productModel.variations![i].default_variation_image.toString();

      List<AddAttribute> attr = List.empty(growable: true);
      for (int j = 0; j < productModel.variations![i].attribute!.length; j++) {
        AddAttribute a = AddAttribute();
        a.attributeId = productModel
            .variations![i].attribute![j].attributeName!.id
            .toString();
        a.attributeValue =
            productModel.variations![i].attribute![j].attributeValue;
        a.attributeName =
            productModel.variations![i].attribute![j].attributeName!.name;
        a.unit_id = productModel.variations![i].attribute![j].unit == null
            ? "0"
            : productModel.variations![i].attribute![j].unit!.id.toString();
        a.unit_name = productModel.variations![i].attribute![j].unit == null
            ? ""
            : productModel.variations![i].attribute![j].unit!.name.toString();
        attr.add(a);
      }
      v.attributes = attr;
      variations.add(v);
    }
    addProductModel.variationsQuantity = variations;

    //--------------Specification list make for edit-----------
    List<Specifactions>? spec = List.empty(growable: true);
    for (int i = 0; i < productModel.specification!.length; i++) {
      Specifactions s = Specifactions();
      s.specifactionValue = productModel.specification![i].value!;
      s.title = productModel.specification![i].name!;
      s.forFilter = productModel.specification![i].forFilter!;
      spec.add(s);
    }
    addProductModel.specifactions = spec;
    setState(() {});
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
      ApiCall.brandList(token, this, context);
      hsnList(addProductModel.categoryId!, token);
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
                                      return GestureDetector(
                                        onTap: () {
                                          for (int i = 0;
                                              i < imageListType.length;
                                              i++) {
                                            imageListType[i] = false;
                                          }
                                          imageListType[index] = true;
                                          setState(() {});
                                        },
                                        child: Container(
                                            width: 100,
                                            height: 100,
                                            margin: const EdgeInsets.all(5),
                                            alignment: Alignment.center,
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.all(5),
                                                  width: 100,
                                                  height: 100,
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
                                                                      10.0),
                                                        )
                                                      : const BoxDecoration(),
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
                                                      width: 80,
                                                      height: 80,
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
                                                      width: 80,
                                                      height: 80,
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
                                                        imageListType
                                                            .removeAt(index);
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
                                            )),
                                      );
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
                        hsnTypeTextFormFiled(),
                        Dimens.boxHeight20,
                        hsnTypeController.text == "Yes"
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
                        descirptionTextFormFiled(),
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
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: AttributeScreen(
                                          dataModel: addProductModel,
                                        ))).then((value) {
                                  if (value != null) {
                                    addProductModel = value;

                                    setState(() {});
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
                                              Container(
                                                child: CachedNetworkImage(
                                                  imageUrl: addProductModel
                                                              .variationsQuantity![
                                                                  i]
                                                              .default_variation_image ==
                                                          null
                                                      ? ""
                                                      : addProductModel
                                                          .variationsQuantity![
                                                              i]
                                                          .default_variation_image!,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
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
                                                    child: const Icon(
                                                        Icons.error,
                                                        color: Colors.black,
                                                        size: 30),
                                                  ),
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
                                    .find('update'),
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
      addProductModel.isTaxable = hsnTypeController.text;
      addProductModel.taxValue =
          hsnTypeController.text == "Yes" ? howMuchController.text : "";
      addProductModel.sameSayDelivery = value == 1 ? "Yes" : "No";
      addProductModel.deliveryDay = estimatedController.text;
      addProductModel.description = descriptionController.text;
      var image;
      for (int i = 0; i < imageListAws.length; i++) {
        if (image == null) {
          image = imageListAws[i];
        } else {
          image = image + "," + imageListAws[i];
        }
      }
      addProductModel.images = image;
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
      } else if (addProductModel.default_image == "") {
        Utility.errorMessage("Please select default image", context);
      } else {
        addProductModel.name = productTitleController.text;
        addProductModel.hsnNo = hsnController.text;
        // addProductModel.isPopular = isPopularController.text;
        addProductModel.isTaxable = hsnTypeController.text;
        addProductModel.taxValue =
            hsnTypeController.text == "Yes" ? howMuchController.text : "";

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
        var image;
        for (int i = 0; i < imageListAws.length; i++) {
          if (image == null) {
            image = imageListAws[i];
          } else {
            image = image + "," + imageListAws[i];
          }
        }
        if (addProductModel.childCategoryId == "null") {
          addProductModel.childCategoryId = "";
        }
        addProductModel.images = image;
        for (int i = 0; i < imageListType.length; i++) {
          if (imageListType[i] == true) {
            addProductModel.default_image = imageListAws[i];
            break;
          }
        }
        isLoader = true;
        setState(() {});
        whichApiCall = "edit_product";
        ApiCall.editProductApi(addProductModel, token, this, context);
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
      keyboardType: TextInputType.emailAddress,
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
      readOnly: true,
      controller: hsnController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      onTap: () {
        isHsnBottomSheet(ctx);
      },
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
          labelText: NewMarkitVendorLocalizations.of(context)!.find('hsn'),
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

  // isPopularTextFormFiled() {
  //   return TextFormField(
  //     readOnly: true,
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     controller: isPopularController,
  //     cursorColor: AppColors.primaryColor,
  //     textAlignVertical: TextAlignVertical.center,
  //     style: Styles.formFieldTextStyle,
  //     keyboardType: TextInputType.emailAddress,
  //     validator: (v) => Utility.ispopularFiledValid(v!, context),
  //     onTap: () {
  //       isPopularBottomSheet(context);
  //     },
  //     decoration: InputDecoration(
  //         labelText:
  //             NewMarkitVendorLocalizations.of(context)!.find('ispopular'),
  //         labelStyle: Styles.lightGrey14,
  //         hintStyle: Styles.lightGrey14,
  //         focusedBorder: const UnderlineInputBorder(
  //           borderSide: BorderSide(color: AppColors.primaryColor),
  //         ),
  //         suffixIcon: const Icon(
  //           Icons.arrow_drop_down,
  //           color: AppColors.lightGreyHintText,
  //         )),
  //   );
  // }

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
        brandBottomSheet(context);
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

  addInBrandView(int i) {
    brandPostion = i;
    brandController.text = model.data![brandPostion].name!;
    addProductModel.brandId = model.data![brandPostion].id.toString();
    addProductModel.bransName = model.data![brandPostion].name;
    setState(() {});
  }

  void brandBottomSheet(BuildContext ctx) {
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
                  Expanded(
                      flex: 1,
                      child: ListView.builder(
                          itemCount: model.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                addInBrandView(index);
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
                                        addInBrandView(index);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        model.data![index].name!,
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

  howMuchTextFormFiled() {
    return TextFormField(
      readOnly: true,
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
          androidUiSettings: AndroidUiSettings(
            toolbarTitle:
                NewMarkitVendorLocalizations.of(context)!.find('appName'),
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          iosUiSettings: const IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      debugPrint(croppedFile!.path);
      if (croppedFile.path.isNotEmpty) {
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
      whichApiCall = "attribute";
      ApiCall.attributeList(token, this, context);
    } else if (whichApiCall == "attribute") {
      modelAttributes = Attributes.fromJson(data);
    } else if (whichApiCall == "edit_product") {
      isLoader = false;
      setState(() {});
      Navigator.pop(context, true);
    } else if (whichApiCall == "upload_image") {
      Navigator.pop(context);
      imageListAws.add(data['url']);
      imageListType.add(false);
      if (imageListType.isEmpty) {
        imageListType[0] = true;
      }

      setState(() {});
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

  hsnView(Hsnata value) {
    data = value;
    hsnController.text = data.number!;
    hsnTypeController.text = data.taxable!;
    howMuchController.text = data.howMuchTax!;

    setState(() {});
  }

  //-------------------Warrenty widget====================
  addInWarrentyTypeView(String value) {
    isWarrentyController.text = value;

    setState(() {});
  }

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
}
