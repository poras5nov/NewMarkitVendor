import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:market_vendor_app/activities/create_business/setup_delivery_address.dart';
import 'package:page_transition/page_transition.dart';

import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/asset_constants.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../../utils/utility.dart';
import '../../widgets/form_submit_widget.dart';
import 'model/business_model.dart';

class AddAddressDetails extends StatefulWidget {
  BusinessModel model;
  AddAddressDetails({Key? key, required this.model}) : super(key: key);
  @override
  _AddAddressDetailsState createState() => _AddAddressDetailsState();
}

class _AddAddressDetailsState extends State<AddAddressDetails> {
  TextEditingController addressLine1 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController postalCode = TextEditingController();

  TextEditingController addressLine2 = TextEditingController();
  TextEditingController city2 = TextEditingController();
  TextEditingController state2 = TextEditingController();
  TextEditingController postalCode2 = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
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
                            .find('address'),
                        style: Styles.loginPageTitleBlack,
                      ),
                      Dimens.boxHeight15,
                      Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('fillAddressSubTitle'),
                        style: Styles.loginPageSubTitleGrey,
                      ),
                      Dimens.boxHeight20,
                      Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('businessAddress'),
                        style: Styles.lightBlue14,
                      ),
                      Dimens.boxHeight20,
                      addressTextFormFiled(),
                      Dimens.boxHeight20,
                      Row(
                        children: [
                          Expanded(child: stateTextFormFiled()),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(child: cityTextFormFiled()),
                        ],
                      ),
                      Dimens.boxHeight20,
                      postalNameFormFiled(),
                      Dimens.boxHeight20,
                      Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('businessAddress'),
                        style: Styles.lightBlue14,
                      ),
                      Row(children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (v) {
                            isChecked = v!;
                            if (isChecked) {
                              addressLine2.text = addressLine1.text;
                              state2.text = state.text;
                              city2.text = city.text;
                              postalCode2.text = postalCode.text;
                            }
                            setState(() {});
                          },
                          activeColor: AppColors.primaryColor,
                        ),
                        Flexible(
                          flex: 1,
                          child: Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('isPickupAddressIsSameBusinessAddress'),
                            style: Styles.lightBlue14,
                            maxLines: 2,
                          ),
                        ),
                      ]),
                      addressTextFormFiled1(),
                      Dimens.boxHeight20,
                      Row(
                        children: [
                          Expanded(child: stateTextFormFiled1()),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(child: cityTextFormFiled1()),
                        ],
                      ),
                      Dimens.boxHeight20,
                      postalNameFormFiled2(),
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
                ),
              ))),
    );
  }

  validateInput() {
    if (formkey.currentState!.validate()) {
      widget.model.address = addressLine1.text;
      widget.model.state = state.text;
      widget.model.city = city.text;
      widget.model.postalCode = postalCode.text;

      widget.model.addressLine = addressLine2.text;
      widget.model.pickupState = state2.text;
      widget.model.pickupCity = city2.text;
      widget.model.pickupPostalCode = postalCode2.text;

      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: SetUpdeliveryAddress(model: widget.model)));
    }
  }

  addressTextFormFiled() {
    return TextFormField(
      controller: addressLine1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('addressLine1'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  stateTextFormFiled() {
    return TextFormField(
      controller: state,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('state'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  cityTextFormFiled() {
    return TextFormField(
      controller: city,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('city'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  postalNameFormFiled() {
    return TextFormField(
      controller: postalCode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('postalCode'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  addressTextFormFiled1() {
    return TextFormField(
      controller: addressLine2,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('addressLine1'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  stateTextFormFiled1() {
    return TextFormField(
      controller: state2,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('state'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  cityTextFormFiled1() {
    return TextFormField(
      controller: city2,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('city'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  postalNameFormFiled2() {
    return TextFormField(
      controller: postalCode2,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('postalCode'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}
