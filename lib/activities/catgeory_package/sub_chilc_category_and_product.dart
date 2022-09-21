import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/catgeory_package/all_sub_child_category.dart';
import 'package:market_vendor_app/activities/catgeory_package/model/SubCategoryModel.dart';
import 'package:market_vendor_app/activities/catgeory_package/model/SubChildCategoryWithProductModel.dart';
import 'package:market_vendor_app/activities/catgeory_package/view_all_product_according_to_category.dart';

import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/theme/app_colors.dart';
import 'package:market_vendor_app/utils/new_market_vendor_localizations.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

import '../../../apiservice/api_call.dart';

import '../../../theme/styles.dart';
import '../../theme/dimens.dart';
import '../../utils/strings/app_constants.dart';
import '../home_page/view_all_prodcut.dart';
import '../product_details/product_info.dart';

class SubChildCategoryAndProductScreen extends StatefulWidget {
  String? id;
  String? subId;
  String? name;

  SubChildCategoryAndProductScreen({Key? key, this.id, this.subId, this.name})
      : super(key: key);
  @override
  _SubChildCategoryAndProductScreenState createState() =>
      _SubChildCategoryAndProductScreenState();
}

class _SubChildCategoryAndProductScreenState
    extends State<SubChildCategoryAndProductScreen> implements ApiInterface {
  var token;
  SubChildCategoryWithProductModel model = SubChildCategoryWithProductModel();
  bool isLoader = true;

  @override
  void initState() {
    getToken();

    super.initState();
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
      print(widget.id! + " " + widget.subId!);

      ApiCall.getVendorChilSubCategoryList(
          widget.id!, widget.subId!, token, this, context);
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
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 70),
                    child: SingleChildScrollView(
                      child: isLoader
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 2,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            )
                          : Column(
                              children: [
                                model.childCategories!.isNotEmpty
                                    ? Container(
                                        margin: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  NewMarkitVendorLocalizations
                                                          .of(context)!
                                                      .find(
                                                          'subCategoryProduct'),
                                                  style: Styles.boldBlack16,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .fade,
                                                            child:
                                                                AllSubChildCategoryScreen(
                                                              id: widget.id,
                                                              subId:
                                                                  widget.subId!,
                                                              name:
                                                                  widget.name!,
                                                            )));
                                                  },
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        NewMarkitVendorLocalizations
                                                                .of(context)!
                                                            .find('viewAll'),
                                                        style:
                                                            Styles.redMedium14,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              child: GridView.count(
                                                // Create a grid with 2 columns. If you change the scrollDirection to
                                                // horizontal, this produces 2 rows.
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 20,
                                                // width / height: fixed for *all* items
                                                childAspectRatio: 1.25,
                                                // Generate 100 widgets that
                                                // Generate 100 widgets that display their index in the List.
                                                children: List.generate(
                                                    model.childCategories!
                                                                .length >
                                                            6
                                                        ? 6
                                                        : model.childCategories!
                                                            .length, (index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          PageTransition(
                                                              type:
                                                                  PageTransitionType
                                                                      .fade,
                                                              child:
                                                                  ViewAllProductAccToCategoryScreen(
                                                                categoryId:
                                                                    widget.id,
                                                                subCategoryId:
                                                                    widget
                                                                        .subId,
                                                                childCategoryId: model
                                                                    .childCategories![
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                              )));
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        child: Stack(
                                                          children: [
                                                            CachedNetworkImage(
                                                              imageUrl: model
                                                                  .childCategories![
                                                                      index]
                                                                  .thumbnailUrl!,
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                height: 120.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              placeholder:
                                                                  (context,
                                                                          url) =>
                                                                      Container(
                                                                height: 120.0,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    Container(
                                                                  width: 40,
                                                                  height: 40,
                                                                  child: const CircularProgressIndicator(
                                                                      valueColor: AlwaysStoppedAnimation<
                                                                              Color>(
                                                                          AppColors
                                                                              .primaryColor)),
                                                                ),
                                                              ),
                                                              errorWidget:
                                                                  (context, url,
                                                                          error) =>
                                                                      Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 120,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                          .grey[
                                                                      200],
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons.error,
                                                                  size: 40,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                                height: 120,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.2),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            10),
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                child: Text(
                                                                  model
                                                                      .childCategories![
                                                                          index]
                                                                      .name!,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: Styles
                                                                      .boldWhite16,
                                                                  maxLines: 2,
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  height: Dimens.sixTeen,
                                ),
                                model.products!.isNotEmpty
                                    ? Container(
                                        margin: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  NewMarkitVendorLocalizations
                                                          .of(context)!
                                                      .find('categoryProduct'),
                                                  style: Styles.boldBlack16,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .fade,
                                                            child:
                                                                ViewAllProductAccToCategoryScreen(
                                                              categoryId:
                                                                  widget.id,
                                                              subCategoryId:
                                                                  widget.subId,
                                                            ))).then((value) {
                                                      if (value != null) {
                                                        ApiCall.getHomeDataApi(
                                                            token,
                                                            this,
                                                            context);
                                                      }
                                                    });
                                                  },
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        NewMarkitVendorLocalizations
                                                                .of(context)!
                                                            .find('viewAll'),
                                                        style:
                                                            Styles.redMedium14,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            GridView.count(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              // Create a grid with 2 columns. If you change the scrollDirection to
                                              // horizontal, this produces 2 rows.
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 5,
                                              // Generate 100 widgets that display their index in the List.
                                              children: List.generate(
                                                  model.products!.length > 4
                                                      ? 4
                                                      : model.products!.length,
                                                  (index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .fade,
                                                            child:
                                                                ProductInfoScreen(
                                                              data: model
                                                                      .products![
                                                                  index],
                                                            ))).then((value) {
                                                      if (value != null) {}
                                                    });
                                                  },
                                                  child: Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        CachedNetworkImage(
                                                          imageUrl: model
                                                              .products![
                                                                  index]
                                                              .default_image!,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            height: 80.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder:
                                                              (context,
                                                                      url) =>
                                                                  Container(
                                                            height: 80.0,
                                                            alignment:
                                                                Alignment
                                                                    .center,
                                                            child: Container(
                                                              width: 40,
                                                              height: 40,
                                                              child: const CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      AppColors
                                                                          .primaryColor)),
                                                            ),
                                                          ),
                                                          errorWidget:
                                                              (context, url,
                                                                      error) =>
                                                                  Container(
                                                            alignment:
                                                                Alignment
                                                                    .center,
                                                            height: 80,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .grey[200],
                                                            ),
                                                            child: const Icon(
                                                              Icons.error,
                                                              size: 40,
                                                              color: Colors
                                                                  .black,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              model
                                                                  .products![
                                                                      index]
                                                                  .name!,
                                                              style: Styles
                                                                  .boldBlack14,
                                                              maxLines: 2),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                AppConstants
                                                                        .priceSign +
                                                                    model
                                                                        .products![
                                                                            index]
                                                                        .variations![
                                                                            0]
                                                                        .offerPrice!
                                                                        .toString(),
                                                                style: Styles
                                                                    .boldBlack14),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                                AppConstants
                                                                        .priceSign +
                                                                    model
                                                                        .products![
                                                                            index]
                                                                        .variations![
                                                                            0]
                                                                        .basicPrice!
                                                                        .toString(),
                                                                style: Styles
                                                                    .pricestrickTitle12Grey),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.star,
                                                              color: AppColors
                                                                  .yellowColor,
                                                              size: 20,
                                                            ),
                                                            Text(
                                                                "${model.products![index].product_rating}",
                                                                style: Styles
                                                                    .yellowMedium12),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    width: Get.width,
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
                              widget.name!,
                              style: Styles.boldBlack16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onFailure(message) {
    setState(() {
      isLoader = false;
    });
  }

  @override
  void onSuccess(data) {
    model = SubChildCategoryWithProductModel.fromJson(data);

    setState(() {
      isLoader = false;
    });
  }

  @override
  void onTokenExpired() {
    // TODO: implement onTokenExpired
  }
}
