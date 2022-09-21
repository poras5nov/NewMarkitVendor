import 'dart:convert';

import '../shared_preferences.dart';

/// An asset constant class which will hold all the
/// assets path which are used in the application.
/// Will be ignored for test since all are static values and would not change.

// coverage:ignore-file
abstract class AppConstants {
  static String appMediumFontFamily = 'ArticoMedium';
  static String appBoldFontFamily = 'ArticoBold';
  static String appRegularFontFamily = 'ArticoRegular';
  static String appLightFontFamily = 'ArticoLight';

  static int retailerType = 0;
  static int serviceProviderType = 1;

  static String docTypePAN = 'pan';
  static String docTypeGST = 'gst';
  static String docTypeAadhaar = 'aadhaar';
  static String docTypePoliceClearance = 'policeClearance';
  static String docTypeCancelledCheque = 'cancelledCheque';
  static String priceSign = '\u{20B9}';
  static String oneSingnalAppId = 'afd8edf4-4460-4d30-8c09-d5128ed21b7f';
  static String oneSignal = 'one_signal';
  static String packed = 'packed';
  static String readyToPick = 'ready to pick';
  static String pickedUp = 'picked up';
  static String inProgress = 'in progress';
  static String accept = 'accept';
  static String declined = 'declined';
  static String delivered = 'delivered';

  static String completed = "completed";
  static String order_id = 'order_id';

  static String type = "type";

  static String requestId = "requestId";
}
