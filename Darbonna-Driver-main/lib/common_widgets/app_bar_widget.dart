// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/theme/app_colors.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Function()? onBackPressed;
  final Function()? onTap;
  final bool regularAppbar;

  /// 👇 الجديد: optional background color
  final Color? backgroundColor;

  const AppBarWidget({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.onTap,
    this.regularAppbar = false,
    this.backgroundColor, // ✅ Optional
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: regularAppbar
          ? 80.h
          : GetPlatform.isAndroid
              ? 80.h
              : 80.h,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.mainText.withOpacity(0.3),
            offset: const Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 3,
          ),
        ],
      ),
      child: AppBar(
        scrolledUnderElevation: 0,
        title: Text(title,
            style: textSemiBold.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            )),
        centerTitle: false,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Theme.of(context).textTheme.bodyMedium?.color,
                onPressed: () => onBackPressed != null
                    ? onBackPressed!()
                    : Navigator.canPop(context)
                        ? Navigator.pop(context)
                        : Get.offAll(() => const DashboardScreen()),
              )
            : SizedBox(
                width: Dimensions.iconSizeMedium,
                child: InkWell(
                  highlightColor: Colors.transparent,
                  onTap: onTap,
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Image.asset(
                      Images.menuIcon,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      width: Dimensions.iconSizeMedium,
                    ),
                  ),
                ),
              ),
        backgroundColor: backgroundColor ?? AppColors.backgroundColor,
        elevation: 0,
        shadowColor: AppColors.mainText,
      ),
    );
  }

  @override
  Size get preferredSize => Size(
        Dimensions.webMaxWidth,
        GetPlatform.isAndroid
            ? Dimensions.androidAppBarHeight
            : Dimensions.appBarHeight,
      );
}
