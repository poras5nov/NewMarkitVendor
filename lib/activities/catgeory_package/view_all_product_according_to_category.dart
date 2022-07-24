import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/theme/app_colors.dart';
import 'package:market_vendor_app/utils/new_market_vendor_localizations.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

import '../../../apiservice/api_call.dart';

import '../../../theme/styles.dart';
import '../../utils/strings/app_constants.dart';
import '../home_page/model/HomeModel.dart';
import '../product_details/product_info.dart';
import 'model/category_product_model.dart';

class ViewAllProductAccToCategoryScreen extends StatefulWidget {
  String? categoryId;
  String? subCategoryId;
  String? childCategoryId;

  ViewAllProductAccToCategoryScreen(
      {Key? key, this.categoryId, this.subCategoryId, this.childCategoryId})
      : super(key: key);

  @override
  _ViewAllProductAccToCategoryScreenState createState() =>
      _ViewAllProductAccToCategoryScreenState();
}

class _ViewAllProductAccToCategoryScreenState
    extends State<ViewAllProductAccToCategoryScreen> implements ApiInterface {
  var token;
  CategoryProductModel model = CategoryProductModel();
  List<ProductData> dataModel = [];

  bool isLoader = true;
  String searchTxt = "";
  int page = 1;
  var scrollcontroller = ScrollController();
  TextEditingController searchController = TextEditingController();

  bool isBottomLoader = false;
  @override
  void initState() {
    getToken();
    scrollcontroller.addListener(pagination);

    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent) &&
        (dataModel.length < model.products!.total!)) {
      setState(() {
        isBottomLoader = true;
        page += 1;
        ApiCall.allProductwithCaterory(
            widget.categoryId!,
            widget.subCategoryId!,
            widget.childCategoryId == null ? "" : widget.childCategoryId!,
            searchController.text,
            page.toString(),
            token,
            this,
            context);
        //add api for load the more data according to new page
      });
    }
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;

      ApiCall.allProductwithCaterory(
          widget.categoryId!,
          widget.subCategoryId!,
          widget.childCategoryId == null ? "" : widget.childCategoryId!,
          searchController.text,
          page.toString(),
          token,
          this,
          context);
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
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 16, right: 16),
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: searchController,
                            onChanged: (v) {
                              searchTxt = v;
                              page = 1;
                              if (dataModel.isNotEmpty) {
                                dataModel.clear();
                              }

                              ApiCall.allProductwithCaterory(
                                  widget.categoryId!,
                                  widget.subCategoryId!,
                                  widget.childCategoryId == null
                                      ? ""
                                      : widget.childCategoryId!,
                                  searchController.text,
                                  page.toString(),
                                  token,
                                  this,
                                  context);
                            },
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 24,
                                  color: Colors.black,
                                ),
                                hintText: "Search",
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.black),
                                contentPadding: EdgeInsets.only(
                                    top: 4, bottom: 6, right: 5)),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Expanded(
                          flex: 1,
                          child: isLoader
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              : dataModel.isNotEmpty
                                  ? Container(
                                      margin: const EdgeInsets.only(
                                          left: 16, right: 16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GridView.count(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            // Create a grid with 2 columns. If you change the scrollDirection to
                                            // horizontal, this produces 2 rows.
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 10,
                                            // Generate 100 widgets that display their index in the List.
                                            children: List.generate(
                                                dataModel.length, (index) {
                                              return Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .fade,
                                                            child:
                                                                ProductInfoScreen(
                                                              data: dataModel[
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
                                                          imageUrl: dataModel[
                                                                  index]
                                                              .default_image!,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            height: 90.0,
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
                                                              (context, url) =>
                                                                  Container(
                                                            height: 90.0,
                                                            alignment: Alignment
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
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 90,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .grey[200],
                                                            ),
                                                            child: const Icon(
                                                              Icons.error,
                                                              size: 40,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              dataModel[index]
                                                                  .name!,
                                                              style: Styles
                                                                  .boldBlack16),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                AppConstants
                                                                        .priceSign +
                                                                    dataModel[
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
                                                                    dataModel[
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
                                                            Text("4.5",
                                                                style: Styles
                                                                    .yellowMedium12),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                          isBottomLoader
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 50,
                                                  alignment: Alignment.center,
                                                  child:
                                                      const CircularProgressIndicator(
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      child: Center(
                                        child: Text(
                                          NewMarkitVendorLocalizations.of(
                                                  context)!
                                              .find('noProductFound'),
                                          style: Styles.boldBlack16,
                                        ),
                                      )),
                        )
                      ],
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
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('products'),
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
    model = CategoryProductModel.fromJson(data);
    if (isBottomLoader) {
      dataModel.addAll(model.products!.data!);
    } else {
      dataModel = model.products!.data!;
    }

    setState(() {
      isLoader = false;
      isBottomLoader = false;
    });
  }

  @override
  void onTokenExpired() {
    // TODO: implement onTokenExpired
  }
}
