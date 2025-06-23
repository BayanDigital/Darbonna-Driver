import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

void snackBarWidget(String? message,
    {bool isError = true,
    double margin = Dimensions.paddingSizeSmall,
    String? subMessage}) {
  if (message != null && message.isNotEmpty) {
    final snackBar = SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        top: Dimensions.paddingSizeSmall,
        left: Dimensions.paddingSizeSmall,
        right: Dimensions.paddingSizeSmall,
        bottom: margin,
      ),
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 2),
      content: AwesomeSnackbarContent(
        title: isError ? 'Error'.tr : 'Success'.tr,
        message: subMessage != null ? "$message\n$subMessage" : message,
        contentType: isError ? ContentType.failure : ContentType.success,
      ),
    );

    ScaffoldMessenger.of(Get.context!).clearSnackBars();
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }
}
