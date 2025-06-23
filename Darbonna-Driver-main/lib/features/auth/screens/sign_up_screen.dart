import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/screens/additional_sign_up_screen_1.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/signup_appbar_widget.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/theme/app_colors.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          Scaffold(body: GetBuilder<AuthController>(builder: (authController) {
        return Column(children: [
          const SignUpAppbarWidget(
              title: 'signup_as_a_driver', progressText: '1_of_3'),
          const SizedBox(height: Dimensions.paddingSizeSignUp),
          Expanded(
            child: SingleChildScrollView(
                child: Column(children: [
              Image.asset(Images.logoWithName, height: 40.h),
              const SizedBox(height: Dimensions.paddingSizeSignUp),
              Center(
                  child: Image.asset(Images.signUpScreenLogo,
                      width: 134.w, height: 90.h)),
              const SizedBox(height: Dimensions.paddingSizeSignUp),
              Text('choose_service'.tr,
                  style: textBold.copyWith(
                      color: Theme.of(context).primaryColor, fontSize: 22.sp)),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  'select_your_preferable_service'.tr,
                  style: textRegular.copyWith(
                      color: AppColors.mainText,
                      fontSize: Dimensions.fontSizeSmall),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSignUp),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  border: Border.all(
                    color: authController.isRideShare
                        ? Theme.of(context).primaryColor.withValues(alpha: 0.5)
                        : Theme.of(context).hintColor.withValues(alpha: 0.5),
                  ),
                  color: authController.isRideShare
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.05)
                      : null,
                ),
                child: Center(
                  child: CheckboxListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall),
                    title: Text('ride_share'.tr,
                        style: textBold.copyWith(
                            fontSize: 14,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color)),
                    value: authController.isRideShare,
                    onChanged: (value) {
                      authController.updateServiceType(true);
                    },
                    activeColor: Theme.of(context).primaryColor,
                    checkColor: Colors.white,
                    subtitle: Text('service_provide_text1'.tr,
                        style: textRegular.copyWith(
                          color: Theme.of(context).hintColor,
                          fontSize: 10,
                        )),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              // Container(
              //   margin: EdgeInsets.symmetric(
              //       horizontal: Dimensions.paddingSizeLarge),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              //     border: Border.all(
              //       color: authController.isParcelShare
              //           ? Theme.of(context).primaryColor.withValues(alpha: 0.5)
              //           : Theme.of(context).hintColor.withValues(alpha: 0.5),
              //     ),
              //     color: authController.isParcelShare
              //         ? Theme.of(context).primaryColor.withValues(alpha: 0.05)
              //         : null,
              //   ),
              //   child: Center(
              //     child: CheckboxListTile(
              //       contentPadding: const EdgeInsets.symmetric(
              //           horizontal: Dimensions.paddingSizeSmall),
              //       title: Text('parcel_delivery'.tr,
              //           style: textBold.copyWith(
              //               fontSize: 14,
              //               color:
              //                   Theme.of(context).textTheme.bodyMedium!.color)),
              //       value: authController.isParcelShare,
              //       onChanged: (value) {
              //         authController.updateServiceType(false);
              //       },
              //       activeColor: Theme.of(context).primaryColor,
              //       checkColor: Colors.white,
              //       subtitle: Text('service_provide_text2'.tr,
              //           style: textRegular.copyWith(
              //               color: Theme.of(context).hintColor, fontSize: 10)),
              //     ),
              //   ),
              // ),
            ])),
          ),
          ButtonWidget(
            margin:
                EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            radius: Dimensions.radiusExtraLarge,
            buttonText: 'next'.tr,
            onPressed: () {
              if (!authController.isRideShare &&
                  !authController.isParcelShare) {
                snackBarWidget('required_to_select_service'.tr);
              } else {
                Get.to(() => const AdditionalSignUpScreen1());
              }
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault)
        ]);
      })),
    );
  }
}
