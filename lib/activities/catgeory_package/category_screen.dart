import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/catgeory_package/model/CategoryModel.dart';
import 'package:market_vendor_app/activities/catgeory_package/sub_category_screen.dart';
import 'package:market_vendor_app/activities/home_page/model/HomeModel.dart';

import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/theme/app_colors.dart';
import 'package:market_vendor_app/utils/new_market_vendor_localizations.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

import '../../../apiservice/api_call.dart';

import '../../../theme/styles.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    implements ApiInterface {
  var token;
  CategoryModel model = CategoryModel();
  List<Category> list = [];

  List<Category> searchData = [];

  bool isLoader = true;

  bool isSearching = false;
  String searchText = "";
  TextEditingController searchController = TextEditingController(text: "");

  @override
  void initState() {
    getToken();

    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          searchText = "";
          _buildSearchList();
        });
      } else {
        setState(() {
          searchText = searchController.text;
          _buildSearchList();
        });
      }
    });

    super.initState();
  }

  List<Category> _buildSearchList() {
    if (searchText.isEmpty) {
      return searchData =
          list; //_list.map((contact) =>  Uiitem(contact)).toList();
    } else {
      searchData = list
          .where((element) =>
              element.name!.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
      return searchData; //_searchList.map((contact) =>  Uiitem(contact)).toList();
    }
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;

      ApiCall.getCategoryList(token, this, context);
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
                            onChanged: (v) {},
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
                                : searchData.isNotEmpty
                                    ? Container(
                                        child: GridView.count(
                                          // Create a grid with 2 columns. If you change the scrollDirection to
                                          // horizontal, this produces 2 rows.
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 20,
                                          // width / height: fixed for *all* items
                                          childAspectRatio: 1.25,

                                          // Generate 100 widgets that display their index in the List.
                                          children: List.generate(
                                              searchData.length, (index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .fade,
                                                        child:
                                                            SubCategoryScreen(
                                                          id: searchData[index]
                                                              .id
                                                              .toString(),
                                                          name:
                                                              searchData[index]
                                                                  .name!,
                                                        )));
                                              },
                                              child: Center(
                                                child: Container(
                                                  child: Stack(
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl:
                                                            searchData[index]
                                                                .thumbnailUrl!,
                                                        imageBuilder: (context,
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
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        placeholder:
                                                            (context, url) =>
                                                                Container(
                                                          height: 120.0,
                                                          alignment:
                                                              Alignment.center,
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
                                                          alignment:
                                                              Alignment.center,
                                                          height: 120,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[200],
                                                          ),
                                                          child: const Icon(
                                                            Icons.error,
                                                            color: Colors.black,
                                                            size: 40,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                          height: 120,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                          ),
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 10),
                                                          child: Text(
                                                            searchData[index]
                                                                .name!,
                                                            textAlign: TextAlign
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
                                                .find('noCategoryFound'),
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
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('categories'),
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
    model = CategoryModel.fromJson(data);
    list = model.data!;
    _buildSearchList();

    print(model.data!.length);

    setState(() {
      isLoader = false;
    });
  }

  @override
  void onTokenExpired() {
    // TODO: implement onTokenExpired
  }
}
