import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/theme/app_colors.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/home/widgets/activity_card_widget.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/title_widget.dart';

class MyActivityListViewWidget extends StatelessWidget {
  const MyActivityListViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const TitleWidget(title: 'my_activity'),
      GetBuilder<ProfileController>(builder: (profileController) {
        int activeSec = 0, offlineSec = 0, drivingSec = 0, idleSec = 0;
        if (profileController.profileInfo != null &&
            profileController.profileInfo!.timeTrack != null) {
          activeSec =
              profileController.profileInfo!.timeTrack!.totalOnline!.floor();
          drivingSec =
              profileController.profileInfo!.timeTrack!.totalDriving!.floor();
          idleSec =
              profileController.profileInfo!.timeTrack!.totalIdle!.floor();
          offlineSec =
              profileController.profileInfo!.timeTrack!.totalOffline!.floor();
        }
        return profileController.profileInfo != null
            ? SizedBox(
                height: Get.find<LocalizationController>().isLtr ? 80 : 85,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    MyActivityCardWidget(
                      title: 'active',
                      icon: Images.activeHourIcon,
                      index: 0,
                      value: activeSec,
                      color: AppColors.primaryColor,
                    ),
                    MyActivityCardWidget(
                      title: 'on_driving',
                      icon: Images.onDrivingHourIcon,
                      index: 1,
                      value: drivingSec,
                      color: AppColors.greyColor,
                    ),
                    MyActivityCardWidget(
                      title: 'idle_time',
                      icon: Images.idleHourIcon,
                      index: 2,
                      value: idleSec,
                      color: AppColors.greyColor,
                    ),
                    MyActivityCardWidget(
                      title: 'offline',
                      icon: Images.offlineHourIcon,
                      index: 3,
                      value: offlineSec,
                      color: AppColors.greyColor,
                    ),
                  ],
                ),
              )
            : const SizedBox();
      }),
    ]);
  }
}
