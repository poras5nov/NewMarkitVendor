import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:market_vendor_app/activities/create_business/add_address.dart';
import 'package:market_vendor_app/activities/edit_profile/model/edit_working_jours_model.dart';
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
import '../create_business/model/business_model.dart';
import '../home_page/model/profile_model.dart';

class EditWorkingHoursPage extends StatefulWidget {
  EditWorkingHoursPage({Key? key}) : super(key: key);
  @override
  _EditWorkingHoursPageState createState() => _EditWorkingHoursPageState();
}

class _EditWorkingHoursPageState extends State<EditWorkingHoursPage>
    implements ApiInterface {
  TextEditingController openTimeController = new TextEditingController();
  TextEditingController closeTimeController = new TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isLoader = false;

  bool isMondayStatus = false;
  bool isTuesdayStatus = false;
  bool isWednesdayStatus = false;
  bool isThrusdayStatus = false;
  bool isFridayStatus = false;
  bool isSaturdayStatus = false;
  bool isSundayStatus = false;
  bool selectAll = false;
  String _token = "";
  List<WorkingDays>? workingHours = [];
  TimeOfDay? openTime;
  TimeOfDay? closeTime;
  var token = "";
  List<String> days = <String>[
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  var profileData;
  ProfileModel model = ProfileModel();
  @override
  void initState() {
    super.initState();
    SharedPref.getProfileData().then((value) {
      profileData = json.decode(value);
      model = ProfileModel.fromJson(profileData);
      setWorkingHours();
      setState(() {});
    });
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
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
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
                      Dimens.boxHeight15,
                      Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('workingHours'),
                        style: Styles.loginPageTitleBlack,
                      ),
                      Dimens.boxHeight15,
                      Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('pleaseAddYourWorkingHours'),
                        style: Styles.loginPageSubTitleGrey,
                      ),
                      Dimens.boxHeight20,
                      Form(
                        key: formkey,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: <Widget>[
                              Expanded(child: openTextFormFiled()),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(child: closeTextFormFiled()),
                            ],
                          ),
                        ),
                      ),
                      Dimens.boxHeight20,
                      Row(
                        children: <Widget>[
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('workingHours'),
                            style: Styles.loginPageSubTitleGrey,
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isMondayStatus = true;
                                isTuesdayStatus = true;
                                isWednesdayStatus = true;
                                isThrusdayStatus = true;
                                isFridayStatus = true;
                                isSaturdayStatus = true;
                                isSundayStatus = true;
                                selectAll = true;
                              });
                            },
                            child: Text(
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('selectAll'),
                              style: Styles.redMedium14,
                            ),
                          )
                        ],
                      ),
                      Dimens.boxHeight20,
                      Row(
                        children: <Widget>[
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('monday'),
                            style: Styles.daysTitleBlack,
                          ),
                          const Spacer(),
                          FlutterSwitch(
                            width: 65,
                            height: 40.0,
                            toggleSize: 30.0,
                            value: isMondayStatus,
                            activeColor: AppColors.lightBlueColor2,
                            borderRadius: 30.0,
                            padding: 8.0,
                            showOnOff: false,
                            onToggle: (val) {
                              setState(() {
                                isMondayStatus = val;
                              });
                            },
                          ),
                        ],
                      ),
                      Dimens.boxHeight20,
                      Row(
                        children: <Widget>[
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('tuesday'),
                            style: Styles.daysTitleBlack,
                          ),
                          const Spacer(),
                          FlutterSwitch(
                            width: 65,
                            height: 40.0,
                            toggleSize: 30.0,
                            value: isTuesdayStatus,
                            activeColor: AppColors.lightBlueColor2,
                            borderRadius: 30.0,
                            padding: 8.0,
                            showOnOff: false,
                            onToggle: (val) {
                              setState(() {
                                isTuesdayStatus = val;
                              });
                            },
                          ),
                        ],
                      ),
                      Dimens.boxHeight20,
                      Row(
                        children: <Widget>[
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('wednesday'),
                            style: Styles.daysTitleBlack,
                          ),
                          const Spacer(),
                          FlutterSwitch(
                            width: 65,
                            height: 40.0,
                            toggleSize: 30.0,
                            value: isWednesdayStatus,
                            activeColor: AppColors.lightBlueColor2,
                            borderRadius: 30.0,
                            padding: 8.0,
                            showOnOff: false,
                            onToggle: (val) {
                              setState(() {
                                isWednesdayStatus = val;
                              });
                            },
                          ),
                        ],
                      ),
                      Dimens.boxHeight20,
                      Row(
                        children: <Widget>[
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('thursday'),
                            style: Styles.daysTitleBlack,
                          ),
                          const Spacer(),
                          FlutterSwitch(
                            width: 65,
                            height: 40.0,
                            toggleSize: 30.0,
                            value: isThrusdayStatus,
                            activeColor: AppColors.lightBlueColor2,
                            borderRadius: 30.0,
                            padding: 8.0,
                            showOnOff: false,
                            onToggle: (val) {
                              setState(() {
                                isThrusdayStatus = val;
                              });
                            },
                          ),
                        ],
                      ),
                      Dimens.boxHeight20,
                      Row(
                        children: <Widget>[
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('friday'),
                            style: Styles.daysTitleBlack,
                          ),
                          const Spacer(),
                          FlutterSwitch(
                            width: 65,
                            height: 40.0,
                            toggleSize: 30.0,
                            value: isFridayStatus,
                            activeColor: AppColors.lightBlueColor2,
                            borderRadius: 30.0,
                            padding: 8.0,
                            showOnOff: false,
                            onToggle: (val) {
                              setState(() {
                                isFridayStatus = val;
                              });
                            },
                          ),
                        ],
                      ),
                      Dimens.boxHeight20,
                      Row(
                        children: <Widget>[
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('saturday'),
                            style: Styles.daysTitleBlack,
                          ),
                          const Spacer(),
                          FlutterSwitch(
                            width: 65,
                            height: 40.0,
                            toggleSize: 30.0,
                            value: isSaturdayStatus,
                            activeColor: AppColors.lightBlueColor2,
                            borderRadius: 30.0,
                            padding: 8.0,
                            showOnOff: false,
                            onToggle: (val) {
                              setState(() {
                                isSaturdayStatus = val;
                              });
                            },
                          ),
                        ],
                      ),
                      Dimens.boxHeight20,
                      Row(
                        children: <Widget>[
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('sunday'),
                            style: Styles.daysTitleBlack,
                          ),
                          const Spacer(),
                          FlutterSwitch(
                            width: 65,
                            height: 35,
                            toggleSize: 30.0,
                            value: isSundayStatus,
                            activeColor: AppColors.lightBlueColor2,
                            borderRadius: 30.0,
                            padding: 8.0,
                            showOnOff: false,
                            onToggle: (val) {
                              setState(() {
                                isSundayStatus = val;
                              });
                            },
                          ),
                        ],
                      ),
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
                                  .find('update'),
                              textStyle: Styles.buttonWhiteTextStyle,
                              startColor: AppColors.primaryColor,
                              endColor: AppColors.primaryColor,
                              iconColor: Colors.white,
                              onTap: () {
                                validateInput();
                              },
                            ),
                      Dimens.boxHeight30,
                    ],
                  )))),
    );
  }

  validateInput() {
    if (formkey.currentState!.validate()) {
      if (workingHours!.isNotEmpty) {
        workingHours!.clear();
      }

      selectWorkingHours();

      EditWorkingHoursModel hoursModel = EditWorkingHoursModel();
      hoursModel.businessId = model.data!.businesses!.id;
      hoursModel.workingDays = workingHours;
      setState(() {
        isLoader = true;
      });
      ApiCall.updateWorkingHoursApi(hoursModel, token, this, context);
      // widget.model.workingDays = workingHours;
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  bool compareTimeOfDay() {
    final now = DateTime.now();
    final op = DateTime(
        now.year, now.month, now.day, openTime!.hour, openTime!.minute);
    final cl = DateTime(
        now.year, now.month, now.day, closeTime!.hour, closeTime!.minute);
    bool v = cl.isAfter(op);
    return v;
  }

  openTextFormFiled() {
    return TextFormField(
      readOnly: true,
      controller: openTimeController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => Utility.checkTimeFiledValid(v!, context),
      onTap: () {
        showTimePicker(
          initialTime: TimeOfDay.now(),
          context: context,
        ).then((time) {
          openTime = time;
          setState(() {
            openTimeController.text = formatTimeOfDay(time!);
          });
        });
      },
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('openTime'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        suffixIcon: GestureDetector(
          onTap: () {},
          child: const Icon(
            Icons.access_time,
            color: AppColors.primaryColor,
            size: 30,
          ),
        ),
      ),
    );
  }

  closeTextFormFiled() {
    return TextFormField(
      readOnly: true,
      controller: closeTimeController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => Utility.checkTimeFiledValid(v!, context),
      onTap: () {
        showTimePicker(
          initialTime: TimeOfDay.now(),
          context: context,
        ).then((time) {
          closeTime = time;
          setState(() {
            closeTimeController.text = formatTimeOfDay(time!);
          });
        });
      },
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('closeTime'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        suffixIcon: GestureDetector(
          onTap: () {},
          child: const Icon(
            Icons.access_time,
            color: AppColors.primaryColor,
            size: 30,
          ),
        ),
      ),
    );
  }

  setWorkingHours() {
    openTimeController.text =
        model.data!.businesses!.workingDays![0].from!.substring(0, 5) +
            " " +
            model.data!.businesses!.workingDays![0].fromType!;
    closeTimeController.text =
        model.data!.businesses!.workingDays![0].to!.substring(0, 5) +
            " " +
            model.data!.businesses!.workingDays![0].toType!;

    for (int i = 0; i < model.data!.businesses!.workingDays!.length; i++) {
      WorkingDays hoursModle = WorkingDays();
      hoursModle.day = model.data!.businesses!.workingDays![i].day;
      hoursModle.from = model.data!.businesses!.workingDays![i].from;
      hoursModle.fromType = model.data!.businesses!.workingDays![i].fromType;
      hoursModle.to = model.data!.businesses!.workingDays![i].to;
      hoursModle.toType = model.data!.businesses!.workingDays![i].toType;
      hoursModle.open = model.data!.businesses!.workingDays![i].open;
      if (model.data!.businesses!.workingDays![i].day == days[0]) {
        if (model.data!.businesses!.workingDays![i].open == "yes") {
          isMondayStatus = true;
        } else {
          isMondayStatus = false;
        }
      } else if (model.data!.businesses!.workingDays![i].day == days[1]) {
        if (model.data!.businesses!.workingDays![i].open == "yes") {
          isTuesdayStatus = true;
        } else {
          isTuesdayStatus = false;
        }
      } else if (model.data!.businesses!.workingDays![i].day == days[2]) {
        if (model.data!.businesses!.workingDays![i].open == "yes") {
          isWednesdayStatus = true;
        } else {
          isWednesdayStatus = false;
        }
      } else if (model.data!.businesses!.workingDays![i].day == days[3]) {
        if (model.data!.businesses!.workingDays![i].open == "yes") {
          isThrusdayStatus = true;
        } else {
          isThrusdayStatus = false;
        }
      } else if (model.data!.businesses!.workingDays![i].day == days[4]) {
        if (model.data!.businesses!.workingDays![i].open == "yes") {
          isFridayStatus = true;
        } else {
          isFridayStatus = false;
        }
      } else if (model.data!.businesses!.workingDays![i].day == days[5]) {
        if (model.data!.businesses!.workingDays![i].open == "yes") {
          isSaturdayStatus = true;
        } else {
          isSaturdayStatus = false;
        }
      } else if (model.data!.businesses!.workingDays![i].day == days[6]) {
        if (model.data!.businesses!.workingDays![i].open == "yes") {
          isSundayStatus = true;
        } else {
          isSundayStatus = false;
        }
      }

      workingHours!.add(hoursModle);
    }
    setState(() {});
  }

  selectWorkingHours() {
    if (workingHours!.isNotEmpty) {
      workingHours!.clear();
    }
    if (isMondayStatus == true) {
      WorkingDays hoursModle = WorkingDays();
      hoursModle.day = days[0];
      hoursModle.from = openTimeController.text.split(" ")[0].toString();
      hoursModle.fromType = openTimeController.text.split(" ")[1].toString();
      hoursModle.to = closeTimeController.text.split(" ")[0].toString();
      hoursModle.toType = closeTimeController.text.split(" ")[1].toString();
      hoursModle.open = "yes";
      workingHours!.add(hoursModle);
    } else {
      WorkingDays hoursModle = WorkingDays();
      hoursModle.day = days[0];
      hoursModle.from = openTimeController.text.split(" ")[0].toString();
      hoursModle.fromType = openTimeController.text.split(" ")[1].toString();
      hoursModle.to = closeTimeController.text.split(" ")[0].toString();
      hoursModle.toType = closeTimeController.text.split(" ")[1].toString();
      hoursModle.open = "no";
      workingHours!.add(hoursModle);
    }

    if (isTuesdayStatus == true) {
      WorkingDays hoursModle = WorkingDays();
      hoursModle.day = days[1];
      hoursModle.from = openTimeController.text.split(" ")[0].toString();
      hoursModle.fromType = openTimeController.text.split(" ")[1].toString();
      hoursModle.to = closeTimeController.text.split(" ")[0].toString();
      hoursModle.toType = closeTimeController.text.split(" ")[1].toString();
      hoursModle.open = "yes";
      workingHours!.add(hoursModle);
    } else {
      WorkingDays hoursModle = WorkingDays();
      hoursModle.day = days[1];
      hoursModle.from = openTimeController.text.split(" ")[0].toString();
      hoursModle.fromType = openTimeController.text.split(" ")[1].toString();
      hoursModle.to = closeTimeController.text.split(" ")[0].toString();
      hoursModle.toType = closeTimeController.text.split(" ")[1].toString();
      hoursModle.open = "no";
      workingHours!.add(hoursModle);
    }
    if (isWednesdayStatus == true) {
      WorkingDays hoursModle = WorkingDays();
      hoursModle.day = days[2];
      hoursModle.from = openTimeController.text.split(" ")[0].toString();
      hoursModle.fromType = openTimeController.text.split(" ")[1].toString();
      hoursModle.to = closeTimeController.text.split(" ")[0].toString();
      hoursModle.toType = closeTimeController.text.split(" ")[1].toString();
      hoursModle.open = "yes";
      workingHours!.add(hoursModle);
    } else {
      WorkingDays hoursModle = WorkingDays();
      hoursModle.day = days[2];
      hoursModle.from = openTimeController.text.split(" ")[0].toString();
      hoursModle.fromType = openTimeController.text.split(" ")[1].toString();
      hoursModle.to = closeTimeController.text.split(" ")[0].toString();
      hoursModle.toType = closeTimeController.text.split(" ")[1].toString();
      hoursModle.open = "no";
      workingHours!.add(hoursModle);
    }
    if (isThrusdayStatus == true) {
      WorkingDays hoursModle = WorkingDays();
      hoursModle.day = days[3];
      hoursModle.from = openTimeController.text.split(" ")[0].toString();
      hoursModle.fromType = openTimeController.text.split(" ")[1].toString();
      hoursModle.to = closeTimeController.text.split(" ")[0].toString();
      hoursModle.toType = closeTimeController.text.split(" ")[1].toString();
      hoursModle.open = "yes";
      workingHours!.add(hoursModle);
    } else {
      WorkingDays hoursModle = WorkingDays();
      hoursModle.day = days[3];
      hoursModle.from = openTimeController.text.split(" ")[0].toString();
      hoursModle.fromType = openTimeController.text.split(" ")[1].toString();
      hoursModle.to = closeTimeController.text.split(" ")[0].toString();
      hoursModle.toType = closeTimeController.text.split(" ")[1].toString();
      hoursModle.open = "no";
      workingHours!.add(hoursModle);
    }
    if (isFridayStatus == true) {
      WorkingDays hoursModle = WorkingDays();
      hoursModle.day = days[4];
      hoursModle.from = openTimeController.text.split(" ")[0].toString();
      hoursModle.fromType = openTimeController.text.split(" ")[1].toString();
      hoursModle.to = closeTimeController.text.split(" ")[0].toString();
      hoursModle.toType = closeTimeController.text.split(" ")[1].toString();
      hoursModle.open = "yes";
      workingHours!.add(hoursModle);
    } else {
      WorkingDays hoursModle = WorkingDays();
      hoursModle.day = days[4];
      hoursModle.from = openTimeController.text.split(" ")[0].toString();
      hoursModle.fromType = openTimeController.text.split(" ")[1].toString();
      hoursModle.to = closeTimeController.text.split(" ")[0].toString();
      hoursModle.toType = closeTimeController.text.split(" ")[1].toString();
      hoursModle.open = "no";
      workingHours!.add(hoursModle);
    }
    if (isSaturdayStatus == true) {
      WorkingDays hoursModle = WorkingDays();
      hoursModle.day = days[5];
      hoursModle.from = openTimeController.text.split(" ")[0].toString();
      hoursModle.fromType = openTimeController.text.split(" ")[1].toString();
      hoursModle.to = closeTimeController.text.split(" ")[0].toString();
      hoursModle.toType = closeTimeController.text.split(" ")[1].toString();
      hoursModle.open = "yes";
      workingHours!.add(hoursModle);
    } else {
      WorkingDays hoursModle = WorkingDays();
      hoursModle.day = days[5];
      hoursModle.from = openTimeController.text.split(" ")[0].toString();
      hoursModle.fromType = openTimeController.text.split(" ")[1].toString();
      hoursModle.to = closeTimeController.text.split(" ")[0].toString();
      hoursModle.toType = closeTimeController.text.split(" ")[1].toString();
      hoursModle.open = "no";
      workingHours!.add(hoursModle);
    }
    if (isSundayStatus == true) {
      WorkingDays hoursModle = WorkingDays();
      hoursModle.day = days[6];
      hoursModle.from = openTimeController.text.split(" ")[0].toString();
      hoursModle.fromType = openTimeController.text.split(" ")[1].toString();
      hoursModle.to = closeTimeController.text.split(" ")[0].toString();
      hoursModle.toType = closeTimeController.text.split(" ")[1].toString();
      hoursModle.open = "yes";
      workingHours!.add(hoursModle);
    } else {
      WorkingDays hoursModle = WorkingDays();
      hoursModle.day = days[6];
      hoursModle.from = openTimeController.text.split(" ")[0].toString();
      hoursModle.fromType = openTimeController.text.split(" ")[1].toString();
      hoursModle.to = closeTimeController.text.split(" ")[0].toString();
      hoursModle.toType = closeTimeController.text.split(" ")[1].toString();
      hoursModle.open = "no";
      workingHours!.add(hoursModle);
    }
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
    Utility.successMessage(data['message'], context);
    var d = jsonEncode(data);
    SharedPref.saveProfileData(d);

    setState(() {
      isLoader = false;
    });
  }

  @override
  void onTokenExpired() {
    // TODO: implement onTokenExpired
  }
}
