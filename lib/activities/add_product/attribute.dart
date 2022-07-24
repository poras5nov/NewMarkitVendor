import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_vendor_app/activities/add_product/model/addproduct.dart';
import 'package:market_vendor_app/activities/add_product/new_attribute.dart';
import 'package:market_vendor_app/activities/home_page/model/HomeModel.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/utils/strings/app_constants.dart';

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
import 'model/attributes_model.dart';

class AttributeScreen extends StatefulWidget {
  AddProductModel? dataModel;
  AttributeScreen({Key? key, required this.dataModel}) : super(key: key);
  @override
  _AttributeScreenState createState() => _AttributeScreenState();
}

class _AttributeScreenState extends State<AttributeScreen>
    implements ApiInterface {
  var token;
  Attributes model = Attributes();
  List<Data>? dataModel = [];
  TextEditingController attributeController = TextEditingController();

  int p = 0;
  String whichApiCall = "";

  List<VariationsQuantity> variationsQuantity = [];
  AddProductModel productmodel = AddProductModel();
  var tempmodel;

  var indexValueEdit;

  List<Color> currentColors = [Colors.yellow, Colors.green];
  List<Color> colorHistory = [];

  Color? currentColor;

  void changeColor(Color color) => setState(() => currentColor = color);
  void changeColors(List<Color> colors) =>
      setState(() => currentColors = colors);
  @override
  void initState() {
    super.initState();

    productmodel = widget.dataModel!;
    print(productmodel.variationsQuantity == null
        ? "0"
        : productmodel.variationsQuantity![0].attributes!.length);

    setState(() {});

    getToken();
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
      Utility.dialogLoader(context);

      ApiCall.attributeList(token, this, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {
                                  bool isSaveValueExist = false;
                                  for (int i = 0;
                                      i <
                                          productmodel
                                              .variationsQuantity!.length;
                                      i++) {
                                    if (productmodel
                                            .variationsQuantity![i].isEdit ==
                                        true) {
                                      isSaveValueExist = true;
                                      break;
                                    }
                                  }
                                  if (isSaveValueExist) {
                                    showAlertDialog(context);
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  color: AppColors.blackColor,
                                  size: Dimens.twentyEight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Dimens.boxHeight15,
                        Text(
                          NewMarkitVendorLocalizations.of(context)!
                              .find('attributes'),
                          style: Styles.loginPageTitleBlack,
                        ),
                        Dimens.boxHeight15,
                        Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('chooseproductattribut'),
                            style: Styles.loginPageSubTitleGrey),
                        Dimens.boxHeight20,
                        attributeTextFormFiled(),
                        Dimens.boxHeight10,
                        model.data != null
                            ? Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  for (int i = 0; i < model.data!.length; i++)
                                    if (model.data![i].isSelected)
                                      Container(
                                        margin: const EdgeInsets.all(5),
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: AppColors.lightBlueColor2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              model.data![i].name!,
                                              style: Styles.whiteLight14,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                model.data![i].isSelected =
                                                    false;
                                                update(i);
                                              },
                                              child: const Icon(Icons.close,
                                                  size: 24,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      )
                                ],
                              )
                            : Container(),
                        Dimens.boxHeight10,
                        model.data == null
                            ? Container()
                            : productmodel.variationsQuantity == null
                                ? Container()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        productmodel.variationsQuantity!.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          NewAttributeScreen(
                                              variation: productmodel
                                                  .variationsQuantity![index],
                                              attributes: dataModel,
                                              deleteCallBack: (v) {
                                                productmodel.variationsQuantity!
                                                    .removeAt(v);
                                                setState(() {});
                                              },
                                              saveCallBack: (variation, p) {
                                                productmodel
                                                        .variationsQuantity![
                                                    p] = variation;
                                                setState(() {});
                                              },
                                              p: index),
                                          Dimens.boxHeight10,
                                        ],
                                      );
                                    },
                                  ),
                        dataModel!.isNotEmpty
                            ? FormSubmitWidget(
                                opacity: 1,
                                padding: Dimens.edgeInsets0,
                                text: NewMarkitVendorLocalizations.of(context)!
                                    .find('addMore'),
                                textStyle: Styles.redMedium16,
                                startColor: Colors.white,
                                endColor: Colors.white,
                                borderColor: AppColors.primaryColor,
                                borderWidth: 1,
                                iconColor: Colors.white,
                                onTap: () {
                                  addMore();
                                },
                              )
                            : Container(),
                        Dimens.boxHeight20,
                        dataModel!.isNotEmpty
                            ? FormSubmitWidget(
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
                                  bool isAnyEdit = false;
                                  for (int i = 0;
                                      i <
                                          productmodel
                                              .variationsQuantity!.length;
                                      i++) {
                                    if (productmodel
                                            .variationsQuantity![i].isEdit ==
                                        false) {
                                      isAnyEdit = true;
                                      break;
                                    }
                                  }
                                  if (isAnyEdit) {
                                    Utility.errorMessage(
                                        "Please Save variations", context);
                                  } else {
                                    Navigator.pop(context, productmodel);
                                  }
                                },
                              )
                            : Container(),
                      ],
                    ),
                  )),
            ],
          )),
    );
  }

  attributeTextFormFiled() {
    return TextFormField(
      readOnly: true,
      controller: attributeController,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      onTap: () {
        attributesBottomSheet(context);
      },
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('attributes'),
        labelStyle: Styles.lightGrey14,
        hintText:
            NewMarkitVendorLocalizations.of(context)!.find('selectattributes'),
        hintStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  update(int p) {
    if (dataModel!.isNotEmpty) {
      dataModel!.clear();
    }
    var attributrIDs = "";

    for (int i = 0; i < model.data!.length; i++) {
      if (model.data![i].isSelected) {
        dataModel!.add(model.data![i]);
        if (attributrIDs == "") {
          attributrIDs = model.data![i].id!.toString();
        } else {
          attributrIDs = attributrIDs + "," + model.data![i].id!.toString();
        }
      }
    }
    for (int k = 0; k < productmodel.variationsQuantity!.length; k++) {
      for (int i = 0;
          i < productmodel.variationsQuantity![k].attributes!.length;
          i++) {
        bool isDelete = true;
        for (int d = 0; d < dataModel!.length; d++) {
          if (productmodel
                  .variationsQuantity![k].attributes![i].attributeName ==
              dataModel![d].name) {
            isDelete = false;
          }
        }
        if (isDelete) {
          productmodel.variationsQuantity![k].attributes!.removeAt(i);
        }
      }
      productmodel.variationsQuantity![k].isEdit = false;
    }
    productmodel.attribute_ids = attributrIDs;
    setState(() {});
  }

  addMore() {
    List<AddAttribute>? a = List.empty(growable: true);
    for (int i = 0; i < dataModel!.length; i++) {
      AddAttribute v = AddAttribute();
      v.attributeName = dataModel![i].name!;
      v.attributeId = dataModel![i].id.toString();
      a.add(v);
    }
    VariationsQuantity q = VariationsQuantity();
    q.attributes = a;
    productmodel.variationsQuantity!.add(q);

    setState(() {});
  }

  changeState() {
    dataModel = [];
    variationsQuantity = [];
    var attributrIDs = "";

    for (int i = 0; i < model.data!.length; i++) {
      if (model.data![i].isSelected) {
        dataModel!.add(model.data![i]);
        if (attributrIDs == "") {
          attributrIDs = model.data![i].id!.toString();
        } else {
          attributrIDs = attributrIDs + "," + model.data![i].id!.toString();
        }
      }
    }
    if (productmodel.variationsQuantity != null &&
        productmodel.variationsQuantity!.isNotEmpty) {
      print("variation availble" + dataModel!.length.toString());
      for (int k = 0; k < productmodel.variationsQuantity!.length; k++) {
        List<AddAttribute>? a = List.empty(growable: true);

        for (int i = 0; i < dataModel!.length; i++) {
          print("data availble" + dataModel![i].name!);
          if (i < productmodel.variationsQuantity![k].attributes!.length) {
            print("variation availble" +
                productmodel.variationsQuantity![k].attributes!.length
                    .toString());

            AddAttribute v = AddAttribute();
            v.attributeName = productmodel
                .variationsQuantity![k].attributes![i].attributeName;
            v.attributeValue = productmodel
                .variationsQuantity![k].attributes![i].attributeValue;
            v.attributeId =
                productmodel.variationsQuantity![k].attributes![i].attributeId;
            v.unit_id =
                productmodel.variationsQuantity![k].attributes![i].unit_id;
            v.unit_name =
                productmodel.variationsQuantity![k].attributes![i].unit_name;

            a.add(v);
          } else {
            AddAttribute v = AddAttribute();
            v.attributeName = dataModel![i].name!;
            v.attributeId = dataModel![i].id.toString();
            a.add(v);
          }
        }
        print("${a.length}");
        productmodel.variationsQuantity![k].attributes = a;
        productmodel.variationsQuantity![k].isEdit = false;
      }
      productmodel.attribute_ids = attributrIDs;
    } else {
      print("variation not availble");

      List<AddAttribute>? a = List.empty(growable: true);
      for (int i = 0; i < dataModel!.length; i++) {
        AddAttribute v = AddAttribute();
        v.attributeName = dataModel![i].name!;
        v.attributeId = dataModel![i].id.toString();

        a.add(v);
      }
      VariationsQuantity q = VariationsQuantity();
      q.attributes = a;
      q.isEdit = false;

      productmodel.attribute_ids = attributrIDs;
      variationsQuantity.add(q);
      productmodel.variationsQuantity = variationsQuantity;
    }

    setState(() {});
  }

  void attributesBottomSheet(BuildContext ctx) {
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
                                .find('attributes'),
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
                          itemCount: model.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (model.data![index].isSelected) {
                                  model.data![index].isSelected = false;
                                } else {
                                  model.data![index].isSelected = true;
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
                                        if (model.data![index].isSelected) {
                                          model.data![index].isSelected = false;
                                        } else {
                                          model.data![index].isSelected = true;
                                        }
                                        setState(() {});
                                      },
                                      child: Text(
                                        model.data![index].name!,
                                        style: Styles.boldBlack16,
                                      ),
                                    ),
                                    const Spacer(),
                                    model.data![index].isSelected == false
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

  @override
  void onFailure(message) {
    Navigator.pop(context);
  }

  @override
  void onSuccess(data) {
    Navigator.pop(context);

    model = Attributes.fromJson(data);
    if (productmodel.attribute_ids != null) {
      if (productmodel.attribute_ids!.contains(",")) {
        for (int i = 0;
            i < productmodel.attribute_ids!.split(",").length;
            i++) {
          for (int p = 0; p < model.data!.length; p++) {
            if (model.data![p].id.toString() ==
                productmodel.attribute_ids!.split(",")[i]) {
              model.data![p].isSelected = true;
              dataModel!.add(model.data![p]);
            }
          }
        }
      } else {
        for (int p = 0; p < model.data!.length; p++) {
          if (model.data![p].id.toString() == productmodel.attribute_ids!) {
            model.data![p].isSelected = true;
            dataModel!.add(model.data![p]);
          }
        }
      }
      // changeState();
      print(productmodel.attribute_ids);
    }

    setState(() {});
  }

  @override
  void onTokenExpired() {}

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        NewMarkitVendorLocalizations.of(context)!.find('save_variation_msg'),
      ),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
