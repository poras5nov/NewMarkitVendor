import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market_vendor_app/activities/add_product/model/addproduct.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';

import '../../apiservice/api_call.dart';
import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../../utils/shared_preferences.dart';
import '../../utils/utility.dart';
import '../../widgets/form_submit_widget.dart';
import 'model/attributes_model.dart';

class SpecificationScreen extends StatefulWidget {
  List<Specifactions>? data;
  SpecificationScreen({Key? key, required this.data}) : super(key: key);

  @override
  _SpecificationScreenState createState() => _SpecificationScreenState();
}

class _SpecificationScreenState extends State<SpecificationScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isSelected = false;
  List<Specifactions> dataModel = List.empty(growable: true);
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      dataModel = widget.data!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
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
                  bottom: false,
                  child: Padding(
                    padding: Dimens.edgeInsets20,
                    child: Form(
                      key: formkey,
                      autovalidateMode: _autoValidate,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                            ],
                          ),
                          Dimens.boxHeight15,
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('specifications'),
                            style: Styles.loginPageTitleBlack,
                          ),
                          Dimens.boxHeight15,
                          Text(
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('addproductspecification'),
                              style: Styles.loginPageSubTitleGrey),
                          Dimens.boxHeight20,
                          dataModel.isNotEmpty
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  child: Wrap(children: [
                                    for (int i = 0; i < dataModel.length; i++)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColors.greyColor
                                                      .withOpacity(0.6)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                "${NewMarkitVendorLocalizations.of(context)!.find('title')}:- ${dataModel[i].title}",
                                                                style: Styles
                                                                    .loginPageSubTitleGrey),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  dataModel
                                                                      .removeAt(
                                                                          i);
                                                                  setState(
                                                                      () {});
                                                                },
                                                                child: const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: AppColors
                                                                        .primaryColor,
                                                                    size: 30))
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                "${NewMarkitVendorLocalizations.of(context)!.find('value')}:- ${dataModel[i].specifactionValue}",
                                                                style: Styles
                                                                    .loginPageSubTitleGrey),
                                                          ],
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      )
                                  ]),
                                )
                              : Container(
                                  height: Dimens.ten,
                                ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1,
                                    color:
                                        AppColors.greyColor.withOpacity(0.6))),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  titleTextFormFiled(),
                                  Dimens.boxHeight10,
                                  valueTextFormFiled(),
                                  Dimens.boxHeight10,
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isSelected,
                                        activeColor: AppColors.primaryColor,
                                        onChanged: (v) {
                                          isSelected = v!;
                                          setState(() {});
                                        },
                                      ),
                                      Text(
                                          NewMarkitVendorLocalizations.of(
                                                  context)!
                                              .find('specificationsMsg'),
                                          style: Styles.loginPageSubTitleGrey)
                                    ],
                                  )
                                ]),
                          ),
                          Dimens.boxHeight20,
                          FormSubmitWidget(
                            opacity: 1,
                            disableColor: AppColors.primaryColor,
                            padding: Dimens.edgeInsets0,
                            text: NewMarkitVendorLocalizations.of(context)!
                                .find('saveandmore'),
                            textStyle: Styles.redMedium16,
                            startColor: Colors.white,
                            endColor: Colors.white,
                            borderColor: AppColors.primaryColor,
                            borderWidth: 1,
                            iconColor: Colors.white,
                            onTap: () {
                              if (formkey.currentState!.validate()) {
                                Specifactions specification = Specifactions();
                                specification.title = titleController.text;
                                specification.specifactionValue =
                                    valueController.text;
                                specification.forFilter = isSelected ? 1 : 0;
                                dataModel.add(specification);

                                titleController =
                                    TextEditingController(text: "");
                                valueController =
                                    TextEditingController(text: "");
                                isSelected = false;
                                setState(() {
                                  _autoValidate = AutovalidateMode.disabled;
                                });
                              }
                            },
                          ),
                          Dimens.boxHeight20,
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
                              Navigator.pop(context, dataModel);
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          )),
    );
  }

  titleTextFormFiled() {
    return TextFormField(
      controller: titleController,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.text,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!
            .find('specificationsTitle'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  valueTextFormFiled() {
    return TextFormField(
      controller: valueController,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.text,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!
            .find('specificationsValue'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}
