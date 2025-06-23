import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/snackbar_widget.dart';
import 'package:ride_sharing_user_app/features/auth/screens/sign_in_screen.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'error_response.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      Get.find<SplashController>().removeSharedData();
      //snackBarWidget(response.body['message']);
      Get.offAll(() => const SignInScreen());
    } else if (response.statusCode == 403) {
      ErrorResponse errorResponse;
      errorResponse = ErrorResponse.fromJson(response.body);
      if (errorResponse.errors != null && errorResponse.errors!.isNotEmpty) {
        snackBarWidget(errorResponse.errors![0].message!);
      } else {
        snackBarWidget(response.body['message']!);
      }
    } else {
      snackBarWidget(response.statusText!);
    }
  }
}
