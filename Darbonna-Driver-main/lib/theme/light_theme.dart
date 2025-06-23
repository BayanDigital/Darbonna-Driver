import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/theme/app_colors.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: AppConstants.fontFamily,
  primaryColor: AppColors.primaryColor,
  primaryColorDark: AppColors.primaryColor,
  disabledColor: AppColors.greyColor,
  scaffoldBackgroundColor: AppColors.backgroundColor,
  shadowColor: Colors.black.withAlpha(8),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: AppColors.mainText),
    bodySmall: TextStyle(color: AppColors.greyColor),
    bodyLarge: TextStyle(color: AppColors.mainText),
    titleMedium: TextStyle(color: AppColors.mainText),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  brightness: Brightness.light,
  hintColor: AppColors.greyColor,
  cardColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryColor,
    error: AppColors.errorColor,
    surface: AppColors.backgroundColor,
    tertiary: AppColors.successColor,
    tertiaryContainer: AppColors.warningBgColor,
    secondaryContainer: AppColors.errorColor,
    onTertiary: AppColors.greyColor,
    onSecondary: AppColors.primaryLightColor,
    onSecondaryContainer: AppColors.greyColor,
    onTertiaryContainer: AppColors.mainText,
    outline: AppColors.greyColor,
    onPrimaryContainer: AppColors.primaryLightColor,
    primaryContainer: AppColors.primaryLightColor,
    onErrorContainer: AppColors.warningBgColor,
    onPrimary: AppColors.successColor,
    surfaceTint: AppColors.successColor,
    errorContainer: AppColors.warningBgColor,
    inverseSurface: AppColors.primaryColor,
    surfaceContainer: AppColors.backgroundColor,
    secondaryFixedDim: AppColors.greyColor,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: AppColors.successColor),
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: AppColors.backgroundColor,
  ),
);
