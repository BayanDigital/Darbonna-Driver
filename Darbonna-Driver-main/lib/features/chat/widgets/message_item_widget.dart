import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/theme/app_colors.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/chat/screens/message_screen.dart';
import 'package:ride_sharing_user_app/features/chat/domain/models/channel_model.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';

class MessageItemWidget extends StatelessWidget {
  final bool isRead;
  final ChannelUsers channelUsers;
  final String lastMessage;
  final String tripId;
  final int unReadCount;
  const MessageItemWidget({
    super.key,
    required this.isRead,
    required this.channelUsers,
    required this.lastMessage,
    required this.tripId,
    this.unReadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => MessageScreen(
            channelId: channelUsers.channelId!,
            tripId: tripId,
            userName:
                '${channelUsers.user!.firstName!} ${channelUsers.user!.lastName!}',
          )),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimensions.paddingSizeDefault,
          0,
          Dimensions.paddingSizeDefault,
          Dimensions.paddingSizeSmall,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeSmall,
            horizontal: Dimensions.paddingSizeExtraSmall,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.greyColor),
            color: unReadCount == 0
                ? Theme.of(context).cardColor
                : Theme.of(context).colorScheme.primary.withValues(alpha: .1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: Dimensions.paddingSizeSmall),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: ImageWidget(
                  height: 44.h,
                  width: 44.w,
                  image:
                      '${Get.find<SplashController>().config!.imageBaseUrl!.profileImageCustomer}/${channelUsers.user!.profileImage ?? ''}',
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(
                      '${channelUsers.user!.firstName!} ${channelUsers.user!.lastName!}',
                      style: textBold.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: AppColors.mainText),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(
                      lastMessage.isNotEmpty
                          ? lastMessage
                          : 'send_an_attachment'.tr,
                      style: textMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: isRead
                            ? Theme.of(context).textTheme.bodyMedium!.color
                            : Theme.of(context).hintColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: Dimensions.paddingSizeExtraSmall,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateConverter
                                .isoDateTimeStringToDifferentWithCurrentTime(
                                    channelUsers.updatedAt!),
                            textDirection: TextDirection.ltr,
                            style: textRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: AppColors.greyColor,
                            ),
                          ),
                          unReadCount != 0
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                      child: Text(
                                    unReadCount.toString(),
                                    style: textRegular.copyWith(
                                        color: Theme.of(context).cardColor,
                                        fontSize: 10),
                                  )),
                                )
                              : const SizedBox(),
                        ]),
                  ])),
              const SizedBox(width: Dimensions.paddingSizeSmall),
            ],
          ),
        ),
      ),
    );
  }
}
