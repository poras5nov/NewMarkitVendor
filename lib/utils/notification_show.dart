import 'dart:convert';

import 'package:market_vendor_app/utils/notification_receiver.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:market_vendor_app/utils/strings/app_constants.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationShow {
  // static initPlatformState(NotificationInterface callBack) async {
  //   OneSignal.shared.init(AppConstants.oneSingnalAppId, iOSSettings: {
  //     OSiOSSettings.autoPrompt: true,
  //     OSiOSSettings.inAppLaunchUrl: true
  //   });
  //   OneSignal.shared
  //       .setInFocusDisplayType(OSNotificationDisplayType.notification);
  //   var status = await OneSignal.shared.getPermissionSubscriptionState();
  //   var playerId = status.subscriptionStatus.userId;
  //   print("One Signal Player ID == > $playerId ");
  //   SharedPref.savePlayerId(playerId);

  //   OneSignal.shared.setNotificationReceivedHandler((notification) {
  //     // int ID = notification.androidNotificationId;
  //     print("addinal data ${notification.payload.additionalData}");

  //     var data = json.encode(notification.payload.additionalData);
  //     Map p = jsonDecode(data);
  //     // SharedPref.setOrderID(p['order_id'].toString());
  //     // SharedPref.setOrderType(p['type']);
  //     // SharedPref.setRequestOrderId(p['request_id'].toString());
  //     callBack.onMessageReceived(p['order_id'], p['type']);
  //   });
  //   OneSignal.shared
  //       .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  //     // print("result typedsfgfgdfgdgdgdgdgdg");
  //     print("addinal data ${result.notification.payload.additionalData}");

  //     var data = json.encode(result.notification.payload.additionalData);
  //     Map p = jsonDecode(data);
  //     // print("result type==========" +
  //     //     result.notification.payload.rawPayload!.toString());
  //     SharedPref.setOrderID(p['order_id'].toString());
  //     SharedPref.setOrderType(p['type']);
  //     SharedPref.setRequestOrderId(p['request_id'].toString());
  //     callBack.onClick(p['order_id'], p['type'], p['request_id']);
  //   });
  //   OneSignal.shared
  //       .setInAppMessageClickedHandler((OSInAppMessageAction action) {});
  // }

  static initPlatformState(NotificationInterface callBack) async {
    await OneSignal.shared.setAppId(AppConstants.oneSingnalAppId);
    final status = await OneSignal.shared.getDeviceState();
    String? osUserID = status?.userId;
    print("One Signal Player ID == > $osUserID ");
    SharedPref.savePlayerId(osUserID!);
    await OneSignal.shared.promptUserForPushNotificationPermission(
      fallbackToSettings: true,
    );

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
      print("addinal data ${result.notification.additionalData}");

      var data = json.encode(result.notification.additionalData);
      Map p = jsonDecode(data);
      // print("result type==========" +
      //     result.notification.payload.rawPayload!.toString());
      SharedPref.setOrderID(p['order_id'].toString());
      SharedPref.setOrderType(p['type']);
      SharedPref.setRequestOrderId(p['request_id'].toString());
      callBack.onClick(p['order_id'], p['type'], p['request_id']);
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print('FOREGROUND HANDLER CALLED WITH: ${event}');
    });
  }
}
