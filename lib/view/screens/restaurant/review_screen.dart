import 'package:Apka_kitchen/controller/restaurant_controller.dart';
import 'package:Apka_kitchen/helper/responsive_helper.dart';
import 'package:Apka_kitchen/util/dimensions.dart';
import 'package:Apka_kitchen/view/base/custom_app_bar.dart';
import 'package:Apka_kitchen/view/base/no_data_screen.dart';
import 'package:Apka_kitchen/view/screens/restaurant/widget/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewScreen extends StatelessWidget {
  final String restaurantID;
  ReviewScreen({@required this.restaurantID});

  @override
  Widget build(BuildContext context) {
    Get.find<RestaurantController>().getRestaurantReviewList(restaurantID);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'restaurant_reviews'.tr),
      body: GetBuilder<RestaurantController>(builder: (restController) {
        return restController.restaurantReviewList != null
            ? restController.restaurantReviewList.length > 0
                ? RefreshIndicator(
                    onRefresh: () async {
                      await restController
                          .getRestaurantReviewList(restaurantID);
                    },
                    child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Center(
                            child: SizedBox(
                                width: Dimensions.WEB_MAX_WIDTH,
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        ResponsiveHelper.isMobile(context)
                                            ? 1
                                            : 2,
                                    childAspectRatio: (1 / 0.2),
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount: restController
                                      .restaurantReviewList.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL),
                                  itemBuilder: (context, index) {
                                    return ReviewWidget(
                                      review: restController
                                          .restaurantReviewList[index],
                                      hasDivider: index !=
                                          restController
                                                  .restaurantReviewList.length -
                                              1,
                                    );
                                  },
                                )))),
                  )
                : Center(child: NoDataScreen(text: 'no_review_found'.tr))
            : Center(child: CircularProgressIndicator());
      }),
    );
  }
}
