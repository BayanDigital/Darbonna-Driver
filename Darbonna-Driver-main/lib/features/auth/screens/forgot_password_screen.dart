import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/auth/domain/enums/verification_from_enum.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/theme/app_colors.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/screens/verification_screen.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/text_field_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          title: Text(
            'forgot_password'.tr,
            style: textBold.copyWith(
              color: AppColors.mainText,
              fontSize: 20.sp,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.mainText,
              size: 25.sp,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),

        // AppBarWidget(
        //   title: 'forget_password'.tr,
        //   showBackButton: true,
        //   regularAppbar: true,
        // ),
        body: GetBuilder<AuthController>(builder: (authController) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radiusExtraLarge),
                      topRight: Radius.circular(Dimensions.radiusExtraLarge),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                              height: Dimensions.orderStatusIconHeight),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: Image.asset(
                                        Images.forgotPasswordLogo,
                                        width: 150)),
                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),
                              ]),
                          Row(children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('forgot_password'.tr,
                                      style: textBold.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontSize:
                                              Dimensions.fontSizeExtraLarge)),
                                  Text('enter_your_verified_phone_number'.tr,
                                      style: textRegular.copyWith(
                                          color: Theme.of(context).hintColor)),
                                  const SizedBox(
                                    height: Dimensions.paddingSizeLarge,
                                  ),
                                ]),
                          ]),
                          TextFieldWidget(
                            hintText: 'phone'.tr,
                            inputType: TextInputType.number,
                            countryDialCode: authController.countryDialCode,
                            controller: phoneController,
                            onCountryChanged: (CountryCode countryCode) {
                              authController.countryDialCode =
                                  countryCode.dialCode!;
                              authController
                                  .setCountryCode(countryCode.dialCode!);
                            },
                            autoFocus: phoneController.text.isEmpty,
                          ),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),
                          authController.isOtpSending
                              ? Center(
                                  child: SpinKitCircle(
                                      color: Theme.of(context).primaryColor,
                                      size: 40.0))
                              : ButtonWidget(
                                  buttonText: 'send_otp'.tr,
                                  radius: 50,
                                  onPressed: () {
                                    String phoneNumber = phoneController.text;
                                    if (phoneNumber.isEmpty) {
                                      snackBarWidget('phone_is_required'.tr);
                                    } else {
                                      if (Get.find<SplashController>()
                                              .config
                                              ?.isFirebaseOtpVerification ??
                                          false) {
                                        authController.firebaseOtpSend(
                                            countryCode:
                                                authController.countryDialCode,
                                            number: phoneNumber,
                                            from: VerificationForm.reset);
                                      } else if (Get.find<SplashController>()
                                              .config
                                              ?.isSmsGateway ??
                                          false) {
                                        authController
                                            .sendOtp(
                                                countryCode: authController
                                                    .countryDialCode,
                                                number: phoneNumber)
                                            .then((value) {
                                          if (value.statusCode == 200) {
                                            Get.to(() => VerificationScreen(
                                                  countryCode: authController
                                                      .countryDialCode,
                                                  number: phoneNumber,
                                                  form: VerificationForm.reset,
                                                ));
                                          }
                                        });
                                      } else {
                                        snackBarWidget(
                                            'sms_gateway_not_integrate'.tr);
                                      }
                                    }
                                  },
                                ),
                        ]),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
