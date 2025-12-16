import 'dart:convert' show jsonDecode, json;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:market_vendor_app/activities/create_business/model/business_model.dart';
import 'package:market_vendor_app/activities/edit_profile/model/business_address_model.dart';
import 'package:market_vendor_app/activities/edit_profile/model/business_other_details_model.dart';
import 'package:market_vendor_app/activities/edit_profile/model/edit_working_jours_model.dart';
import 'package:market_vendor_app/apiservice/url_string.dart';
import 'package:market_vendor_app/utils/new_market_vendor_localizations.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:market_vendor_app/utils/utility.dart';

import '../activities/add_product/model/addproduct.dart';
import 'api_interface.dart';
import 'key_string.dart';

class ApiCall {
  static Future<http.Response?> deleteAccount(
      String token, ApiInterface callBack, BuildContext context) async {
    print(token);
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.get(Uri.parse(UrlConstant.deleteAccount), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> getBusinessList(
      ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http
            .get(Uri.parse(UrlConstant.categoriesByBusinessType), headers: {
          "Accept": "application/json",
        });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> sendOtpApi(
      String phone, ApiInterface callBack, BuildContext context) async {
    print(UrlConstant.sendOtp);
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.post(Uri.parse(UrlConstant.sendOtp), headers: {
          "Accept": "application/json"
        }, body: {
          KeyConstant.phone: phone,
        });

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          print(response.body);

          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.

          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        print(e.toString());
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> forgotApi(String phone, String password,
      ApiInterface callBack, BuildContext context) async {
    print(phone + " " + password);
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.post(Uri.parse(UrlConstant.updatePassword), headers: {
          "Accept": "application/json",
        }, body: {
          KeyConstant.phone: phone,
          KeyConstant.password: password,
          KeyConstant.type: "vendor",
        });

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          print(response.body);

          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.

          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        print(e.toString());
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> loginOtpApi(String phone, String otp,
      String version, ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.post(Uri.parse(UrlConstant.vendorLoginWith), headers: {
          "Accept": "application/json"
        }, body: {
          KeyConstant.phone: phone,
          KeyConstant.otp: otp,
          KeyConstant.appVersion: version,
          KeyConstant.deviceType: Platform.isAndroid ? "android" : "ios",
          KeyConstant.oneSignalId: SharedPref.getPlayerID()
        });
        print(response.body);
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> verifyOtpApi(String phone, String otp,
      ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.post(Uri.parse(UrlConstant.verifyUserOtp), headers: {
          "Accept": "application/json"
        }, body: {
          KeyConstant.phone: phone,
          KeyConstant.otp: otp,
        });

        if (response.statusCode == 200) {
          print(response.body);
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> loginWithPasswordApi(
      String phone,
      String password,
      String version,
      ApiInterface callBack,
      BuildContext context) async {
    print("version  " + version + " " + SharedPref.getPlayerID());
    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http
            .post(Uri.parse(UrlConstant.vendorLoginWithPassword), headers: {
          "Accept": "application/json"
        }, body: {
          KeyConstant.phone: phone,
          KeyConstant.password: password,
          KeyConstant.appVersion: "",
          KeyConstant.deviceType: Platform.isAndroid ? "android" : "ios",
          KeyConstant.oneSignalId: SharedPref.getPlayerID()
        });
print(response.body);
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<dynamic> createVendorRegister(
      String phone,
      String name,
      String email,
      String password,
      String gender,
      String profile,
      String version,
      ApiInterface callBack,
      BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        var postUri = Uri.parse(UrlConstant.vendorRegister);
        var request = await http.MultipartRequest('POST', postUri);
        request.fields[KeyConstant.phone] = phone;

        request.fields[KeyConstant.name] = name;

        request.fields[KeyConstant.email] = email;
        request.fields[KeyConstant.password] = password;
        request.fields[KeyConstant.latitude] = "3.725";
        request.fields[KeyConstant.longitude] = "71.23";
        request.fields[KeyConstant.gender] = gender;
        request.fields[KeyConstant.appVersion] = version;
        request.fields[KeyConstant.deviceType] =
            Platform.isAndroid ? "android" : "ios";
        request.fields[KeyConstant.oneSignalId] = SharedPref.getPlayerID();

        Map<String, String> headers = {
          "Accept": "application/json",
          "content-type": "application/json",
        };
        request.headers.addAll(headers);
        if (profile != "") {
          var multipartFile =
              await http.MultipartFile.fromPath(KeyConstant.profile, profile);
          request.files.add(multipartFile);
        }
        var streamedResponse = await request.send();
        /* streamedResponse.stream.transform(utf8.decoder).listen((value) {
      print("Response ===> $value");

    });*/
        final response = await http.Response.fromStream(streamedResponse);
        final int statusCode = response.statusCode;
        print("statusCode" + response.body);

        if (statusCode < 200 || statusCode > 400 || json == null) {
          callBack.onFailure("Failed to upload");

          throw new Exception("Error while fetching data");
        } else {
          var data = json.decode(response.body);
          print(data);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<dynamic> vendorUpdate(
      String name,
      String email,
      String phone,
      String gender,
      String profile,
      String token,
      ApiInterface callBack,
      BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        var postUri = Uri.parse(UrlConstant.vendorUpdate);
        var request = await http.MultipartRequest('POST', postUri);

        request.fields[KeyConstant.name] = name;
        request.fields[KeyConstant.phone] = phone;

        request.fields[KeyConstant.email] = email;

        request.fields[KeyConstant.gender] = gender;

        Map<String, String> headers = {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        };
        print(request.fields);
        request.headers.addAll(headers);
        if (profile != "") {
          var multipartFile =
              await http.MultipartFile.fromPath(KeyConstant.profile, profile);
          request.files.add(multipartFile);
        }
        var streamedResponse = await request.send();
        /* streamedResponse.stream.transform(utf8.decoder).listen((value) {
      print("Response ===> $value");

    });*/
        final response = await http.Response.fromStream(streamedResponse);
        final int statusCode = response.statusCode;
        print("statusCode" + response.body);

        if (statusCode < 200 || statusCode > 400 || json == null) {
          callBack.onFailure("Failed to upload");

          throw new Exception("Error while fetching data");
        } else {
          var data = json.decode(response.body);
          print(data);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<dynamic> updateBusinessAddressApi(
    BusinessAddressModel model,
    String token,
    ApiInterface callBack,
    BuildContext context,
  ) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        print(json.encode(model.toJson()));
        final response =
            await http.post(Uri.parse(UrlConstant.updateBusinessAddress),
                headers: {
                  "Accept": "application/json",
                  "content-type": "application/json",
                  "Authorization": "Bearer $token",
                },
                body: json.encode(model.toJson()));
        var data = json.decode(response.body);
        print(data);
        if (response.statusCode > 400 || response.statusCode < 200) {
          callBack.onFailure(data['message']);
        } else {
          if (response.statusCode == 200) {
            if (data['status'] == 1) {
              callBack.onSuccess(data);
            } else {
              callBack.onFailure(data['message']);
            }

            // If server returns an OK response, parse the JSON
          } else {
            callBack.onFailure(data['message']);
            //callBack.onFailure("something went wrong");

            // If that response was not OK, throw an error.
            throw Exception('Failed to load post');
          }
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<dynamic> businessUpdate(
    BusinessOtherDetailsModel model,
    String token,
    ApiInterface callBack,
    BuildContext context,
  ) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        print(json.encode(model.toJson()));
        final response = await http.post(Uri.parse(UrlConstant.businessUpdate),
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: json.encode(model.toJson()));
        var data = json.decode(response.body);
        print(data);
        if (response.statusCode > 400 || response.statusCode < 200) {
          callBack.onFailure(data['message']);
        } else {
          if (response.statusCode == 200) {
            if (data['status'] == 1) {
              callBack.onSuccess(data);
            } else {
              callBack.onFailure(data['message']);
            }

            // If server returns an OK response, parse the JSON
          } else {
            callBack.onFailure(data['message']);
            //callBack.onFailure("something went wrong");

            // If that response was not OK, throw an error.
            throw Exception('Failed to load post');
          }
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<dynamic> updateWorkingHoursApi(
    EditWorkingHoursModel model,
    String token,
    ApiInterface callBack,
    BuildContext context,
  ) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        print(json.encode(model.toJson()));
        final response =
            await http.post(Uri.parse(UrlConstant.updateWorkingHours),
                headers: {
                  "Accept": "application/json",
                  "content-type": "application/json",
                  "Authorization": "Bearer $token",
                },
                body: json.encode(model.toJson()));
        var data = json.decode(response.body);
        print(data);
        if (response.statusCode > 400 || response.statusCode < 200) {
          callBack.onFailure(data['message']);
        } else {
          if (response.statusCode == 200) {
            if (data['status'] == 1) {
              callBack.onSuccess(data);
            } else {
              callBack.onFailure(data['message']);
            }

            // If server returns an OK response, parse the JSON
          } else {
            callBack.onFailure(data['message']);
            //callBack.onFailure("something went wrong");

            // If that response was not OK, throw an error.
            throw Exception('Failed to load post');
          }
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<dynamic> createBusinessApi(
    BusinessModel model,
    String token,
    ApiInterface callBack,
    BuildContext context,
  ) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        print(json.encode(model.toJson()));
        final response = await http.post(Uri.parse(UrlConstant.businessCreate),
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: json.encode(model.toJson()));
        var data = json.decode(response.body);
        print(data);
        if (response.statusCode > 400 || response.statusCode < 200) {
          callBack.onFailure(data['message']);
        } else {
          if (response.statusCode == 200) {
            if (data['status'] == 1) {
              callBack.onSuccess(data);
            } else {
              callBack.onFailure(data['message']);
            }

            // If server returns an OK response, parse the JSON
          } else {
            callBack.onFailure(data['message']);
            //callBack.onFailure("something went wrong");

            // If that response was not OK, throw an error.
            throw Exception('Failed to load post');
          }
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<dynamic> newploadBusinessImage(String profile,
      ApiInterface callBack, BuildContext context, String token) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        var postUri = Uri.parse(UrlConstant.uploadImage);
        var request = await http.MultipartRequest('POST', postUri);

        Map<String, String> headers = {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        };
        request.headers.addAll(headers);
        if (profile != "") {
          var multipartFile =
              await http.MultipartFile.fromPath(KeyConstant.image, profile);
          request.files.add(multipartFile);
        }
        var streamedResponse = await request.send();
        /* streamedResponse.stream.transform(utf8.decoder).listen((value) {
      print("Response ===> $value");

    });*/
        final response = await http.Response.fromStream(streamedResponse);
        final int statusCode = response.statusCode;
        print("statusCode" + response.body);
        if (statusCode < 200 || statusCode > 400 || json == null) {
          callBack.onFailure("Failed to upload");

          throw new Exception("Error while fetching data");
        } else {
          var data = json.decode(response.body);
          print(data);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
        }
      } catch (e) {
        print(e.toString());
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<dynamic> uploadBusinessImage(String profile,
      ApiInterface callBack, BuildContext context, String token) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        var postUri = Uri.parse(UrlConstant.uploadBusinessImages);
        var request = await http.MultipartRequest('POST', postUri);

        Map<String, String> headers = {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        };
        request.headers.addAll(headers);
        if (profile != "") {
          var multipartFile =
              await http.MultipartFile.fromPath(KeyConstant.image, profile);
          request.files.add(multipartFile);
        }
        var streamedResponse = await request.send();
        /* streamedResponse.stream.transform(utf8.decoder).listen((value) {
      print("Response ===> $value");

    });*/
        final response = await http.Response.fromStream(streamedResponse);
        final int statusCode = response.statusCode;
        print("statusCode" + response.body);
        if (statusCode < 200 || statusCode > 400 || json == null) {
          callBack.onFailure("Failed to upload");

          throw new Exception("Error while fetching data");
        } else {
          var data = json.decode(response.body);
          print(data);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
        }
      } catch (e) {
        print(e.toString());
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<dynamic> uploadProductImage(String profile,
      ApiInterface callBack, BuildContext context, String token) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        var postUri = Uri.parse(UrlConstant.uploadProductImages);
        var request = await http.MultipartRequest('POST', postUri);

        Map<String, String> headers = {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        };
        request.headers.addAll(headers);
        if (profile != "") {
          var multipartFile =
              await http.MultipartFile.fromPath(KeyConstant.image, profile);
          request.files.add(multipartFile);
        }
        var streamedResponse = await request.send();
        /* streamedResponse.stream.transform(utf8.decoder).listen((value) {
      print("Response ===> $value");

    });*/
        final response = await http.Response.fromStream(streamedResponse);
        final int statusCode = response.statusCode;
        print("statusCode" + response.body);
        if (statusCode < 200 || statusCode > 400 || json == null) {
          callBack.onFailure("Failed to upload");

          throw new Exception("Error while fetching data");
        } else {
          var data = json.decode(response.body);
          print(data);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
        }
      } catch (e) {
        print(e.toString());
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> getCategoryList(
      String token, ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.get(Uri.parse(UrlConstant.vendorCategory), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> declineReson(
      String token, ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        print(UrlConstant.declineReason);
        final response =
            await http.get(Uri.parse(UrlConstant.declineReason), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> getVendorDetails(
      String token, ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.get(Uri.parse(UrlConstant.vendorDetails), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> changeStatus(
      String status,
      String order_id,
      String reasonId,
      String declined_reason,
      String images,
      String token,
      ApiInterface callBack,
      BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.post(Uri.parse(UrlConstant.changeStatus), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }, body: {
          KeyConstant.status: status,
          KeyConstant.orderId: order_id,
          KeyConstant.reasonId: reasonId,
          KeyConstant.images: images,
          KeyConstant.declinedReason: declined_reason,
        });

        if (response.statusCode == 200) {
          print(response.body);
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> changeOrderStatus(
      String status,
      String order_id,
      String requestId,
      String declined_reason,
      String image,
      String token,
      ApiInterface callBack,
      BuildContext context) async {
    print(status + " " + order_id + " " + requestId);
    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http
            .post(Uri.parse(UrlConstant.changeReturnOrderStatus), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }, body: {
          KeyConstant.status: status,
          KeyConstant.orderId: order_id,
          KeyConstant.request_id: requestId,
          KeyConstant.rejectReason: declined_reason,
          KeyConstant.delivery_image: image
        });

        if (response.statusCode == 200) {
          print(response.body);
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> vendorUpdatePassword(String password,
      String token, ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http
            .post(Uri.parse(UrlConstant.vendorUpdatePassword), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }, body: {
          KeyConstant.password: password,
        });

        if (response.statusCode == 200) {
          print(response.body);
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> getSubCategoryWithPageList(
      String category_id,
      String search,
      String page,
      String token,
      ApiInterface callBack,
      BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.post(Uri.parse(UrlConstant.vendorSubCategory), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }, body: {
          KeyConstant.category_id: category_id,
          KeyConstant.search: search,
          KeyConstant.page: page,
        });

        if (response.statusCode == 200) {
          print(response.body);
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> getSubCategoryList(String category_id,
      String token, ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http
            .post(Uri.parse(UrlConstant.subCategoryForAddingProduct), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }, body: {
          KeyConstant.category_id: category_id,
        });

        if (response.statusCode == 200) {
          print(response.body);
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> getVendorChilSubCategoryList(
      String category_id,
      String sub_category_id,
      String token,
      ApiInterface callBack,
      BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http
            .post(Uri.parse(UrlConstant.vendorChildSubCategory), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }, body: {
          KeyConstant.category_id: category_id,
          KeyConstant.sub_category_id: sub_category_id,
        });

        if (response.statusCode == 200) {
          print(response.body);
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> getAllChilSubCategoryList(
      String category_id,
      String sub_category_id,
      String search,
      String page,
      String token,
      ApiInterface callBack,
      BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        print(category_id +
            " " +
            sub_category_id +
            " " +
            page +
            " " +
            search +
            " " +
            token);

        final response = await http
            .post(Uri.parse(UrlConstant.vendorChildSubCategory), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }, body: {
          KeyConstant.category_id: category_id,
          KeyConstant.sub_category_id: sub_category_id,
          KeyConstant.type: "all",
          KeyConstant.page: page,
          KeyConstant.search: search
        });

        if (response.statusCode == 200) {
          print(response.body);
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> allProductwithCaterory(
      String category_id,
      String sub_category_id,
      String child_category_id,
      String search,
      String page,
      String token,
      ApiInterface callBack,
      BuildContext context) async {
    print(UrlConstant.allProductwithCaterory);
    print("category_id$category_id");
    print("sub_category_id$sub_category_id");
    print("child_category_id$child_category_id");
    print("search$search");

    print(token);

    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http
            .post(Uri.parse(UrlConstant.allProductwithCaterory), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }, body: {
          KeyConstant.category_id: category_id,
          KeyConstant.sub_category_id: sub_category_id,
          KeyConstant.child_category_id: child_category_id,
          KeyConstant.page: page,
          KeyConstant.search: search
        });

        if (response.statusCode == 200) {
          print(response.body);
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> brandList(
      String token, ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http
            .get(Uri.parse(UrlConstant.brandsByBusinessType), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> attributeList(
      String token, ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.get(Uri.parse(UrlConstant.attribute), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<dynamic> uploadProductApi(
    AddProductModel model,
    String token,
    ApiInterface callBack,
    BuildContext context,
  ) async {
    print(
        'maximum_shipping_cost:-${model.maximum_shipping_cost!}  video_url:-${model.video_url!}');
    if (await Utility.isNetworkAvailable()) {
      try {
        print(json.encode(model.toJson()));
        final response = await http.post(Uri.parse(UrlConstant.productStore),
            headers: {
              "content-type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: json.encode(model.toJson()));
        var data = json.decode(response.body) as Map<String, dynamic>;

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            print(data['message']);
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        }
      } catch (e) {
        print(e.toString());

        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<dynamic> editProductApi(
    AddProductModel model,
    String token,
    ApiInterface callBack,
    BuildContext context,
  ) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        print(json.encode(model.toJson()));
        final response = await http.post(Uri.parse(UrlConstant.productUpdate),
            headers: {
              "content-type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: json.encode(model.toJson()));
        var data = json.decode(response.body);
        print(data);
        if (response.statusCode > 400 || response.statusCode < 200) {
          callBack.onFailure(data['message']);
        } else {
          if (response.statusCode == 200) {
            if (data['status'] == 1) {
              callBack.onSuccess(data);
            } else {
              callBack.onFailure(data['message']);
            }

            // If server returns an OK response, parse the JSON
          } else {
            callBack.onFailure(data['message']);
            //callBack.onFailure("something went wrong");

            // If that response was not OK, throw an error.
            throw Exception('Failed to load post');
          }
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> getHomeDataApi(
      String token, ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.get(Uri.parse(UrlConstant.homePage), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> getProductsApi(String page, String search,
      String token, ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http.get(
            Uri.parse(UrlConstant.products + page + "&search=" + search),
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> ratingProductsApi(
      String type,
      String page,
      String search,
      String token,
      ApiInterface callBack,
      BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http.get(
            Uri.parse(UrlConstant.ratingReport +
                page +
                "&search=" +
                search +
                "&type=" +
                type),
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> deleteProductList(String product_id,
      String token, ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.post(Uri.parse(UrlConstant.productDelete), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }, body: {
          KeyConstant.product_id: product_id,
        });

        if (response.statusCode == 200) {
          print(response.body);
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> orderDetails(String id, String token,
      ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.post(Uri.parse(UrlConstant.details), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }, body: {
          KeyConstant.order_id: id,
        });

        if (response.statusCode == 200) {
          print(response.body);
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> returnOrderDetails(String id, String rId,
      String token, ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http
            .post(Uri.parse(UrlConstant.returnOrdersDetails), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }, body: {
          KeyConstant.order_id: id,
          KeyConstant.request_id: rId,
        });

        if (response.statusCode == 200) {
          print(response.body);
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> editDocument(
      String id,
      String imageNumber,
      String imagePath,
      String token,
      ApiInterface callBack,
      BuildContext context) async {
    print(id + " " + imageNumber + " " + imagePath + " " + token);
    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http
            .post(Uri.parse(UrlConstant.updateBusinessDocument), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }, body: {
          KeyConstant.id: id,
          KeyConstant.image: imagePath,
          KeyConstant.number: imageNumber,
        });

        if (response.statusCode == 200) {
          print(response.body);
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> hsnList(String id, String token,
      ApiInterface callBack, BuildContext context) async {
    print(id + " " + token);
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.get(Uri.parse(UrlConstant.hsnNumber + id), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });

        if (response.statusCode == 200) {
          print(response.body);
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> getReturnOrdersApi(String page, String token,
      ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http
            .get(Uri.parse(UrlConstant.returnOrders + page), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> getAllRecentOrderApi(String page, String token,
      ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http
            .get(Uri.parse(UrlConstant.allRecentOrder + page), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> getOrderStatusApi(
      String page,
      String type,
      String search,
      String token,
      ApiInterface callBack,
      BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http.get(
            Uri.parse(
                UrlConstant.ordersStatus + type + "&page=$page&search=$search"),
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> allRetrunOrdersApi(
      String page,
      String type,
      String search,
      String token,
      ApiInterface callBack,
      BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http.get(
            Uri.parse(UrlConstant.allReturnOrder +
                page +
                "&status=$type&search=$search"),
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> getStatusListApi(String id, String token,
      ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.get(Uri.parse(UrlConstant.statusList + id), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> productRatingApi(
      String pageNo,
      String ratingNo,
      String productId,
      String token,
      ApiInterface callBack,
      BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      print(
          '${UrlConstant.productRating}?product_id=$productId&rating_no=$ratingNo&page=$pageNo');
      try {
        print(Uri.parse(UrlConstant.vendorRating));
        final response = await http.get(
            Uri.parse(
                '${UrlConstant.productRating}?product_id=$productId&rating_no=$ratingNo&page=$pageNo'),
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> vendorRatingApi(
      String token, ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        print(Uri.parse(UrlConstant.vendorRating));
        final response =
            await http.get(Uri.parse(UrlConstant.vendorRating), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> ratingReportCount(
      String token, ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        print(Uri.parse(UrlConstant.allReport));
        final response =
            await http.get(Uri.parse(UrlConstant.ratingReportCount), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> ratingReportApi(String reviewId, String token,
      ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        print(Uri.parse(UrlConstant.allReport));
        final response =
            await http.post(Uri.parse(UrlConstant.allReport), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }, body: {
          'review_id': reviewId,
        });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> getStatesApi(
      String token, ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.get(Uri.parse(UrlConstant.states), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> getCitiesApi(String id, String token,
      ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.get(Uri.parse(UrlConstant.cities + id), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }
          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> checkBankApi(
      String ifscCode, ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http
            .get(Uri.parse(UrlConstant.bankAddress + ifscCode), headers: {
          "Accept": "application/json",
        });
        print(response.body.toString());

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          callBack.onSuccess(data);

          // If server returns an OK response, parse the JSON
        } else if (response.statusCode == 404) {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(
              NewMarkitVendorLocalizations.of(context)!.find('serverError'));
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> updateBankDetails(
      String id,
      String cancelCheckImage,
      String bankAccount,
      String bankName,
      String ifscCode,
      String accountHolderName,
      String token,
      ApiInterface callBack,
      BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.post(Uri.parse(UrlConstant.updateBankDetail), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }, body: {
          KeyConstant.business_id: id,
          KeyConstant.cancelled_cheque_image: cancelCheckImage,
          KeyConstant.bank_account: bankAccount,
          KeyConstant.bank_name: bankName,
          KeyConstant.ifsc_code: ifscCode,
          KeyConstant.account_holder_name: accountHolderName,
        });

        if (response.statusCode == 200) {
          print(response.body);
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> checkUser(String type, String id, String role,
      ApiInterface callBack, BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response =
            await http.post(Uri.parse(UrlConstant.checkUser), headers: {
          "Accept": "application/json"
        }, body: {
          KeyConstant.type: type,
          KeyConstant.id: id,
          KeyConstant.role: role,
        });
        print(response.body);
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }

  static Future<http.Response?> socialSignUpUser(
      String type,
      String id,
      String role,
      String email,
      String phone,
      String name,
      ApiInterface callBack,
      BuildContext context) async {
    if (await Utility.isNetworkAvailable()) {
      try {
        final response = await http
            .post(Uri.parse(UrlConstant.vendor_social_login), headers: {
          "Accept": "application/json"
        }, body: {
          KeyConstant.type: type,
          KeyConstant.id: id,
          KeyConstant.email: email,
          KeyConstant.phone: phone,
          KeyConstant.name: name,
          KeyConstant.role: role,
        });
        print(response.body);
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['status'] == 1) {
            callBack.onSuccess(data);
          } else if (data['status'] == 403) {
            callBack.onFailure(data['message']);
          } else {
            callBack.onFailure(data['message']);
          }

          // If server returns an OK response, parse the JSON
        } else {
          // If that response was not OK, throw an error.
          callBack.onFailure(response.statusCode);
        }
      } catch (e) {
        callBack.onFailure(
            NewMarkitVendorLocalizations.of(context)!.find('serverError'));
      }
    } else {
      callBack.onFailure(
          NewMarkitVendorLocalizations.of(context)!.find('internetError'));
    }
  }
}
