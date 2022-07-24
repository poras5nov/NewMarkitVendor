import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_vendor_app/activities/add_product/model/addproduct.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/utils/strings/app_constants.dart';

import '../../apiservice/api_call.dart';
import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/asset_constants.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../../utils/shared_preferences.dart';
import '../../utils/utility.dart';
import '../../widgets/cupertino_viewer.dart';
import '../../widgets/form_submit_widget.dart';
import '../../widgets/material_viewer.dart';
import 'model/attributes_model.dart';

class NewAttributeScreen extends StatefulWidget {
  VariationsQuantity variation;
  var attributes;
  Function(int)? deleteCallBack;
  Function(VariationsQuantity, int)? saveCallBack;

  int p;
  NewAttributeScreen(
      {Key? key,
      required this.variation,
      required this.attributes,
      required this.deleteCallBack,
      required this.saveCallBack,
      required this.p})
      : super(key: key);
  @override
  _NewAttributeScreenState createState() => _NewAttributeScreenState();
}

class _NewAttributeScreenState extends State<NewAttributeScreen>
    implements ApiInterface {
  var token;
  final formkey = GlobalKey<FormState>();

  List<String> imageList = [];
  List<bool> imageListType = [];
  VariationsQuantity data = VariationsQuantity();

  List<String> imageListAws = [];
  int p = 0;
  String whichApiCall = "";
  List<Data>? dataModel = [];

  TextEditingController offerPriceController = TextEditingController();
  TextEditingController basePriceController = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  List<Color> currentColors = [Colors.yellow, Colors.green];
  List<Color> colorHistory = [];

  Color? currentColor;

  void changeColor(Color color) => setState(() => currentColor = color);
  void changeColors(List<Color> colors) =>
      setState(() => currentColors = colors);
  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
    });
  }

  @override
  void initState() {
    super.initState();
    data = widget.variation;
    print(
        widget.attributes![0].name! + " " + data.attributes!.length.toString());
    if (data.images != null) {
      print(data.images!);
      if (data.images!.contains(",")) {
        for (int i = 0; i < data.images!.split(",").length; i++) {
          imageListAws.add(data.images!.split(",")[i]);
          if (data.images!.split(",")[i] == data.default_variation_image) {
            imageListType.add(true);
          } else {
            imageListType.add(false);
          }
          imageList.add(data.images!.split(",")[i]);
        }
      } else {
        imageListAws.add(data.images!);
        imageListType.add(true);
        imageList.add(data.images!);
      }
    }
    setState(() {});
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: data.isEdit! ? 3 : 1,
                  color: data.isEdit! ? Colors.green : Colors.grey)),
          child: Form(
              key: formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Wrap(
                        children: [
                          for (int i = 0; i < data.attributes!.length; i++)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: attributeValueTextFormFiled(data
                                            .attributes![i].attributeName!)),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    data.attributes![i].attributeName! ==
                                            "COLOR"
                                        ? Container()
                                        : Expanded(
                                            flex: 1,
                                            child: valueTextFormFiled(
                                                data.attributes![i]
                                                            .attributeValue ==
                                                        null
                                                    ? ""
                                                    : data.attributes![i]
                                                        .attributeValue!,
                                                i)),
                                    widget.attributes![i].units!.isNotEmpty
                                        ? const SizedBox(
                                            width: 5,
                                          )
                                        : Container(),
                                    widget.attributes![i].units!.isEmpty
                                        ? Container()
                                        : Expanded(
                                            flex: 1,
                                            child: data.attributes![i]
                                                        .attributeName! ==
                                                    "COLOR"
                                                ? colorTextFormFiled(
                                                    data.attributes![i]
                                                                .unit_name ==
                                                            null
                                                        ? ""
                                                        : data.attributes![i]
                                                            .unit_name!,
                                                    i,
                                                  )
                                                : unitTextFormFiled(
                                                    data.attributes![i]
                                                                .unit_name ==
                                                            null
                                                        ? ""
                                                        : data.attributes![i]
                                                            .unit_name!,
                                                    i),
                                          )
                                  ],
                                ),
                                Dimens.boxHeight10,
                              ],
                            )
                        ],
                      ),
                      Dimens.boxHeight10,
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        Row(children: [
                          Expanded(
                            flex: 1,
                            child: basePriceTextFormFiled(
                                data.basicPrice == null
                                    ? ""
                                    : data.basicPrice!),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              flex: 1,
                              child: offerPriceTextFormFiled(
                                  data.offerPrice == null
                                      ? ""
                                      : data.offerPrice!)),
                        ]),
                        Dimens.boxHeight10,
                        qtyTextFormFiled(
                            data.quantity == null ? "" : data.quantity!),
                        Dimens.boxHeight10,
                        Row(
                          children: [
                            for (int i = 0; i < imageListAws.length; i++)
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 80,
                                  height: 80,
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: () {
                                              for (int i = 0;
                                                  i < imageListType.length;
                                                  i++) {
                                                imageListType[i] = false;
                                              }
                                              imageListType[i] = true;
                                              data.default_variation_image =
                                                  imageListAws[i];
                                              setState(() {});
                                            },
                                            child: Container(
                                              width: 60,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                  border: imageListType[i] ==
                                                          false
                                                      ? null
                                                      : Border.all(
                                                          width: 3,
                                                          color: Colors.green),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                              child: CachedNetworkImage(
                                                imageUrl: imageListAws[i],
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  width: 60,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    shape: BoxShape.rectangle,
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    Container(
                                                  width: 60,
                                                  height: 60.0,
                                                  alignment: Alignment.center,
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
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                  ),
                                                  child: const Icon(
                                                    Icons.error,
                                                    size: 30,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          alignment: Alignment.topRight,
                                          width: 80,
                                          height: 80,
                                          child: GestureDetector(
                                            onTap: () {
                                              imageList.removeAt(i);
                                              imageListType.removeAt(i);
                                              imageListAws.removeAt(i);
                                              p = p - 1;
                                              setState(() {});
                                            },
                                            child: const Icon(
                                              Icons.cancel,
                                              color: AppColors.primaryColor,
                                              size: 20,
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                            p == 7
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      getUploadBottomSheet(context, 1);
                                    },
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: AppColors.darkBlueColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        )
                      ]),
                    ]),
                  ),
                  Dimens.boxHeight20,
                  Container(
                    alignment: Alignment.centerRight,
                    height: 30,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            widget.deleteCallBack!(widget.p);
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(
                              fontFamily: AppConstants.appMediumFontFamily,
                              fontWeight: FontWeight.normal,
                              color: AppColors.primaryColor,
                              fontSize: Dimens.sixTeen,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (formkey.currentState!.validate()) {
                              if (imageListAws.isNotEmpty) {
                                data.isEdit = true;
                                var image = "";
                                for (int i = 0; i < imageListAws.length; i++) {
                                  if (image == "") {
                                    image = imageListAws[i];
                                  } else {
                                    image = image + "," + imageListAws[i];
                                  }
                                }
                                for (int i = 0; i < imageListType.length; i++) {
                                  if (imageListType[i] == true) {
                                    data.default_variation_image =
                                        imageListAws[i];
                                    break;
                                  }
                                }
                                data.images = image;
                                widget.saveCallBack!(data, widget.p);

                                setState(() {});
                              } else {
                                Utility.errorMessage(
                                    "Please add atleast one image", context);
                              }
                            }
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontFamily: AppConstants.appMediumFontFamily,
                              fontWeight: FontWeight.normal,
                              color: AppColors.primaryColor,
                              fontSize: Dimens.sixTeen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ))),
    );
  }

  void getUploadBottomSheet(BuildContext context, int index) async {
    final buttons = [
      {
        'buttonName':
            NewMarkitVendorLocalizations.of(context)!.find('openCamera'),
        'buttonIcon': Icons.camera_alt_outlined,
        'onTap': () {
          getImage(ImageSource.camera, index);
          Navigator.pop(context);
        },
        'isCancelButton': false,
      },
      {
        'buttonName':
            NewMarkitVendorLocalizations.of(context)!.find('openGallery'),
        'buttonIcon': CupertinoIcons.photo_on_rectangle,
        'onTap': () async {
          getImage(ImageSource.gallery, index);
          Navigator.pop(context);
        },
        'isCancelButton': false,
      },
    ];
    if (Platform.isIOS) {
      await showCupertinoModalPopup<dynamic>(
        context: context,
        builder: (context) => CupertinoViewer(
          buttons: buttons,
        ),
      );
    } else {
      await showModalBottomSheet<dynamic>(
        context: context,
        backgroundColor: Theme.of(context).canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        builder: (_) => MaterialViewer(
          buttons: buttons,
        ),
      );
    }
  }

  void getImage(ImageSource source, int index) async {
    try {
      final ImagePicker picker = ImagePicker();

      var pickedFile = await picker.pickImage(source: source);

      var croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile!.path,
          cropStyle: CropStyle.rectangle,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
            toolbarTitle:
                NewMarkitVendorLocalizations.of(context)!.find('appName'),
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          iosUiSettings: const IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      debugPrint(croppedFile!.path);
      if (croppedFile.path.isNotEmpty) {
        imageList.add(croppedFile.path);
        imageListType.add(false);
        whichApiCall = "upload_image";
        p = p + 1;
        data.isEdit = false;

        setState(() {});

        Utility.dialogLoader(context);

        ApiCall.uploadProductImage(croppedFile.path, this, context, token);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onFailure(message) {
    Navigator.pop(context);
  }

  @override
  void onSuccess(data) {
    Navigator.pop(context);

    if (whichApiCall == "upload_image") {
      imageListAws.add(data['url']);
      imageListType[0] = true;
    } else {}
    setState(() {});
  }

  @override
  void onTokenExpired() {}

  //--------------view controller===========================
  _validateInput() {}

  attributeValueTextFormFiled(String value) {
    return TextFormField(
      controller: TextEditingController(text: value),
      readOnly: true,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      onTap: () {},
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('attributes'),
        labelStyle: Styles.lightGrey14,
        hintStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  withoutUnitTextFormFiled(var v, int attributePos) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: TextEditingController(text: v),
      cursorColor: AppColors.primaryColor,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.text,
      onChanged: (v) {
        data.attributes![attributePos].attributeValue = v;
        data.attributes![attributePos].unit_id = "0";
        data.isEdit = false;
      },
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('value'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  valueTextFormFiled(var v, int attributePos) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: TextEditingController(text: v),
      cursorColor: AppColors.primaryColor,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.text,
      onChanged: (v) {
        data.attributes![attributePos].attributeValue = v;
        data.isEdit = false;
      },
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('value'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  colorTextFormFiled(var v, int attributePos) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: TextEditingController(text: v),
      readOnly: true,
      cursorColor: AppColors.primaryColor,
      style: TextStyle(
        fontFamily: AppConstants.appMediumFontFamily,
        fontWeight: FontWeight.normal,
        color: AppColors.blackColor,
        fontSize: Dimens.sixTeen,
      ),
      keyboardType: TextInputType.emailAddress,
      onTap: () {
        isColorsBottomSheet(context, attributePos);
      },
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
          labelText:
              NewMarkitVendorLocalizations.of(context)!.find('selectColor'),
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

  unitTextFormFiled(var v, int attributePos) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: TextEditingController(text: v),
      readOnly: true,
      cursorColor: AppColors.primaryColor,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.emailAddress,
      onTap: () {
        isUnitBottomSheet(context, attributePos);
      },
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
          labelText: NewMarkitVendorLocalizations.of(context)!.find('unit'),
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

  setUnitView() {
    setState(() {});
  }

  void isColorsBottomSheet(BuildContext ctx, int i) {
    List<Units> units = widget.attributes![i].units!;

    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2 - 100,
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
                                .find('selectColor'),
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
                  Expanded(
                      flex: 1,
                      child: ListView.builder(
                          itemCount: units.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                data.attributes![i].unit_id =
                                    units[index].id.toString();
                                data.attributes![i].unit_name =
                                    units[index].name!;
                                data.attributes![i].attributeValue =
                                    units[index].value!;
                                data.isEdit = false;

                                setUnitView();
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
                                        data.attributes![i].unit_id =
                                            units[index].id.toString();
                                        data.attributes![i].unit_name =
                                            units[index].name!;
                                        data.attributes![i].attributeValue =
                                            units[index].value!;
                                        data.isEdit = false;
                                        setUnitView();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        units[index].name!,
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

  void isUnitBottomSheet(BuildContext ctx, int i) {
    List<Units> units = widget.attributes![i].units!;

    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2 - 100,
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
                                .find('unit'),
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
                  Expanded(
                      flex: 1,
                      child: ListView.builder(
                          itemCount: units.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                data.attributes![i].unit_id =
                                    units[index].id.toString();
                                data.attributes![i].unit_name =
                                    units[index].name!;
                                data.isEdit = false;

                                setUnitView();
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
                                        data.attributes![i].unit_id =
                                            units[index].id.toString();
                                        data.attributes![i].unit_name =
                                            units[index].name!;
                                        data.isEdit = false;

                                        setUnitView();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        units[index].name!,
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

  basePriceTextFormFiled(var t) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: TextEditingController(text: t),
      cursorColor: AppColors.primaryColor,
      style: Styles.formFieldTextStyle,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (v) {
        data.basicPrice = v;
        data.isEdit = false;
      },
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('basePrice'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  offerPriceTextFormFiled(var t) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: TextEditingController(text: t),
      cursorColor: AppColors.primaryColor,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      onChanged: (v) {
        data.offerPrice = v;
        data.isEdit = false;
      },
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('offerPrice'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  qtyTextFormFiled(var t) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: TextEditingController(text: t),
      cursorColor: AppColors.primaryColor,
      style: Styles.formFieldTextStyle,
      keyboardType: TextInputType.number,
      validator: (v) => Utility.checkTextFiledValid(v!, context),
      onChanged: (v) {
        data.quantity = v;
        data.isEdit = false;
      },
      decoration: InputDecoration(
        labelText: NewMarkitVendorLocalizations.of(context)!.find('qty'),
        labelStyle: Styles.lightGrey14,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  void showColorPicker(int p) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Pick a color"),
            content: SingleChildScrollView(
              child: MaterialPicker(
                pickerColor:
                    currentColor == null ? Colors.amber : currentColor!,
                onColorChanged: (Color color) {
                  String c = color.value.toRadixString(16);
                  c = "#" +
                      color.value.toRadixString(16).substring(2, c.length);
                  print(c);

                  currentColor = color;
                  data.attributes![p].attributeValue = c;
                  data.attributes![p].unit_id = "0";
                },
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Got it'),
                onPressed: () {
                  data.isEdit = false;

                  setUnitView();

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
