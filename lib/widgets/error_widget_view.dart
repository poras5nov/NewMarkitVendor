import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/dimens.dart';
import '../theme/styles.dart';

class ErrorWidgetView extends StatelessWidget {
  ErrorWidgetView({
    Key? key,
    this.errorText,

  }) : super(key: key);

  final String? errorText;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (errorText != null && errorText!.isNotEmpty) Dimens.boxHeight3,
          if (errorText != null && errorText!.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_rounded,
                    color: AppColors.textFieldErrorColor, size: 20),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    errorText!.toString(),
                    maxLines: 10,
                    style: Styles.errorStyle,
                  ),
                ),
              ],
            ),
        ],
      );
}
