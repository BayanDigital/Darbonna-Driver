// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/theme/app_colors.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/features/dashboard/domain/models/navigation_model.dart';
import 'package:ride_sharing_user_app/features/home/screens/home_screen.dart';
import 'package:ride_sharing_user_app/features/notification/screens/notification_screen.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/trip/screens/trip_screen.dart';
import 'package:ride_sharing_user_app/features/wallet/screens/wallet_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    Get.find<RideController>().updateRoute(true);
    final List<NavigationModel> item = [
      NavigationModel(
          name: 'home'.tr,
          activeIcon: Images.homeActive,
          inactiveIcon: Images.homeOutline,
          screen: const HomeMenu()),
      NavigationModel(
          name: 'activity'.tr,
          activeIcon: Images.activityActive,
          inactiveIcon: Images.activityOutline,
          screen: const TripHistoryMenu()),
      NavigationModel(
          name: 'notification'.tr,
          activeIcon: Images.notificationActive,
          inactiveIcon: Images.notificationOutline,
          screen: const NotificationMenu()),
      NavigationModel(
          name: 'money'.tr,
          activeIcon: Images.moneyActive,
          inactiveIcon: Images.moneyOutline,
          screen: const WalletScreenMenu()),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (res, val) async {
        if (Get.find<BottomMenuController>().currentTab != 0) {
          if (Get.find<ProfileController>().toggle) {
            Get.find<ProfileController>().toggleDrawer();
            Get.find<BottomMenuController>().setTabIndex(0);
          } else {
            if (Get.find<BottomMenuController>().currentTab == 3) {
              if (Get.find<WalletController>().walletTypeIndex == 0) {
                Get.find<BottomMenuController>().setTabIndex(0);
              } else {
                Get.find<WalletController>().moveToPreviousProfileType();
              }
            } else {
              Get.find<BottomMenuController>().setTabIndex(0);
            }
          }
          return;
        } else {
          if (Get.find<ProfileController>().toggle) {
            Get.find<ProfileController>().toggleDrawer();
          } else {
            Get.find<BottomMenuController>().exitApp();
          }
          return;
        }
      },
      child: GetBuilder<BottomMenuController>(builder: (menuController) {
        return SafeArea(
          top: false,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(children: [
              PageStorage(
                  bucket: bucket,
                  child: item[menuController.currentTab].screen),
              Positioned(
                  child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 65,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(20),
                    color: AppColors.primaryColor,
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 4),
                          blurRadius: 3,
                          color: Colors.black.withOpacity(0.3))
                    ],
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          generateBottomNavigationItems(menuController, item)),
                ),
              ))
            ]),
          ),
        );
      }),
    );
  }

  List<Widget> generateBottomNavigationItems(
      BottomMenuController menuController, List<NavigationModel> item) {
    List<Widget> items = [];
    for (int index = 0; index < item.length; index++) {
      items.add(Expanded(
          child: CustomMenuItem(
        isSelected: menuController.currentTab == index,
        name: item[index].name,
        activeIcon: item[index].activeIcon,
        inActiveIcon: item[index].inactiveIcon,
        onTap: () => menuController.setTabIndex(index),
      )));
    }
    return items;
  }
}

class CustomMenuItem extends StatelessWidget {
  final bool isSelected;
  final String name;
  final String activeIcon;
  final String inActiveIcon;
  final VoidCallback onTap;

  const CustomMenuItem({
    super.key,
    required this.isSelected,
    required this.name,
    required this.activeIcon,
    required this.inActiveIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: 70, // حجم ثابت للعنصر
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  isSelected ? activeIcon : inActiveIcon,
                  width: Dimensions.menuIconSize,
                  height: Dimensions.menuIconSize,
                  color: isSelected
                      ? AppColors.mainText
                      : AppColors.mainText.withOpacity(0.8),
                ),
                const SizedBox(height: 5),
                Text(
                  name.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textRegular.copyWith(
                    color: isSelected
                        ? AppColors.mainText
                        : AppColors.mainText.withOpacity(0.8),
                    fontSize: Dimensions.fontSizeExtraSmall,
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
