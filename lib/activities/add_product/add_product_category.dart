import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:market_vendor_app/activities/add_product/model/product_category.dart';
import 'package:market_vendor_app/activities/add_product/model/product_child_category.dart';
import 'package:market_vendor_app/activities/add_product/product_informations.dart';
import 'package:market_vendor_app/activities/login/login_view.dart';
import 'package:market_vendor_app/apiservice/api_call.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import 'package:market_vendor_app/utils/new_market_vendor_localizations.dart';

import '../../utils/asset_constants.dart';
import '../../utils/utility.dart';
import '../../widgets/form_submit_widget.dart';
import 'model/addproduct.dart';

class AddProductCategoryScreen extends StatefulWidget {
  @override
  _AddProductCategoryScreenState createState() =>
      _AddProductCategoryScreenState();
}

class _AddProductCategoryScreenState extends State<AddProductCategoryScreen>
    implements ApiInterface {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController categoryController = TextEditingController(text: "");
  TextEditingController parentCatgoryController =
      TextEditingController(text: "");
  TextEditingController parentSubCatgoryController =
      TextEditingController(text: "");

  ProductCategory model = ProductCategory();
  ProductChildCategory childModel = ProductChildCategory();

  List<SubCategory> subCategory = [];
  AddProductModel addProductModel = AddProductModel();

  var token;
  String whichApiCall = "category";
  var categoryPostion, parentPostion, subPostion;
  @override
  void initState() {
    super.initState();
    getToken();
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
      whichApiCall = "category";
      Utility.dialogLoader(context);

      ApiCall.getCategoryList(token, this, context);
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          .find('choose_product_category'),
                      style: Styles.loginPageTitleBlack,
                    ),
                    Dimens.boxHeight15,
                    Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('please_choose_product_category'),
                        style: Styles.loginPageSubTitleGrey),
                    Form(
                      key: formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Dimens.boxHeight20,
                          categoryTextFormFiled(),
                          Dimens.boxHeight20,
                          parentCategoryTextFormFiled(),
                          Dimens.boxHeight20,
                        ],
                      ),
                    ),
                    parentSubCategoryTextFormFiled(),
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
                        _validateInput();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _validateInput() {
    if (formkey.currentState!.validate()) {
      Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: ProductInformationsScreen(model: addProductModel)))
          .then((value) {
        if (value != null) {
          Navigator.pop(context);
        }
      });
    }
  }

  categoryTextFormFiled() {
    return TextFormField(
      readOnly: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: categoryController,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => Utility.selectCategoryFiledValid(v!, context),
      onTap: () {
        categoryBottomSheet(context);
      },
      decoration: InputDecoration(
          labelText: NewMarkitVendorLocalizations.of(context)!.find('category'),
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

  addInCategoryView(int i) {
    whichApiCall = "parent_category";
    categoryPostion = i;
    categoryController.text = model.data![categoryPostion].name!;
    addProductModel.categoryId = model.data![categoryPostion].id.toString();
    addProductModel.categoryName = model.data![categoryPostion].name!;
    Utility.dialogLoader(context);

    ApiCall.getSubCategoryList(
        model.data![categoryPostion].id.toString(), token, this, context);

    setState(() {});
  }

  addParentCategoryView(int i) {
    parentPostion = i;
    parentCatgoryController.text = childModel.data![parentPostion].name!;
    addProductModel.subCategoryId =
        childModel.data![parentPostion].id.toString();
    addProductModel.subCategoryName = childModel.data![parentPostion].name!;

    subCategory = childModel.data![parentPostion].subCategory!;
    setState(() {});
  }

  addSubCategoryView(int i) {
    subPostion = i;
    parentSubCatgoryController.text = subCategory[subPostion].name!;
    addProductModel.childCategoryId = subCategory[subPostion].id.toString();
    addProductModel.childCategoryName = subCategory[subPostion].name!;

    setState(() {});
  }

  void categoryBottomSheet(BuildContext ctx) {
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
                                .find('category'),
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
                                addInCategoryView(index);
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
                                        Navigator.pop(context);

                                        addInCategoryView(index);
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

  void parentCategoryBottomSheet(BuildContext ctx) {
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
                                .find('parent_category'),
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
                          itemCount: childModel.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                addParentCategoryView(index);
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
                                        addParentCategoryView(index);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        childModel.data![index].name!,
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

  void subCategoryBottomSheet(BuildContext ctx) {
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
                                .find('sub_category'),
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
                          itemCount: subCategory.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                addSubCategoryView(index);
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
                                        addSubCategoryView(index);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        subCategory[index].name!,
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

  parentCategoryTextFormFiled() {
    return TextFormField(
      readOnly: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: parentCatgoryController,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      onTap: () {
        if (childModel.data != null) {
          parentCategoryBottomSheet(context);
        } else {
          Utility.errorMessage(
              NewMarkitVendorLocalizations.of(context)!
                  .find('error_first_category_msg'),
              context);
        }
      },
      validator: (v) => Utility.selectParentCategoryFiledValid(v!, context),
      decoration: InputDecoration(
          labelText:
              NewMarkitVendorLocalizations.of(context)!.find('parent_category'),
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

  parentSubCategoryTextFormFiled() {
    return TextFormField(
      readOnly: true,
      controller: parentSubCatgoryController,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      onTap: () {
        if (subCategory.isNotEmpty) {
          subCategoryBottomSheet(context);
        } else {
          Utility.errorMessage(
              NewMarkitVendorLocalizations.of(context)!
                  .find('error_first_parent_category_msg'),
              context);
        }
      },
      validator: (v) => Utility.selectSubCategoryFiledValid(v!, context),
      decoration: InputDecoration(
          labelText:
              NewMarkitVendorLocalizations.of(context)!.find('sub_category'),
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

  @override
  void onFailure(message) {
    Navigator.pop(context);

    Utility.errorMessage(message, context);
  }

  @override
  void onSuccess(data) {
    Navigator.pop(context);
    if (whichApiCall == "category") {
      model = ProductCategory.fromJson(data);
      setState(() {});
    } else {
      childModel = ProductChildCategory.fromJson(data);
      setState(() {});
    }
  }

  @override
  void onTokenExpired() {}
}
