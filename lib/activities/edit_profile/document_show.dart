import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:market_vendor_app/activities/edit_profile/edit_bank_details.dart';
import 'package:page_transition/page_transition.dart';

import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/image_zoom.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../../utils/shared_preferences.dart';
import '../home_page/model/profile_model.dart';

class DocumentView extends StatefulWidget {
  DocumentView({Key? key}) : super(key: key);
  @override
  State<DocumentView> createState() {
    return _DocumentViewView();
  }
}

class _DocumentViewView extends State<DocumentView> {
  var profileData;
  ProfileModel model = ProfileModel();
  @override
  void initState() {
    super.initState();
    SharedPref.getProfileData().then((value) {
      profileData = json.decode(value);
      model = ProfileModel.fromJson(profileData);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                  NewMarkitVendorLocalizations.of(context)!
                                      .find('myDocument'),
                                  style: Styles.boldBlack16,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Dimens.boxHeight30,
                      Expanded(
                        flex: 1,
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: model.data == null
                                ? 0
                                : model.data!.documents!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (model.data!.documents![index].name ==
                                        "CANCELLED CHEQUE IMAGE") {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.fade,
                                              child: EditBankDetails(
                                                model: model,
                                              ))).then((value) {
                                        SharedPref.getProfileData()
                                            .then((value) {
                                          profileData = json.decode(value);
                                          model = ProfileModel.fromJson(
                                              profileData);

                                          setState(() {});
                                        });
                                      });
                                    } else {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.fade,
                                              child: ImageZoomView(
                                                url: model.data!
                                                    .documents![index].image,
                                              )));
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 1,
                                            color: AppColors.menuTextColor
                                                .withOpacity(0.4)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 5.0,
                                          ),
                                        ]),
                                    padding: const EdgeInsets.all(8),
                                    width: double.infinity,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: model
                                                .data!.documents![index].image!,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: Dimens.sixty,
                                              height: Dimens.sixty,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                Container(
                                              width: Dimens.sixty,
                                              height: Dimens.sixty,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Container(
                                                width: 40,
                                                height: 40,
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
                                              width: Dimens.sixty,
                                              height: Dimens.sixty,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: const Icon(
                                                Icons.error,
                                                size: 20,
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
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  model.data!.documents![index]
                                                      .name!
                                                      .replaceAll("IMAGE", ""),
                                                  style:
                                                      Styles.mediumDarkGreen14,
                                                ),
                                                model.data!.documents![index]
                                                            .number!.length <
                                                        2
                                                    ? Container()
                                                    : const SizedBox(
                                                        height: 5,
                                                      ),
                                                model.data!.documents![index]
                                                            .number!.length <
                                                        3
                                                    ? Container()
                                                    : Text(
                                                        model
                                                            .data!
                                                            .documents![index]
                                                            .number!,
                                                        style:
                                                            Styles.boldBlack16,
                                                      ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "View full image",
                                                  style: Styles.redLight14,
                                                ),
                                              ],
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
