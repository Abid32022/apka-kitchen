import 'package:Apka_kitchen/controller/auth_controller.dart';
import 'package:Apka_kitchen/controller/order_controller.dart';
import 'package:Apka_kitchen/helper/responsive_helper.dart';
import 'package:Apka_kitchen/helper/route_helper.dart';
import 'package:Apka_kitchen/util/dimensions.dart';
import 'package:Apka_kitchen/util/styles.dart';
import 'package:Apka_kitchen/view/base/custom_app_bar.dart';
import 'package:Apka_kitchen/view/base/not_logged_in_screen.dart';
import 'package:Apka_kitchen/view/screens/order/widget/order_shimmer.dart';
import 'package:Apka_kitchen/view/screens/order/widget/order_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/splash_controller.dart';
import '../../../data/model/response/order_model.dart';
import '../../../helper/date_converter.dart';
import '../../../util/app_colors.dart';
import '../../../util/images.dart';
import '../../base/custom_image.dart';
import '../../base/no_data_screen.dart';
import '../restaurant/restaurant_screen.dart';


class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn) {
      // _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
      Get.find<OrderController>().getRunningOrders(1);
      Get.find<OrderController>().getHistoryOrders(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          title: 'my_orders'.tr,
          isBackButtonExist: ResponsiveHelper.isDesktop(context)),
      body: _isLoggedIn
          ? GetBuilder<OrderController>(
              builder: (orderController) {
                return Column(children: [
                  // Center(
                  //   child:
                  //   Container(
                  //     width: Dimensions.WEB_MAX_WIDTH,
                  //     color: Colors.white,
                  //     child: TabBar(
                  //       controller: _tabController,
                  //       indicatorColor:AppColors.primarycolor,
                  //       indicatorWeight: 3,
                  //       labelColor:AppColors.primarycolor,
                  //       unselectedLabelColor: Colors.grey,
                  //       unselectedLabelStyle: robotoRegular.copyWith(
                  //           color: Colors.grey,
                  //           fontSize: Dimensions.fontSizeSmall),
                  //       labelStyle: robotoBold.copyWith(
                  //           fontSize: Dimensions.fontSizeSmall,
                  //           color:Color(0xFF009f67)),
                  //       tabs: [
                  //         Tab(text: 'running'.tr),
                  //         Tab(text: 'history'.tr),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                      child: OrderView(isRunning: false)),
                  // Expanded(
                  //     child: TabBarView(
                  //   controller: _tabController,
                  //   children: [
                  //     OrderView(isRunning: true),
                  //     OrderView(isRunning: false),
                  //   ],
                  // )),
                ]);
              },
            )
          : NotLoggedInScreen(),
    );
  }
}
