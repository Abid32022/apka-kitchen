
import 'package:Apka_kitchen/util/dimensions.dart';
import 'package:Apka_kitchen/view/screens/review/widget/product_review_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/product_controller.dart';
import '../../../data/model/response/order_details_model.dart';
import '../../../data/model/response/order_model.dart';
import '../../../util/app_colors.dart';
import '../../base/custom_app_bar.dart';

class RateReviewScreen extends StatefulWidget {
  final List<OrderDetailsModel> orderDetailsList;
  final DeliveryMan deliveryMan;
  RateReviewScreen(
      {@required this.orderDetailsList, @required this.deliveryMan});

  @override
  _RateReviewScreenState createState() => _RateReviewScreenState();
}

class _RateReviewScreenState extends State<RateReviewScreen>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(
    //     length: widget.deliveryMan == null ? 1 : 2,
    //     initialIndex: 0,
    //     vsync: this);
    Get.find<ProductController>().initRatingData(widget.orderDetailsList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: 'rate_review'.tr),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: Dimensions.WEB_MAX_WIDTH,
            color: Colors.white,
            child:  ProductReviewWidget(
                orderDetailsList: widget.orderDetailsList),
            // child: TabBar(
            //   controller: _tabController,
            //   labelColor: Colors.black,
            //   indicatorColor:AppColors.primarycolor,
            //   indicatorWeight: 3,
            //   unselectedLabelStyle: robotoRegular.copyWith(
            //       color: Theme.of(context).disabledColor,
            //       fontSize: Dimensions.fontSizeSmall),
            //   labelStyle:
            //       robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
            //   tabs: widget.deliveryMan != null
            //       ? [
            //           Tab(
            //               text: widget.orderDetailsList.length > 1
            //                   ? 'items'.tr
            //                   : 'item'.tr),
            //           Tab(text: 'delivery_man'.tr),
            //         ]
            //       : [
            //           Tab(
            //               text: widget.orderDetailsList.length > 1
            //                   ? 'items'.tr
            //                   : 'item'.tr),
            //         ],
            // ),
          ),
          // Expanded(
          //     child: TabBarView(
          //       controller: _tabController,
          //       children:
          //            [
          //              ProductReviewWidget(
          //             orderDetailsList: widget.orderDetailsList),
          //       ]
          //     ),

          //     child: TabBarView(
          //   controller: _tabController,
          //   children: widget.deliveryMan != null
          //       ? [
          //           ProductReviewWidget(
          //               orderDetailsList: widget.orderDetailsList),
          //           DeliveryManReviewWidget(
          //               deliveryMan: widget.deliveryMan,
          //               orderID: widget.orderDetailsList[0].orderId.toString()),
          //         ]
          //       : [
          //           ProductReviewWidget(
          //               orderDetailsList: widget.orderDetailsList),
          //         ],
          // )

        ]),
      ),
    );
  }
}
