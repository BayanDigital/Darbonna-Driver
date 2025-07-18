import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_pop_scope_widget.dart';
import 'package:ride_sharing_user_app/features/html/domain/html_enum_types.dart';
import 'package:ride_sharing_user_app/features/splash/domain/models/config_model.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';

class PolicyViewerScreen extends StatelessWidget {
  final HtmlType htmlType;
  final String? image;

  const PolicyViewerScreen({super.key, required this.htmlType, this.image});

  @override
  Widget build(BuildContext context) {
    final ({String data, String title}) appBarData = getDataAndTitle(htmlType);

    return SafeArea(
      top: false,
      child: CustomPopScopeWidget(
        child: Scaffold(
          backgroundColor: Theme.of(context).canvasColor,
          appBar: AppBarWidget(
            title: appBarData.title.tr,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            physics: const BouncingScrollPhysics(),
            child: HtmlWidget(appBarData.data, key: Key(appBarData.title)),
          ),
        ),
      ),
    );
  }

  ({String data, String title}) getDataAndTitle(HtmlType htmlType) {
    final ConfigModel? config = Get.find<SplashController>().config;
    switch (htmlType) {
      case HtmlType.privacyPolicy:
        return (
          data:
              '${config?.privacyPolicy?.shortDescription ?? ''}\n${config?.privacyPolicy?.longDescription ?? ''}',
          title: 'privacy_policy'
        );
      case HtmlType.refundPolicy:
        return (
          data:
              '${config?.refundPolicy?.shortDescription ?? ''}\n${config?.refundPolicy?.longDescription ?? ''}',
          title: 'refund_policy'
        );
      case HtmlType.legal:
        return (
          data:
              '${config!.legal?.shortDescription ?? ''}\n${config.legal?.longDescription ?? ''}',
          title: 'legal'
        );
      case HtmlType.termsAndConditions:
        return (
          data:
              '${config?.termsAndConditions?.shortDescription ?? ''}\n${config?.termsAndConditions?.longDescription ?? ''}',
          title: 'terms_and_condition'
        );
    }
  }
}
