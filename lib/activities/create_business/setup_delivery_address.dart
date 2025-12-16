import 'package:flutter/material.dart';
import 'package:market_vendor_app/activities/create_business/success_screen.dart';
import 'package:market_vendor_app/apiservice/api_call.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:page_transition/page_transition.dart';

import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../../utils/shared_preferences.dart';
import '../../utils/utility.dart';
import '../../widgets/form_submit_widget.dart';
import 'model/business_model.dart';

class SetUpdeliveryAddress extends StatefulWidget {
  BusinessModel model;
  SetUpdeliveryAddress({Key? key, required this.model}) : super(key: key);
  @override
  _SetUpdeliveryAddressState createState() => _SetUpdeliveryAddressState();
}

class _SetUpdeliveryAddressState extends State<SetUpdeliveryAddress>
    implements ApiInterface {
  bool isLoader = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isChecked = false;

  TextEditingController sharedController = TextEditingController(text: "0");
  TextEditingController freeController = TextEditingController(text: "0");
  var token;
  @override
  void initState() {
    super.initState();
    getToken();
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              top: true,
              bottom: true,
              child: Padding(
                padding: Dimens.edgeInsets20,
                child: Form(
                  key: formkey,
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
                            .find('setupDeliveryDetails'),
                        style: Styles.loginPageTitleBlack,
                      ),
                      Dimens.boxHeight15,
                      Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('enterDeliveryCharges'),
                        style: Styles.loginPageSubTitleGrey,
                      ),
                      Dimens.boxHeight20,
                      Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('sharedDelivery'),
                        style: Styles.lightBlue14,
                      ),
                      Dimens.boxHeight10,
                      Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('minimumOrderAmountSharedDeliveryDes'),
                        style: Styles.loginPageSubTitleGrey,
                      ),
                      sharedTextFormFiled(),
                      Dimens.boxHeight20,
                      Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('freeDelivery'),
                        style: Styles.lightBlue14,
                      ),
                      Dimens.boxHeight10,
                      Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('minimumOrderAmountFreeDeliveryDes'),
                        style: Styles.loginPageSubTitleGrey,
                      ),
                      freeFormFiled(),
                      Dimens.boxHeight20,
                      Row(children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (v) {
                            isChecked = v!;
                            setState(() {
                              sharedController.text = "0";
                              freeController.text = "0";
                            });
                          },
                          activeColor: AppColors.primaryColor,
                        ),
                        Flexible(
                          flex: 1,
                          child: Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('weWillNotShareDeliveryCharges'),
                            style: Styles.lightBlue14,
                            maxLines: 2,
                          ),
                        ),
                      ]),
                      Dimens.boxHeight30,
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
                                validateInput();
                              },
                            )
                    ],
                  ),
                ),
              ))),
    );
  }

  validateInput() {
    if (formkey.currentState!.validate()) {
      widget.model.sharedDelivery = sharedController.text;
      widget.model.freeDelivery = freeController.text;
      widget.model.longitude = "70.45";
      widget.model.latitude = "37.45";

      setState(() {
        isLoader = true;
      });
      ApiCall.createBusinessApi(widget.model, token, this, context);
    }
  }

  sharedTextFormFiled() {
    return TextFormField(
      controller: sharedController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: const InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  freeFormFiled() {
    return TextFormField(
      controller: freeController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: const InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  @override
  void onFailure(message) {
    Utility.errorMessage(message, context);

    setState(() {
      isLoader = false;
    });
  }

  @override
  void onSuccess(data) {
    setState(() {
      isLoader = false;
    });
    Utility.successMessage(data['message'], context);
    Utility.facebookEvent("vendor_business");

    Navigator.push(context,
        PageTransition(type: PageTransitionType.fade, child: SuccessScreen()));
  }

  @override
  void onTokenExpired() {
    // TODO: implement onTokenExpired
  }
}
