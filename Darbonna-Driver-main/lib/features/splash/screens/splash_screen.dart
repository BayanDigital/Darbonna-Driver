// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/controllers/out_of_zone_controller.dart';
import 'package:ride_sharing_user_app/features/splash/domain/models/config_model.dart';
import 'package:ride_sharing_user_app/features/splash/screens/app_version_warning_screen.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/helper/firebase_helper.dart';
import 'package:ride_sharing_user_app/helper/notification_helper.dart';
import 'package:ride_sharing_user_app/helper/pusher_helper.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/screens/sign_in_screen.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/location/screens/access_location_screen.dart';
import 'package:ride_sharing_user_app/features/maintainance_mode/screens/maintainance_screen.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  final Map<String, dynamic>? notificationData;
  final String? userName;

  const SplashScreen({super.key, this.notificationData, this.userName});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<List<ConnectivityResult>>? _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    if (!GetPlatform.isIOS) {
      _checkConnectivity();
    }

    Get.find<SplashController>().initSharedData();
    Get.find<TripController>().rideCancellationReasonList();
    Get.find<TripController>().parcelCancellationReasonList();
    Get.find<AuthController>().remainingTime();

    _route();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage("assets/image/splashBG.png"), context);
    precacheImage(const AssetImage("assets/image/splashCar.png"), context);
    precacheImage(const AssetImage("assets/image/splashLogo.png"), context);
  }

  @override
  void dispose() {
    _onConnectivityChanged?.cancel();
    super.dispose();
  }

  void _checkConnectivity() {
    bool isFirst = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      bool isConnected = results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.mobile);

      if ((isFirst && !isConnected) || (!isFirst && mounted)) {
        if (Get.isSnackbarOpen) {
          Get.closeCurrentSnackbar();
        }

        Get.snackbar(
          '',
          isConnected ? 'connected'.tr : 'no_connection'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: isConnected ? Colors.green : Colors.red,
          duration: Duration(seconds: isConnected ? 3 : 6),
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          borderRadius: 8,
          snackStyle: SnackStyle.FLOATING,
        );

        if (isConnected) {
          _route();
        }
      }
      isFirst = false;
    });
  }

  void _route() async {
    final splashController = Get.find<SplashController>();
    final authController = Get.find<AuthController>();

    bool isSuccess = await splashController.getConfigData();
    if (!isSuccess || !mounted) return;

    if (_isForceUpdate(splashController.config)) {
      Get.offAll(() => const AppVersionWarningScreen());
      return;
    }

    FirebaseHelper().subscribeFirebaseTopic();

    if (authController.getUserToken().isNotEmpty) {
      PusherHelper.initializePusher();
    }

    if (authController.getZoneId().isEmpty) {
      Get.offAll(() => const AccessLocationScreen());
      return;
    }

    authController.updateToken();

    Future.delayed(const Duration(milliseconds: 1000), () async {
      if (!mounted) return;

      if (authController.isLoggedIn()) {
        await _handleLoggedInUser();
      } else {
        _handleNotLoggedInUser(splashController);
      }
    });
  }

  Future<void> _handleLoggedInUser() async {
    final profileController = Get.find<ProfileController>();
    final locationController = Get.find<LocationController>();
    final outOfZoneController = Get.find<OutOfZoneController>();

    outOfZoneController.getZoneList();
    final response = await profileController.getProfileInfo();

    if (response.statusCode == 200) {
      await locationController.getCurrentLocation();

      if (widget.notificationData != null) {
        NotificationHelper.notificationToRoute(
          widget.notificationData!,
          formSplash: true,
          userName: widget.userName,
        );
      } else {
        Get.offAll(() => const DashboardScreen());
      }

      final userId = response.body['data']['id'];
      PusherHelper().driverTripRequestSubscribe(userId);
    }
  }

  void _handleNotLoggedInUser(SplashController splashController) {
    final maintenance = splashController.config?.maintenanceMode;
    final isInMaintenance = maintenance?.maintenanceStatus == 1 &&
        maintenance!.selectedMaintenanceSystem?.driverApp == 1;

    if (isInMaintenance) {
      Get.offAll(() => const MaintenanceScreen());
    } else {
      Get.offAll(() => const SignInScreen());
    }
  }

  bool _isForceUpdate(ConfigModel? config) {
    double minimumVersion = Platform.isAndroid
        ? config?.androidAppMinimumVersion ?? 0
        : Platform.isIOS
            ? config?.iosAppMinimumVersion ?? 0
            : 0;

    return minimumVersion > 0 && minimumVersion > AppConstants.appVersion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/image/splashBG.png",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                Image.asset(
                  "assets/image/splashLogo.png",
                  width: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.contain,
                ),
                const Spacer(),
                Image.asset(
                  "assets/image/splashCar.png",
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
