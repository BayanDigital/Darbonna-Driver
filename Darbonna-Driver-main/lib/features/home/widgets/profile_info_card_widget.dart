import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/theme/app_colors.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/loader_widget.dart';

class ProfileStatusCardWidget extends StatelessWidget {
  final ProfileController profileController;
  const ProfileStatusCardWidget({super.key, required this.profileController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: .1),
                blurRadius: 8,
                spreadRadius: 0.8,
                offset: const Offset(5, 5),
              ),
            ],
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
            border: Border.all(
              width: .5,
              color: AppColors.greyColor,
            )),
        child: profileController.profileInfo != null &&
                profileController.profileInfo!.firstName != null
            ? Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSize),
                child: Row(children: [
                  SizedBox(
                      child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    child: ImageWidget(
                      width: 40,
                      height: 40,
                      image:
                          '${Get.find<SplashController>().config!.imageBaseUrl!.profileImage}/${profileController.profileInfo!.profileImage}',
                    ),
                  )),
                  const SizedBox(width: Dimensions.paddingSizeDefault),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          '${profileController.profileInfo!.firstName!}  ${profileController.profileInfo!.lastName!}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textBold.copyWith(
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                            fontSize: Dimensions.fontSizeLarge,
                          ),
                        ),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        if (Get.find<SplashController>().config!.levelStatus!)
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: .10),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.paddingSizeExtraSmall),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                                horizontal: Dimensions.paddingSizeExtraSmall,
                              ),
                              child: Text(
                                profileController.profileInfo!.level != null
                                    ? profileController
                                        .profileInfo!.level!.name!
                                    : '',
                                style: textRegular.copyWith(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                      ])),
                  FlutterSwitch(
                      width: 95.0,
                      height: 30.0,
                      valueFontSize: 14.0,
                      toggleSize: 28.0,
                      value: profileController.isOnline == "1",
                      borderRadius: 30.0,
                      padding: 3,
                      activeColor: AppColors.successColor.withOpacity(.4),
                      toggleBorder: Border.all(
                          width: 5, color: Colors.white.withValues(alpha: .75)),
                      activeText: 'online'.tr,
                      inactiveText: 'offline'.tr,
                      activeTextColor: AppColors.successColor,
                      showOnOff: true,
                      activeTextFontWeight: FontWeight.w700,
                      toggleColor: Colors.green,
                      onToggle: (val) async {
                        Get.dialog(const LoaderWidget(),
                            barrierDismissible: false);
                        await profileController
                            .profileOnlineOffline(val)
                            .then((value) {
                          if (value.statusCode == 200) {
                            Get.back();
                          }
                        });
                      }),
                ]),
              )
            : const SizedBox(),
      ),
    );
  }
}
