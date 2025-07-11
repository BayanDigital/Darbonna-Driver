import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';

import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverHeaderInfoWidget extends StatelessWidget {
  const DriverHeaderInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 60, Dimensions.paddingSizeDefault,0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Theme.of(context).primaryColor)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: ImageWidget(width: 50,height: 50,
                image: '${Get.find<SplashController>().config!.imageBaseUrl!.profileImage}/${Get.find<ProfileController>().driverImage}',
              ),
            ),
          ),

          const Spacer(),

          if(Get.find<RideController>().tripDetail != null)
            InkWell(
              onTap: () async{
                if(Get.find<RideController>().tripDetail?.currentStatus == 'accepted' || Get.find<RideController>().tripDetail?.currentStatus == 'pending'){

                  _openMaps(
                    Get.find<RideController>().tripDetail!.pickupCoordinates!.coordinates![1],
                    Get.find<RideController>().tripDetail!.pickupCoordinates!.coordinates![0],
                  );

                }else {
                  _openMaps(
                    Get.find<RideController>().tripDetail!.destinationCoordinates!.coordinates![1],
                    Get.find<RideController>().tripDetail!.destinationCoordinates!.coordinates![0],
                  );

                }
              },
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge),
                  boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: .25), blurRadius: 1,spreadRadius: 1, offset: const Offset(0,1))],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: SizedBox(width: Dimensions.iconSizeMedium, height: Dimensions.iconSizeMedium,
                    child: Image.asset(Images.navigation, color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }


  Future<void> _openMaps(double lat, double long) async {
    final googleMapsUrl = Uri.parse(
        'google.navigation:q=$lat,$long&key=${AppConstants.polylineMapKey}');
    final appleMapsUrl = Uri.parse('http://maps.apple.com/?daddr=$lat,$long');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else if (await canLaunchUrl(appleMapsUrl)) {
      await launchUrl(appleMapsUrl);
    } else {
      throw 'Could not launch maps';
    }
  }

}
