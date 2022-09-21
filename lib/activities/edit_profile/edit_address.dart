import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:market_vendor_app/activities/create_business/setup_delivery_address.dart';
import 'package:market_vendor_app/activities/edit_profile/model/business_address_model.dart';
import 'package:market_vendor_app/apiservice/api_call.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:page_transition/page_transition.dart';

import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/asset_constants.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../../utils/shared_preferences.dart';
import '../../utils/utility.dart';
import '../../widgets/form_submit_widget.dart';
import '../create_business/model/cities_model.dart';
import '../create_business/model/state_model.dart';
import '../home_page/model/profile_model.dart';

class EditAddressDetails extends StatefulWidget {
  EditAddressDetails({Key? key}) : super(key: key);
  @override
  _EditAddressDetailsState createState() => _EditAddressDetailsState();
}

class _EditAddressDetailsState extends State<EditAddressDetails>
    implements ApiInterface {
  TextEditingController addressLine1 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController postalCode = TextEditingController();

  TextEditingController addressLine2 = TextEditingController();
  TextEditingController city2 = TextEditingController();
  TextEditingController state2 = TextEditingController();
  TextEditingController postalCode2 = TextEditingController();
  TextEditingController searchController = new TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isChecked = false;
  var token = "";
  var profileData;
  ProfileModel model = ProfileModel();
  bool isLoader = false;

  String stateId = "";
  String stateId2 = "";
  bool isCity1 = true;
  StateList stateModel = StateList();
  CitiesModel citiesModel = CitiesModel();
  String whichApiCall = "state";
  List<States> statesData = [];
  List<States> allData = [];

  List<Cities> citiesData = [];
  List<Cities> allCitiesData = [];
  @override
  void initState() {
    super.initState();
    SharedPref.getProfileData().then((value) {
      profileData = json.decode(value);
      model = ProfileModel.fromJson(profileData);
      setAddress();
      setState(() {});
    });
    getToken();
  }

  void _runFilter(String enteredKeyword, StateSetter setState) {
    List<States> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = allData;
    } else {
      results = statesData
          .where((user) =>
              user.name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      statesData = results;
    });
  }

  void _runFilterCities(String enteredKeyword, StateSetter setState) {
    List<Cities> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = allCitiesData;
    } else {
      results = citiesData
          .where((user) =>
              user.name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      citiesData = results;
    });
  }

  setAddress() {
    addressLine1.text = model.data!.businesses!.address!;
    city.text = model.data!.businesses!.city!;
    state.text = model.data!.businesses!.state!;
    postalCode.text = model.data!.businesses!.postalCode!;

    addressLine2.text = model.data!.businesses!.addressLine!;
    city2.text = model.data!.businesses!.pickupCity!;
    state2.text = model.data!.businesses!.pickupState!;
    postalCode2.text = model.data!.businesses!.pickupPostalCode!;
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
      showTransparentDialog(context);
      ApiCall.getStatesApi(token, this, context);
    });
  }

  showTransparentDialog(BuildContext context) async {
    showDialog(
        context: context,
        //It doesnt work: barrierColor: Colors.transparent,
        barrierColor: Color(0x00ffffff), //this works
        builder: (_) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
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
                  bottom: true,
                  child: Padding(
                    padding: EdgeInsets.all(Dimens.sixTeen),
                    child: Form(
                      key: formkey,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          Container(
                            height: 50,
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(
                                      Icons.arrow_back_rounded,
                                      color: AppColors.blackColor,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  NewMarkitVendorLocalizations.of(context)!
                                      .find('businessAddress'),
                                  style: Styles.boldBlack16,
                                ),
                              ],
                            ),
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
                          stateTextFormFiled(),
                          Dimens.boxHeight20,
                          cityTextFormFiled(),
                          Dimens.boxHeight20,
                          postalNameFormFiled(),
                          Dimens.boxHeight20,
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('businessDeliveryAddress'),
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
                                NewMarkitVendorLocalizations.of(context)!.find(
                                    'isPickupAddressIsSameBusinessAddress'),
                                style: Styles.lightBlue14,
                                maxLines: 2,
                              ),
                            ),
                          ]),
                          addressTextFormFiled1(),
                          Dimens.boxHeight20,
                          stateTextFormFiled1(),
                          Dimens.boxHeight20,
                          cityTextFormFiled1(),
                          Dimens.boxHeight20,
                          postalNameFormFiled2(),
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
                                  text:
                                      NewMarkitVendorLocalizations.of(context)!
                                          .find('update'),
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
                  )),
            ],
          )),
    );
  }

  validateInput() {
    if (formkey.currentState!.validate()) {
      BusinessAddressModel businessModel = BusinessAddressModel();
      businessModel.businessId = model.data!.businesses!.id!;

      businessModel.address = addressLine1.text;
      businessModel.city = city.text;
      businessModel.postalCode = postalCode.text;
      businessModel.state = state.text;
      businessModel.addressLine = addressLine2.text;
      businessModel.pickupCity = city2.text;
      businessModel.pickupPostalCode = postalCode2.text;
      businessModel.pickupState = state2.text;

      // businessModel.address = addressLine1.text;
      // businessModel.city = city.text;
      // businessModel.postalCode = postalCode.text;
      // businessModel.state = state.text;
      // businessModel.addressLine = "";
      // businessModel.pickupCity = "";
      // businessModel.pickupPostalCode = "";
      // businessModel.pickupState = "";

      setState(() {
        isLoader = true;
      });
      whichApiCall = "saveAddress";

      ApiCall.updateBusinessAddressApi(businessModel, token, this, context);
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

  postalNameFormFiled2() {
    return TextFormField(
      controller: postalCode2,
      //autovalidateMode: AutovalidateMode.onUserInteraction,
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

  @override
  void onFailure(message) {
    Utility.errorMessage(message, context);
    setState(() {
      isLoader = false;
    });
  }

  @override
  void onSuccess(data) {
    if (whichApiCall == "saveAddress") {
      Utility.successMessage(data['message'], context);
      var d = jsonEncode(data);
      SharedPref.saveProfileData(d);
    } else if (whichApiCall == "state") {
      stateModel = StateList.fromJson(data);
      statesData = stateModel.states!;
      allData = stateModel.states!;
      Navigator.pop(context);
    } else {
      citiesModel = CitiesModel.fromJson(data);
      citiesData = citiesModel.cities!;
      allCitiesData = citiesModel.cities!;
      Navigator.pop(context);
      if (isCity1) {
        ciitesBottomSheet(context, city);
      } else {
        ciitesBottomSheet(context, city2);
      }
    }
    setState(() {
      isLoader = false;
    });
  }

  @override
  void onTokenExpired() {
    // TODO: implement onTokenExpired
  }

  stateTextFormFiled() {
    return TextFormField(
      controller: state,
      readOnly: true,
      onTap: () {
        stateBottomSheet(context, state);
      },
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
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.lightGreyHintText,
          )),
    );
  }

  cityTextFormFiled() {
    return TextFormField(
      controller: city,
      readOnly: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      onTap: () {
        if (city.text.isEmpty) {
          Utility.errorMessage("Please select first state", context);
        } else {
          for (int i = 0; i < stateModel.states!.length; i++) {
            if (state.text == stateModel.states![i].name) {
              stateId = stateModel.states![i].id.toString();
              break;
            }
          }
          isCity1 = true;
          showTransparentDialog(context);

          whichApiCall = "city";
          ApiCall.getCitiesApi(stateId, token, this, context);
        }
      },
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
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.lightGreyHintText,
          )),
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
      readOnly: true,
      onTap: () {
        stateBottomSheet(context, state2);
      },
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
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.lightGreyHintText,
          )),
    );
  }

  cityTextFormFiled1() {
    return TextFormField(
      controller: city2,
      readOnly: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      onTap: (() {
        if (state2.text.isEmpty) {
          Utility.errorMessage("Please select first state", context);
        } else {
          isCity1 = false;

          for (int i = 0; i < stateModel.states!.length; i++) {
            if (state2.text == stateModel.states![i].name) {
              stateId = stateModel.states![i].id.toString();
              break;
            }
          }
          showTransparentDialog(context);
          whichApiCall = "city";
          ApiCall.getCitiesApi(stateId, token, this, context);
        }
      }),
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
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.lightGreyHintText,
          )),
    );
  }

  void stateBottomSheet(BuildContext ctx, TextEditingController c) {
    showModalBottomSheet(
        elevation: 10,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
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
                                  .find('selectState'),
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
                    TextFormField(
                      onChanged: (v) {
                        _runFilter(v, setState);
                      },
                      style: Styles.formFieldTextStyle,
                      decoration: const InputDecoration(
                          hintText: "Search State",
                          contentPadding: EdgeInsets.all(16)),
                    ),
                    Expanded(
                        flex: 1,
                        child: ListView.builder(
                            itemCount: statesData.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  c.text = statesData[index].name!;
                                  stateId = statesData[index].id.toString();
                                  _runFilter("", setState);
                                  Navigator.pop(context);
                                  changeState();
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
                                          c.text = statesData[index].name!;
                                          stateId =
                                              statesData[index].id.toString();
                                          _runFilter("", setState);

                                          Navigator.pop(context);
                                          changeState();
                                        },
                                        child: Text(
                                          statesData[index].name!,
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
              ),
            );
          });
        });
  }

  void ciitesBottomSheet(BuildContext ctx, TextEditingController c) {
    showModalBottomSheet(
        elevation: 10,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
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
                                  .find('selectCities'),
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
                    TextFormField(
                      onChanged: (v) {
                        _runFilterCities(v, setState);
                      },
                      style: Styles.formFieldTextStyle,
                      decoration: const InputDecoration(
                          hintText: "Search Cities",
                          contentPadding: EdgeInsets.all(16)),
                    ),
                    Expanded(
                        flex: 1,
                        child: ListView.builder(
                            itemCount: citiesData.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  c.text = citiesData[index].name!;
                                  _runFilterCities("", setState);
                                  Navigator.pop(context);
                                  changeState();
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
                                          c.text = citiesData[index].name!;
                                          _runFilterCities("", setState);

                                          Navigator.pop(context);
                                          changeState();
                                        },
                                        child: Text(
                                          citiesData[index].name!,
                                          style: Styles.boldBlack16,
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              );
                            }))
                  ],
                ),
              ),
            );
          });
        });
  }

  changeState() {
    setState(() {});
  }
}
