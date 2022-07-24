import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:market_vendor_app/activities/create_business/add_bank_details.dart';
import 'package:market_vendor_app/activities/create_business/adhar_card_document.dart';
import 'package:market_vendor_app/activities/create_business/gst_document.dart';
import 'package:market_vendor_app/activities/create_business/pan_card_document.dart';
import 'package:market_vendor_app/activities/create_business/polic_certificate_document.dart';
import 'package:market_vendor_app/activities/create_business/working_hours.dart';
import 'package:page_transition/page_transition.dart';

import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/asset_constants.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../../utils/globals.dart' as globals;
import '../../widgets/form_submit_widget.dart';
import 'model/business_model.dart';

class DocumentPage extends StatefulWidget {
  BusinessModel model;
  DocumentPage({Key? key, required this.model}) : super(key: key);

  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  @override
  void initState() {
    super.initState();
  }

  Color disableColor = AppColors.primaryColor;

  bool isPanData = false;
  bool isGstData = false;
  bool isAdaharData = false;
  //bool isPoliceData = false;
  bool isCancelCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            top: true,
            bottom: true,
            child: Padding(
                padding: Dimens.edgeInsets20,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
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
                          .find('uploadDocuments'),
                      style: Styles.loginPageTitleBlack,
                    ),
                    Dimens.boxHeight15,
                    penCardView(),
                    Dimens.boxHeight20,
                    gstNumberView(),
                    Dimens.boxHeight20,
                    adharNumberView(),
                    // Dimens.boxHeight20,
                    // policeView(),
                    Dimens.boxHeight20,
                    checkView(),
                    Dimens.boxHeight30,
                    FormSubmitWidget(
                      opacity: 1,
                      disableColor: (isPanData &&
                              isGstData &&
                              // isPoliceData &&
                              isAdaharData &&
                              isCancelCheck)
                          ? AppColors.primaryColor
                          : AppColors.primaryColor.withOpacity(0.4),
                      padding: Dimens.edgeInsets0,
                      text: NewMarkitVendorLocalizations.of(context)!
                          .find('continueLabel'),
                      textStyle: Styles.buttonWhiteTextStyle,
                      startColor: (isPanData &&
                              isGstData &&
                              // isPoliceData &&
                              isAdaharData &&
                              isCancelCheck)
                          ? AppColors.primaryColor
                          : AppColors.primaryColor.withOpacity(0.4),
                      endColor: (isPanData &&
                              isGstData &&
                              // isPoliceData &&
                              isAdaharData &&
                              isCancelCheck)
                          ? AppColors.primaryColor
                          : AppColors.primaryColor.withOpacity(0.4),
                      iconColor: Colors.white,
                      onTap: () {
                        if (isPanData &&
                            isGstData &&
                            // isPoliceData &&
                            isAdaharData &&
                            isCancelCheck) {
                          // widget.model.policeClearanceCertificate = "0";
                          // widget.model.policeClearanceImage = "0";
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child:
                                      WorkingHoursPage(model: widget.model)));
                        }
                      },
                    ),
                    Dimens.boxHeight20,
                  ],
                ))));
  }

  penCardView() {
    return Container(
      height: 180,
      child: Stack(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.white,
            elevation: 10,
            child: isPanData == false
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(left: 16, top: 16),
                          child: Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('panCardNumber'),
                            style: Styles.lightBlue14,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 16, top: 16),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('noDocumentAddedYetDes'),
                            style: Styles.loginPageSubTitleGrey,
                          ),
                        ),
                      ],
                    ))
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        CachedNetworkImage(
                          imageUrl: widget.model.panDuplicateImage!,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 100,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            width: 100,
                            height: 100.0,
                            alignment: Alignment.center,
                            child: Container(
                              width: 40,
                              height: 40,
                              child: const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primaryColor)),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            alignment: Alignment.center,
                            width: 100,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            child: const Icon(Icons.error,
                                size: 40, color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('panCardNumber'),
                                style: Styles.lightBlue14,
                              ),
                              Text(
                                widget.model.panNumber!,
                                style: Styles.boldBlack14,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ),
          isPanData == false
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(right: 16, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: PanCardDocument(
                                model: widget.model,
                              ))).then((value) {
                        if (value != null) {
                          isPanData = true;
                          setState(() {});
                        }
                      });
                    },
                    child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.6),

                                blurRadius: 3.0, // soften the shadow
                                offset: const Offset(
                                  1.0, // Move to right 10  horizontally
                                  1.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        )),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(right: 16, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: PanCardDocument(
                                model: widget.model,
                              ))).then((value) {
                        if (value != null) {
                          isPanData = true;
                          setState(() {});
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.lightBlueColor2,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.lightBlueColor2
                                        .withOpacity(0.6),

                                    blurRadius: 3.0, // soften the shadow
                                    offset: const Offset(
                                      1.0, // Move to right 10  horizontally
                                      1.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ]),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.model.panNumber = "";
                            widget.model.panImage = "";
                            widget.model.panDuplicateImage = "";
                            isPanData = false;
                            setState(() {});
                          },
                          child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.6),
                                      blurRadius: 3.0, // soften the shadow
                                      offset: const Offset(
                                        1.0, // Move to right 10  horizontally
                                        1.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ]),
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.white,
                                size: 20,
                              )),
                        ),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }

  gstNumberView() {
    return Container(
      height: 180,
      child: Stack(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.white,
            elevation: 10,
            child: isGstData == false
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(left: 16, top: 16),
                          child: Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('gstNumber'),
                            style: Styles.lightBlue14,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 16, top: 16),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('noDocumentAddedYetDes'),
                            style: Styles.loginPageSubTitleGrey,
                          ),
                        ),
                      ],
                    ))
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        CachedNetworkImage(
                          imageUrl: widget.model.gstDuplicateImage!,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 100,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            width: 100,
                            height: 100.0,
                            alignment: Alignment.center,
                            child: Container(
                              width: 40,
                              height: 40,
                              child: const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primaryColor)),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            alignment: Alignment.center,
                            width: 100,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            child: const Icon(Icons.error,
                                size: 40, color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('gstNumber'),
                                style: Styles.lightBlue14,
                              ),
                              Text(
                                widget.model.gstNumber!,
                                style: Styles.boldBlack14,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ),
          isGstData == false
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(right: 16, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: GSTDocument(
                                model: widget.model,
                              ))).then((value) {
                        if (value != null) {
                          isGstData = true;
                          setState(() {});
                        }
                      });
                    },
                    child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.6),
                                blurRadius: 3.0, // soften the shadow
                                offset: const Offset(
                                  1.0, // Move to right 10  horizontally
                                  1.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        )),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(right: 16, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: GSTDocument(
                                model: widget.model,
                              ))).then((value) {
                        if (value != null) {
                          isGstData = true;
                          setState(() {});
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.lightBlueColor2,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.lightBlueColor2
                                        .withOpacity(0.6),

                                    blurRadius: 3.0, // soften the shadow
                                    offset: const Offset(
                                      1.0, // Move to right 10  horizontally
                                      1.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ]),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.model.gstNumber = "";
                            widget.model.gstImage = "";
                            widget.model.gstDuplicateImage = "";
                            isGstData = false;
                            setState(() {});
                          },
                          child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.6),
                                      blurRadius: 3.0, // soften the shadow
                                      offset: const Offset(
                                        1.0, // Move to right 10  horizontally
                                        1.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ]),
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.white,
                                size: 20,
                              )),
                        ),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }

  adharNumberView() {
    return Container(
      height: 180,
      child: Stack(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.white,
            elevation: 10,
            child: isAdaharData == false
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(left: 16, top: 16),
                          child: Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('aadhaarCardNumber'),
                            style: Styles.lightBlue14,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 16, top: 16),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('noDocumentAddedYetDes'),
                            style: Styles.loginPageSubTitleGrey,
                          ),
                        ),
                      ],
                    ))
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        CachedNetworkImage(
                          imageUrl: widget.model.aadhaarDuplicateImage!,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 100,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            width: 100,
                            height: 100.0,
                            alignment: Alignment.center,
                            child: Container(
                              width: 40,
                              height: 40,
                              child: const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primaryColor)),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            alignment: Alignment.center,
                            width: 100,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            child: const Icon(Icons.error,
                                size: 40, color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('aadhaarCardNumber'),
                                style: Styles.lightBlue14,
                              ),
                              Text(
                                widget.model.aadhaarNumber!,
                                style: Styles.boldBlack14,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ),
          isAdaharData == false
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(right: 16, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: AdharCardCardDocument(
                                model: widget.model,
                              ))).then((value) {
                        if (value != null) {
                          isAdaharData = true;
                          setState(() {});
                        }
                      });
                    },
                    child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.6),
                                blurRadius: 3.0, // soften the shadow
                                offset: const Offset(
                                  1.0, // Move to right 10  horizontally
                                  1.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        )),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(right: 16, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: AdharCardCardDocument(
                                model: widget.model,
                              ))).then((value) {
                        if (value != null) {
                          isAdaharData = true;
                          setState(() {});
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.lightBlueColor2,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.lightBlueColor2
                                        .withOpacity(0.6),

                                    blurRadius: 3.0, // soften the shadow
                                    offset: const Offset(
                                      1.0, // Move to right 10  horizontally
                                      1.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ]),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.model.aadhaarNumber = "";
                            widget.model.aadhaarImage = "";
                            widget.model.aadhaarDuplicateImage = "";
                            isAdaharData = false;
                            setState(() {});
                          },
                          child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.6),
                                      blurRadius: 3.0, // soften the shadow
                                      offset: const Offset(
                                        1.0, // Move to right 10  horizontally
                                        1.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ]),
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.white,
                                size: 20,
                              )),
                        ),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }

  // policeView() {
  //   return Container(
  //     height: 180,
  //     child: Stack(
  //       children: <Widget>[
  //         Card(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(15.0),
  //           ),
  //           color: Colors.white,
  //           elevation: 10,
  //           child: isPoliceData == false
  //               ? Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   height: 150,
  //                   child: Column(
  //                     children: <Widget>[
  //                       Container(
  //                         width: MediaQuery.of(context).size.width,
  //                         margin: const EdgeInsets.only(left: 16, top: 16),
  //                         child: Text(
  //                           NewMarkitVendorLocalizations.of(context)!
  //                               .find('policeClearanceCertificate'),
  //                           style: Styles.lightBlue14,
  //                         ),
  //                       ),
  //                       Container(
  //                         margin: const EdgeInsets.only(left: 16, top: 16),
  //                         width: MediaQuery.of(context).size.width,
  //                         child: Text(
  //                           NewMarkitVendorLocalizations.of(context)!
  //                               .find('noDocumentAddedYetDes'),
  //                           style: Styles.loginPageSubTitleGrey,
  //                         ),
  //                       ),
  //                     ],
  //                   ))
  //               : Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   height: 150,
  //                   child: Row(
  //                     children: [
  //                       const SizedBox(
  //                         width: 10,
  //                       ),
  //                       CachedNetworkImage(
  //                         imageUrl: widget.model.policeClearanceImage!,
  //                         imageBuilder: (context, imageProvider) => Container(
  //                           width: 100,
  //                           height: 100.0,
  //                           decoration: BoxDecoration(
  //                             shape: BoxShape.rectangle,
  //                             image: DecorationImage(
  //                               image: imageProvider,
  //                               fit: BoxFit.cover,
  //                             ),
  //                           ),
  //                         ),
  //                         placeholder: (context, url) => Container(
  //                           width: 100,
  //                           height: 100.0,
  //                           alignment: Alignment.center,
  //                           child: Container(
  //                             width: 40,
  //                             height: 40,
  //                             child: const CircularProgressIndicator(
  //                                 valueColor: AlwaysStoppedAnimation<Color>(
  //                                     AppColors.primaryColor)),
  //                           ),
  //                         ),
  //                         errorWidget: (context, url, error) => Container(
  //                           alignment: Alignment.center,
  //                           width: 100,
  //                           height: 100.0,
  //                           decoration: BoxDecoration(
  //                             color: Colors.grey[200],
  //                           ),
  //                           child: Image.asset(
  //                             "assets/images/placeholder.png",
  //                             width: 80,
  //                             height: 80,
  //                           ),
  //                         ),
  //                       ),
  //                       Expanded(
  //                         flex: 1,
  //                         child: Column(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             Text(
  //                               NewMarkitVendorLocalizations.of(context)!
  //                                   .find('policeClearanceCertificate'),
  //                               style: Styles.lightBlue14,
  //                             ),
  //                             Text(
  //                               widget.model.policeClearanceCertificate!,
  //                               style: Styles.boldBlack14,
  //                             ),
  //                           ],
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //         ),
  //         isPoliceData == false
  //             ? Container(
  //                 width: MediaQuery.of(context).size.width,
  //                 alignment: Alignment.bottomRight,
  //                 margin: const EdgeInsets.only(right: 16, bottom: 10),
  //                 child: InkWell(
  //                   onTap: () {
  //                     Navigator.push(
  //                         context,
  //                         PageTransition(
  //                             type: PageTransitionType.fade,
  //                             child: PoliceCertificateDocument(
  //                               model: widget.model,
  //                             ))).then((value) {
  //                       if (value != null) {
  //                         isPoliceData = true;
  //                         setState(() {});
  //                       }
  //                     });
  //                   },
  //                   child: Container(
  //                       width: 40,
  //                       height: 40,
  //                       decoration: BoxDecoration(
  //                           shape: BoxShape.circle,
  //                           color: AppColors.primaryColor,
  //                           boxShadow: [
  //                             BoxShadow(
  //                               color: AppColors.primaryColor.withOpacity(0.6),
  //                               blurRadius: 3.0, // soften the shadow
  //                               offset: const Offset(
  //                                 1.0, // Move to right 10  horizontally
  //                                 1.0, // Move to bottom 10 Vertically
  //                               ),
  //                             )
  //                           ]),
  //                       child: const Icon(
  //                         Icons.add,
  //                         color: Colors.white,
  //                         size: 20,
  //                       )),
  //                 ),
  //               )
  //             : Container(
  //                 width: MediaQuery.of(context).size.width,
  //                 alignment: Alignment.bottomRight,
  //                 margin: const EdgeInsets.only(right: 16, bottom: 10),
  //                 child: InkWell(
  //                   onTap: () {
  //                     Navigator.push(
  //                         context,
  //                         PageTransition(
  //                             type: PageTransitionType.fade,
  //                             child: PoliceCertificateDocument(
  //                               model: widget.model,
  //                             ))).then((value) {
  //                       if (value != null) {
  //                         isPoliceData = true;
  //                         setState(() {});
  //                       }
  //                     });
  //                   },
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       Container(
  //                           width: 40,
  //                           height: 40,
  //                           decoration: BoxDecoration(
  //                               shape: BoxShape.circle,
  //                               color: AppColors.lightBlueColor2,
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: AppColors.lightBlueColor2
  //                                       .withOpacity(0.6),

  //                                   blurRadius: 3.0, // soften the shadow
  //                                   offset: const Offset(
  //                                     1.0, // Move to right 10  horizontally
  //                                     1.0, // Move to bottom 10 Vertically
  //                                   ),
  //                                 )
  //                               ]),
  //                           child: const Icon(
  //                             Icons.edit,
  //                             color: Colors.white,
  //                             size: 20,
  //                           )),
  //                       const SizedBox(
  //                         width: 10,
  //                       ),
  //                       GestureDetector(
  //                         onTap: () {
  //                           widget.model.policeClearanceCertificate = "";
  //                           widget.model.policeClearanceImage = "";
  //                           isPoliceData = false;
  //                           setState(() {});
  //                         },
  //                         child: Container(
  //                             width: 40,
  //                             height: 40,
  //                             decoration: BoxDecoration(
  //                                 shape: BoxShape.circle,
  //                                 color: AppColors.primaryColor,
  //                                 boxShadow: [
  //                                   BoxShadow(
  //                                     color: AppColors.primaryColor
  //                                         .withOpacity(0.6),
  //                                     blurRadius: 3.0, // soften the shadow
  //                                     offset: const Offset(
  //                                       1.0, // Move to right 10  horizontally
  //                                       1.0, // Move to bottom 10 Vertically
  //                                     ),
  //                                   )
  //                                 ]),
  //                             child: const Icon(
  //                               Icons.cancel,
  //                               color: Colors.white,
  //                               size: 20,
  //                             )),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               )
  //       ],
  //     ),
  //   );
  // }

  checkView() {
    return Container(
      height: 180,
      child: Stack(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.white,
            elevation: 10,
            child: isCancelCheck == false
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(left: 16, top: 16),
                          child: Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('cancelledCheque'),
                            style: Styles.lightBlue14,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 16, top: 16),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('noDocumentAddedYetDes'),
                            style: Styles.loginPageSubTitleGrey,
                          ),
                        ),
                      ],
                    ))
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        CachedNetworkImage(
                          imageUrl: widget.model.cancelledDuplicateChequeImage!,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 100,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            width: 100,
                            height: 100.0,
                            alignment: Alignment.center,
                            child: Container(
                              width: 40,
                              height: 40,
                              child: const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primaryColor)),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            alignment: Alignment.center,
                            width: 100,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            child: const Icon(Icons.error,
                                size: 40, color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('cancelledCheque'),
                                style: Styles.lightBlue14,
                              ),
                              Text(
                                widget.model.cancelledChequeNumber!,
                                style: Styles.boldBlack14,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ),
          isCancelCheck == false
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(right: 16, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: AddBankDetails(
                                model: widget.model,
                              ))).then((value) {
                        if (value != null) {
                          isCancelCheck = true;
                          setState(() {});
                        }
                      });
                    },
                    child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.6),
                                blurRadius: 3.0, // soften the shadow
                                offset: const Offset(
                                  1.0, // Move to right 10  horizontally
                                  1.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        )),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(right: 16, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: AddBankDetails(
                                model: widget.model,
                              ))).then((value) {
                        if (value != null) {
                          isCancelCheck = true;
                          setState(() {});
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.lightBlueColor2,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.lightBlueColor2
                                        .withOpacity(0.6),

                                    blurRadius: 3.0, // soften the shadow
                                    offset: const Offset(
                                      1.0, // Move to right 10  horizontally
                                      1.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ]),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.model.cancelledChequeImage = "";
                            widget.model.cancelledDuplicateChequeImage = "";
                            widget.model.bankName = "";
                            widget.model.bankAccount = "";
                            widget.model.accountHolderName = "";
                            widget.model.ifscCode = "";

                            isCancelCheck = false;
                            setState(() {});
                          },
                          child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.6),
                                      blurRadius: 3.0, // soften the shadow
                                      offset: const Offset(
                                        1.0, // Move to right 10  horizontally
                                        1.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ]),
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.white,
                                size: 20,
                              )),
                        ),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
