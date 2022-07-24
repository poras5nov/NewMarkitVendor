import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../theme/dimens.dart';
import '../utils/new_market_vendor_localizations.dart';

/// [CupertinoViewer] widget show action sheet for IOS Devises.
///
class CupertinoViewer extends StatelessWidget {
  const CupertinoViewer({
    Key? key,
    @required this.buttons,
  }) : super(key: key);

  final List<Map<String, dynamic>>? buttons;

  @override
  Widget build(BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          ...List.generate(
            buttons!.length,
            (index) => (buttons![index]['isCancleButton'] as bool? ?? false)
                ? Dimens.box0
                : CupertinoActionSheetAction(
                    child: Text(buttons![index]['buttonName'] as String),
                    onPressed: buttons![index]['onTap'] as Function(),
                  ),
          ).toList(),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          child: Text(NewMarkitVendorLocalizations.of(context)!.find('cancel')),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
}
