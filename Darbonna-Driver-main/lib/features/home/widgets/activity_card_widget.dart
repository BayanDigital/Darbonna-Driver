import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/theme/app_colors.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class MyActivityCardWidget extends StatelessWidget {
  final int index;
  final String title;
  final String icon;
  final int value;

  const MyActivityCardWidget({
    super.key,
    required this.index,
    required this.title,
    required this.icon,
    required this.value,
    required Color color,
  });

  @override
  Widget build(BuildContext context) {
    int hour = 0, min = 0;
    if (value >= 60) {
      hour = (value / 60).floor();
    }
    min = (value % 60).floor();

    // Define fixed colors based on index or title
    final bool isActive = title == "نشط";
    final Color borderColor =
        isActive ? Color(0xFFFFBF00) : AppColors.greyColor;
    final Color textColor = isActive ? Color(0xFFFFBF00) : AppColors.mainText;

    return Padding(
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textSemiBold.copyWith(
                      color: textColor,
                      fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),
                ),
                SizedBox(
                  width: Dimensions.iconSizeMedium,
                  child: Image.asset(
                    icon,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text(
              '$hour:$min hr',
              style: textSemiBold.copyWith(
                color: textColor,
                fontSize: Dimensions.fontSizeExtraLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
