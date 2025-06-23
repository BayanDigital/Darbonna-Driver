import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/theme/app_colors.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class NoDataWidget extends StatelessWidget {
  final String? title;
  final bool fromHome;
  final bool showBorder; // ✅ new parameter

  const NoDataWidget({
    super.key,
    this.title,
    this.fromHome = false,
    this.showBorder = false, // ✅ default is false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0).r,
      child: Container(
        decoration: BoxDecoration(
          border: showBorder // ✅ only show border if true
              ? Border.all(
                  color: AppColors.primaryColor,
                  width: 1,
                )
              : null,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.60,
                  height: MediaQuery.of(context).size.width * 0.60,
                  child: Image.asset(
                    fromHome
                        ? Images.reward1
                        : title == 'no_transaction_found'
                            ? Images.noTransation
                            : title == "no_point_gain_yet"
                                ? Images.noPoint
                                : title == "no_trip_found"
                                    ? Images.noTrip
                                    : title == "no_notification_found"
                                        ? Images.noNotificaiton
                                        : title == "no_message_found"
                                            ? Images.noMessage
                                            : title == "no_review_found"
                                                ? Images.noReview
                                                : title == "no_review_saved_yet"
                                                    ? Images.noReview
                                                    : title ==
                                                            "no_channel_found"
                                                        ? Images.noMessage
                                                        : title ==
                                                                "start_conversation"
                                                            ? Images
                                                                .conversationIcon
                                                            : title ==
                                                                    "no_address_found"
                                                                ? Images
                                                                    .noLocation
                                                                : title ==
                                                                        "no_tripss_found"
                                                                    ? Images
                                                                        .reward1
                                                                    : Images
                                                                        .noDataFound,
                    width: title == "no_notification_found" ||
                            title == "no_tripss_found" ||
                            title == "no_message_found"
                        ? 80.w
                        : 100.w,
                    height: title == "no_notification_found" ? 80.h : 100.h,
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  title != null ? title!.tr : 'no_data_found'.tr,
                  style: textRegular.copyWith(
                    color: AppColors.mainText,
                    fontSize: MediaQuery.of(context).size.height * 0.023.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
