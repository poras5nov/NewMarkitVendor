import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/theme/app_colors.dart';
import 'package:market_vendor_app/theme/dimens.dart';
import 'package:market_vendor_app/utils/new_market_vendor_localizations.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

import '../../../theme/styles.dart';
import '../../apiservice/api_call.dart';
import '../../utils/strings/app_constants.dart';
import '../../utils/utility.dart';
import '../../widgets/form_submit_widget.dart';
import 'model/change_status_list_model.dart';
import 'model/reason_model.dart';

class DeclineOrderScreen extends StatefulWidget {
  List<ChangeData>? orderTypeModel;

  int? id;
  DeclineOrderScreen({this.id, this.orderTypeModel});
  @override
  _DeclineOrderScreenState createState() => _DeclineOrderScreenState();
}

class _DeclineOrderScreenState extends State<DeclineOrderScreen>
    implements ApiInterface {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  var token;
  bool isLoader = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String whichApiCall = "getReason";
  ReasonModel model = ReasonModel();
  String reasonID = "";

  @override
  void initState() {
    getToken();
    super.initState();
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
      setState(() {
        isLoader = true;
      });
      ApiCall.declineReson(token, this, context);

      // ApiCall.getProductsApi(token, this, context);
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: formkey,
                        child: Column(
                          children: [
                            chooseReasonTextFormFiled(),
                            SizedBox(
                              height: Dimens.twenty,
                            ),
                            decriptionsTextFormFiled(),
                            SizedBox(
                              height: Dimens.thirty,
                            ),
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
                                    text: NewMarkitVendorLocalizations.of(
                                            context)!
                                        .find('submit'),
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
                                  .find('decline'),
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

  validateInput() {
    if (formkey.currentState!.validate()) {
      whichApiCall = "changeStatus";
      setState(() {
        isLoader = true;
      });
      for (int i = 0; i < widget.orderTypeModel!.length; i++) {
        if (widget.orderTypeModel![i].name == "Cancelled") {
          ApiCall.changeStatus(
              widget.orderTypeModel![i].id.toString(),
              widget.id.toString(),
              reasonID,
              descriptionController.text,
              "",
              token,
              this,
              context);
          break;
        }
      }
    }
  }

  decriptionsTextFormFiled() {
    return TextFormField(
      controller: descriptionController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText:
            NewMarkitVendorLocalizations.of(context)!.find('description'),
        labelStyle: Styles.lightGrey14,
        hintStyle: Styles.lightGrey14,
        hintText:
            NewMarkitVendorLocalizations.of(context)!.find('describeHere'),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  chooseReasonTextFormFiled() {
    return TextFormField(
      readOnly: true,
      controller: reasonController,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      onTap: () {
        reasonBottomSheet(context);
      },
      decoration: InputDecoration(
          labelText: NewMarkitVendorLocalizations.of(context)!
              .find('chooseReasonToCancel'),
          labelStyle: Styles.lightGrey14,
          hintText:
              NewMarkitVendorLocalizations.of(context)!.find('selectReason'),
          hintStyle: Styles.lightGrey14,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.lightGreyHintText,
          )),
    );
  }

  void reasonBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
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
                                .find('selectReason'),
                            style: Styles.boldWhite16,
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     changeState();

                        //     Navigator.pop(context);
                        //   },
                        //   child: Text(
                        //     NewMarkitVendorLocalizations.of(context)!
                        //         .find('done'),
                        //     style: Styles.boldWhite14,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[400],
                    width: MediaQuery.of(context).size.width,
                  ),
                  Expanded(
                      flex: 1,
                      child: ListView.builder(
                          itemCount: model.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                changeState(index);
                                Navigator.pop(context);
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
                                        changeState(index);

                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        model.data![index].text!,
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
            );
          });
        });
  }

  changeState(int i) {
    reasonController.text = model.data![i].text!;
    reasonID = model.data![i].id.toString();
    setState(() {});
  }

  @override
  void onFailure(message) {
    setState(() {
      isLoader = false;
    });
    Utility.errorMessage(message, context);
  }

  @override
  void onSuccess(data) {
    if (whichApiCall == "getReason") {
      model = ReasonModel.fromJson(data);
    } else if (whichApiCall == "changeStatus") {
      Utility.successMessage(data['message'], context);
      Navigator.pop(context, true);
    }
    setState(() {
      isLoader = false;
    });
  }

  @override
  void onTokenExpired() {
    // TODO: implement onTokenExpired
  }
}
