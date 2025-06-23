import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/auth/screens/reset_password_screen.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/theme/app_colors.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/setting/controllers/setting_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBarWidget(title: 'settings'.tr, regularAppbar: true),
        body: GetBuilder<SettingController>(builder: (settingController) {
          return Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSize,
              ),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.r)),
                    ),
                    backgroundColor: Theme.of(context).cardColor,
                    builder: (_) => LanguageSelectionBottomSheet(),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius:
                        BorderRadius.circular(Dimensions.paddingSizeDefault),
                    border: Border.all(
                        width: 1.w, color: Theme.of(context).primaryColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Image.asset(
                          Images.languageIcon,
                          scale: 2,
                          width: 30.w,
                        ),
                        const SizedBox(width: Dimensions.paddingSizeLarge),
                        Row(children: [
                          Text('language'.tr,
                              style: textRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge)),
                          SizedBox(
                            width: Get.find<LocalizationController>().isLtr
                                ? MediaQuery.of(context).size.width * 0.31.w
                                : MediaQuery.of(context).size.width * 0.44.w,
                          ),
                          Text(
                            '${Get.find<LocalizationController>().locale.languageCode.toUpperCase()} (${Get.find<LocalizationController>().locale.languageCode})',
                            style: textRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Icon(Icons.arrow_drop_down,
                              color: AppColors.mainText, size: 30.sp),
                        ])
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: GestureDetector(
                //---------------------------------------------------------------------
                //---------------------------------------------------------------------
                //---------------------------------------------------------------------
                onTap: () => Get.to(() => const ResetPasswordScreen(
                      phoneNumber: '',
                      fromChangePassword: true,
                    )),
                //---------------------------------------------------------------------
                //---------------------------------------------------------------------
                //---------------------------------------------------------------------

                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius:
                        BorderRadius.circular(Dimensions.paddingSizeDefault),
                    border: Border.all(
                        width: 1.w, color: AppColors.backgroundColor),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Row(children: [
                      Image.asset('assets/image/lock_pass.png',
                          scale: 2, width: 25.w),
                      const SizedBox(width: Dimensions.paddingSizeLarge),
                      Text(
                        'change_password'.tr,
                        style: textRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge),
                      ),
                      SizedBox(
                          width: Get.find<LocalizationController>().isLtr
                              ? 0
                              : Dimensions.paddingSizeSmall),
                    ]),
                  ),
                ),
              ),
            ),
            // const ThemeChangeWidget(),
          ]);
        }),
      ),
    );
  }
}

class LanguageSelectionBottomSheet extends StatefulWidget {
  const LanguageSelectionBottomSheet({super.key});

  @override
  State<LanguageSelectionBottomSheet> createState() =>
      _LanguageSelectionBottomSheetState();
}

class _LanguageSelectionBottomSheetState
    extends State<LanguageSelectionBottomSheet> {
  late Locale _selectedLocale;

  @override
  void initState() {
    super.initState();
    _selectedLocale = Get.find<LocalizationController>().locale;
  }

  @override
  Widget build(BuildContext context) {
    final localizationController = Get.find<LocalizationController>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Change Language'.tr,
                style: textBold.copyWith(fontSize: 20.sp)),
            const SizedBox(height: 8),
            Text('Select your preferred language'.tr,
                style: textRegular.copyWith(fontSize: 14.sp)),
            const SizedBox(height: 24),
            ...AppConstants.languages.map((language) {
              final isSelected =
                  _selectedLocale.languageCode == language.languageCode;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedLocale =
                        Locale(language.languageCode, language.countryCode);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.backgroundColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isSelected ? AppColors.primaryColor : Colors.black54,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Text(
                          "${language.languageCode.toUpperCase()} (${language.languageName})",
                          style: textMedium.copyWith(fontSize: 16.sp),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.r),
                        child: Image.asset(
                          getFlagForCode(language.languageCode),
                          width: 56.w,
                          height: 32.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  localizationController.setLanguage(_selectedLocale);
                  Get.back();
                },
                child: Text(
                  "Save Changes".tr,
                  style:
                      textBold.copyWith(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Helper to get flag asset path
  String getFlagForCode(String code) {
    switch (code) {
      case 'en':
        return 'assets/image/uk.png';
      case 'ar':
        return 'assets/image/ar.png';
      default:
        return 'assets/flags/placeholder.png';
    }
  }
}
