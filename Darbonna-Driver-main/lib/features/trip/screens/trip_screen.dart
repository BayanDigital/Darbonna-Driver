import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/profile/screens/profile_menu_screen.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/trip_overview_widget.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/trips_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/zoom_drawer_context_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/type_button_widget.dart';

class TripHistoryMenu extends GetView<ProfileController> {
  const TripHistoryMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (_) => ZoomDrawer(
        controller: _.zoomDrawerController,
        menuScreen: const ProfileMenuScreen(),
        mainScreen: const TripHistoryScreen(),
        borderRadius: 24.0,
        angle: -5.0,
        isRtl: !Get.find<LocalizationController>().isLtr,
        menuBackgroundColor: Theme.of(context).primaryColor,
        slideWidth: MediaQuery.of(context).size.width * 0.85,
        mainScreenScale: .4,
        mainScreenTapClose: true,
      ),
    );
  }
}

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Get.find<TripController>()
        .getTripList(1, '', '', "ride_request", 'today', 'all');
    Get.find<TripController>()
        .getTripOverView(Get.find<TripController>().selectedOverview);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: GetBuilder<TripController>(builder: (tripController) {
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: GetPlatform.isAndroid ? 150.h : 150.h,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: tripController.activityTypeIndex == 0
                          ? TripsWidget(
                              tripController: tripController,
                              scrollController: scrollController,
                            )
                          : TripOverviewWidget(tripController: tripController),
                    ),
                  ],
                ),
              ),
              AppBarWidget(
                title: 'trip_history'.tr,
                showBackButton: false,
                onTap: () {
                  Get.find<ProfileController>().toggleDrawer();
                },
              ),
              Positioned(
                top: GetPlatform.isAndroid ? 100.h : 100.h,
                left: Dimensions.paddingSizeSmall,
                right: 0,
                child: SizedBox(
                  height: Get.find<LocalizationController>().isLtr ? 45 : 50,
                  width: Get.width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: tripController.activityTypeList.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: Get.find<LocalizationController>().isLtr
                            ? Get.width / 2.12
                            : Get.width / 2.03,
                        child: TypeButtonWidget(
                          index: index,
                          name: tripController.activityTypeList[index],
                          selectedIndex: tripController.activityTypeIndex,
                          onTap: () =>
                              tripController.setActivityTypeIndex(index),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
