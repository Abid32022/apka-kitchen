import 'package:Apka_kitchen/controller/campaign_controller.dart';
import 'package:Apka_kitchen/util/dimensions.dart';
import 'package:Apka_kitchen/view/base/custom_app_bar.dart';
import 'package:Apka_kitchen/view/base/product_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemCampaignScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.find<CampaignController>().getItemCampaignList(false);

    return Scaffold(
      appBar: CustomAppBar(title: 'campaigns'.tr),
      body: Scrollbar(child: SingleChildScrollView(child: Center(child: SizedBox(
        width: Dimensions.WEB_MAX_WIDTH,
        child: GetBuilder<CampaignController>(builder: (campController) {
          return ProductView(
            isRestaurant: false, products: campController.itemCampaignList, restaurants: null,
            isCampaign: true, noDataText: 'no_campaign_found'.tr,
          );
        }),
      )))),
    );
  }
}
