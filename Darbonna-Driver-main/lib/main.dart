// ignore_for_file: avoid_print

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/firebase_options.dart';
import 'package:ride_sharing_user_app/helper/notification_helper.dart';
import 'package:ride_sharing_user_app/theme/app_colors.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/map/screens/map_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/responsive_helper.dart';
import 'package:ride_sharing_user_app/helper/di_container.dart' as di;
import 'package:ride_sharing_user_app/helper/route_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/localization/messages.dart';
import 'package:ride_sharing_user_app/theme/dark_theme.dart';
import 'package:ride_sharing_user_app/theme/light_theme.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'features/map/controllers/map_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent),
  );

  if (ResponsiveHelper.isMobilePhone) {
    HttpOverrides.global = MyHttpOverrides();
  }
  WidgetsFlutterBinding.ensureInitialized();
  final info = await PackageInfo.fromPlatform();
  print('Bundle ID: ${info.packageName}');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Map<String, Map<String, String>> languages = await di.init();

  final RemoteMessage? remoteMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
  await FirebaseMessaging.instance.requestPermission();

  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);

  runApp(MyApp(languages: languages, notificationData: remoteMessage?.data));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  final Map<String, dynamic>? notificationData;
  const MyApp({super.key, required this.languages, this.notificationData});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor,
    ));

    if (GetPlatform.isWeb) {
      Get.find<SplashController>().initSharedData();
    }

    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (configController) {
          return (GetPlatform.isWeb && configController.config == null)
              ? const SizedBox()
              : ScreenUtilInit(
                  designSize: const Size(375, 812),
                  minTextAdapt: true,
                  splitScreenMode: true,
                  builder: (context, child) => GetMaterialApp(
                        title: AppConstants.appName,
                        debugShowCheckedModeBanner: false,
                        navigatorKey: Get.key,
                        scrollBehavior: const MaterialScrollBehavior().copyWith(
                          dragDevices: {
                            PointerDeviceKind.mouse,
                            PointerDeviceKind.touch
                          },
                        ),
                        theme:
                            themeController.darkTheme ? darkTheme : lightTheme,
                        locale: localizeController.locale,
                        translations: Messages(languages: languages),
                        fallbackLocale: Locale(
                            AppConstants.languages[0].languageCode,
                            AppConstants.languages[0].countryCode),
                        initialRoute: RouteHelper.getSplashRoute(
                            notificationData: notificationData),
                        getPages: RouteHelper.routes,
                        defaultTransition: Transition.fade,
                        transitionDuration: const Duration(milliseconds: 500),
                        builder: (context, child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaler: TextScaler.noScaling),
                            child:
                                GetBuilder<RideController>(builder: (rideCtrl) {
                              return Stack(
                                children: [
                                  child!,
                                  if (rideCtrl.notSplashRoute)
                                    ..._buildMapShortcut(context, rideCtrl)
                                ],
                              );
                            }),
                          );
                        },
                      ));
        });
      });
    });
  }

  List<Widget> _buildMapShortcut(BuildContext context, RideController ctrl) {
    final config = Get.find<SplashController>().config;
    final maintenance = config?.maintenanceMode;
    final system = maintenance?.selectedMaintenanceSystem;

    if (!(maintenance != null &&
            maintenance.maintenanceStatus == 1 &&
            system?.driverApp == 1) ||
        Get.find<SplashController>().haveOngoingRides()) {
      return [
        Positioned(
          top: Get.height * 0.4.h,
          right: 1.w,
          child: GestureDetector(
            onTap: () async {
              Response res = await ctrl.getRideDetails(ctrl.rideId ?? '1',
                  fromHomeScreen: true);
              if (res.statusCode == 403 ||
                  ctrl.tripDetail?.currentStatus == 'returning' ||
                  ctrl.tripDetail?.currentStatus == 'returned') {
                Get.find<RiderMapController>()
                    .setRideCurrentState(RideState.initial);
              }
              Get.to(() => const MapScreen());
            },
            onHorizontalDragEnd: (DragEndDetails details) {
              _onHorizontalDrag(details);
              Get.to(() => const MapScreen());
            },
            child: Stack(
              children: [
                SizedBox(
                    width: Dimensions.iconSizeExtraLarge,
                    child: Image.asset(Images.homeToMapIcon,
                        width: 50.w,
                        height: 50.h,
                        fit: BoxFit.fill,
                        color: AppColors.primaryColor)),
                Positioned(
                    top: -7,
                    bottom: 3,
                    left: 5,
                    right: 5,
                    child: SizedBox(
                        width: 30.w,
                        child: Image.asset(
                          Images.map,
                          width: 20.w,
                          height: 20.h,
                        ))),
              ],
            ),
          ),
        ),
      ];
    } else {
      return [];
    }
  }

  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity == 0) return;
    if (details.primaryVelocity!.compareTo(0) == -1) {
      debugPrint('dragged from left');
    } else {
      debugPrint('dragged from right');
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
