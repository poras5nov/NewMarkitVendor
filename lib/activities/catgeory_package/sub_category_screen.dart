import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/catgeory_package/model/SubCategoryModel.dart';
import 'package:market_vendor_app/activities/catgeory_package/model/SubChildCategoryWithProductModel.dart';
import 'package:market_vendor_app/activities/catgeory_package/sub_chilc_category_and_product.dart';

import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/theme/app_colors.dart';
import 'package:market_vendor_app/utils/new_market_vendor_localizations.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

import '../../../apiservice/api_call.dart';

import '../../../theme/styles.dart';

class SubCategoryScreen extends StatefulWidget {
  String? id;
  String? name;

  SubCategoryScreen({Key? key, this.id, this.name}) : super(key: key);
  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen>
    implements ApiInterface {
  var token;
  SubCategoryModel model = SubCategoryModel();
  List<Data> dataModel = [];
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
    if (isBottomLoader == false) {
      if (scrollcontroller.position.pixels ==
          scrollcontroller.position.maxScrollExtent) {
        print(dataModel.length);
        if (dataModel.length < model.data!.total!) {
          setState(() {
            isBottomLoader = true;
            page = page + 1;
            ApiCall.getSubCategoryWithPageList(
                widget.id!, searchTxt, page.toString(), token, this, context);
            //add api for load the more data according to new page
          });
        }
      }
    }
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;

      ApiCall.getSubCategoryWithPageList(
          widget.id!, searchTxt, page.toString(), token, this, context);
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
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(left: 16, right: 16),
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

                              ApiCall.getSubCategoryWithPageList(
                                  widget.id!,
                                  searchTxt,
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
                          child: Container(
                            margin: const EdgeInsets.only(left: 16, right: 16),
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
                                    ? Column(
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: GridView.count(
                                                  controller: scrollcontroller,

                                                  // Create a grid with 2 columns. If you change the scrollDirection to
                                                  // horizontal, this produces 2 rows.
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 20,
                                                  // width / height: fixed for *all* items
                                                  childAspectRatio: 1.25,
                                                  // Generate 100 widgets that display their index in the List.
                                                  children: List.generate(
                                                      dataModel.length,
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
                                                                    SubChildCategoryAndProductScreen(
                                                                  id: widget.id,
                                                                  subId: dataModel[
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                                  name: dataModel[
                                                                          index]
                                                                      .name!,
                                                                )));
                                                      },
                                                      child: Center(
                                                        child: Container(
                                                          child: Stack(
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl: dataModel[
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
                                                                        valueColor:
                                                                            AlwaysStoppedAnimation<Color>(AppColors.primaryColor)),
                                                                  ),
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
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
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          10),
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomCenter,
                                                                  child: Text(
                                                                    dataModel[
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
                                              )),
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
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2,
                                        child: Center(
                                          child: Text(
                                            NewMarkitVendorLocalizations.of(
                                                    context)!
                                                .find('noSubCategoryFound'),
                                            style: Styles.boldBlack16,
                                          ),
                                        )),
                          ),
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
      isBottomLoader = false;
    });
  }

  @override
  void onSuccess(data) {
    model = SubCategoryModel.fromJson(data);
    if (isBottomLoader) {
      dataModel.addAll(model.data!.data!);
    } else {
      dataModel = model.data!.data!;
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
