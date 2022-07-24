import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/dimens.dart';
import '../theme/styles.dart';

/// [MaterialViewer] widget show action sheet for Android Devices.
///
class MaterialViewer extends StatelessWidget {
  const MaterialViewer({
    Key? key,
    @required this.buttons,
  }) : super(key: key);

  final List<Map<String, dynamic>>? buttons;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Dimens.boxHeight20,
              ...List.generate(
                buttons!.length,
                (index) => ListTile(
                  leading: (buttons![index]['isCancelButton'] as bool) == false
                      ? Icon(buttons![index]['buttonIcon'] as IconData, color: AppColors.primaryColor,)
                      : Dimens.box0,
                  title: Text(
                    buttons![index]['buttonName'] as String,
                    style: (buttons![index]['isCancelButton'] as bool)
                        ? Styles.grey14Medium
                        : null,
                  ),
                  onTap: buttons![index]['onTap'] as Function()?,
                ),
              ).toList(),
            ],
          ),
        ),
      );
}
