import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/create_business/add_bank_details.dart';
import 'package:market_vendor_app/activities/create_business/document_page.dart';
import 'package:market_vendor_app/activities/create_business/working_hours.dart';
import 'package:page_transition/page_transition.dart';

import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/asset_constants.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../../utils/utility.dart';
import '../../widgets/form_submit_widget.dart';
import 'model/business_model.dart';

class SetUpContact extends StatefulWidget {
  BusinessModel model;
  SetUpContact({Key? key, required this.model}) : super(key: key);

  @override
  _SetUpContactState createState() => _SetUpContactState();
}

class _SetUpContactState extends State<SetUpContact> {
  TextEditingController emailController = TextEditingController();
  TextEditingController webSiteController = TextEditingController(text: "");
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  List<TextEditingController> controller = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    controller.add(TextEditingController(text: ""));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              top: true,
              bottom: false,
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
                    Dimens.boxHeight10,
                    Text(
                      NewMarkitVendorLocalizations.of(context)!
                          .find('setUpContactDetails'),
                      style: Styles.loginPageTitleBlack,
                    ),
                    Dimens.boxHeight15,
                    Text(
                      NewMarkitVendorLocalizations.of(context)!
                          .find('fillBusinessInfo'),
                      style: Styles.loginPageSubTitleGrey,
                    ),
                    Dimens.boxHeight20,
                    Row(
                      children: [
                        Text(
                          NewMarkitVendorLocalizations.of(context)!
                              .find('businessContact'),
                          style: Styles.lightGrey14,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            controller.add(TextEditingController(text: ""));
                            setState(() {});
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.add,
                                color: AppColors.primaryColor,
                              ),
                              Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('addMore'),
                                style: Styles.redMedium14,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Form(
                      key: formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Wrap(
                            children: [
                              for (int i = 0; i < controller.length; i++)
                                setUpPhoneNumber(controller[i])
                            ],
                          ),
                          Dimens.boxHeight20,
                          emailTextFormFiled(),
                          Dimens.boxHeight20,
                        ],
                      ),
                    ),
                    webSiteTextFormFiled(),
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
                        validateInput();
                      },
                    )
                  ],
                ),
              ))),
    );
  }

  validateInput() {
    if (formkey.currentState!.validate()) {
      widget.model.bussinessEmail = emailController.text;
      widget.model.website = webSiteController.text;
      for (int i = 0; i < controller.length; i++) {
        if (widget.model.phone != null) {
          widget.model.phone = widget.model.phone! + "," + controller[i].text;
        } else {
          widget.model.phone = controller[i].text;
        }
      }
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: DocumentPage(
                model: widget.model,
              )));
    }
  }

  emailTextFormFiled() {
    return TextFormField(
      controller: emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (v) => Utility.checkEmailValid(v!, context),
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('businessEmailId'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  webSiteTextFormFiled() {
    return TextFormField(
      controller: webSiteController,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('businessWebsite'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  setUpPhoneNumber(TextEditingController i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox(
              height: Dimens.fiftyFive,
              child: CountryCodePicker(
                onChanged: (val) {},
                countryList: [
                  {
                    'name': 'भारत',
                    'code': 'IN',
                    'dial_code': '+91',
                  },
                ],
                padding: Dimens.edgeInsets2,
                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                initialSelection: 'IN',
                flagWidth: Dimens.twenty,
                // optional. Shows only country name and flag
                showCountryOnly: false,
                // optional. Shows only country name and flag when popup is closed.
                showOnlyCountryWhenClosed: false,
                // optional. aligns the flag and the Text left
                alignLeft: false,
                textStyle: Styles.formFieldTextStyle,
              ),
            ),
            Container(
              height: 0.6,
              width: Dimens.ninety,
              color: AppColors.blackColor,
            )
          ],
        ),
        Dimens.boxWidth15,
        Expanded(child: phoneTextFormFiled(i)),
      ],
    );
  }

  phoneTextFormFiled(TextEditingController i) {
    return SizedBox(
      height: Dimens.sixty,
      child: TextFormField(
        controller: i,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: AppColors.primaryColor,
        textAlignVertical: TextAlignVertical.center,
        style: Styles.formFieldTextStyle,
        keyboardType: TextInputType.number,
        validator: (v) => Utility.checkIfPhoneIsValid(v!, context),
        onChanged: (v) {
          setState(() {});
        },
        decoration: InputDecoration(
          labelText: (i.text.length == 0 || i.text.length == 10)
              ? NewMarkitVendorLocalizations.of(context)!.find('phoneNumber')
              : "",
          labelStyle: Styles.lightGrey14,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
        ),
      ),
    );
  }
}
