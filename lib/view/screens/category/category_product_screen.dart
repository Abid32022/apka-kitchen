import 'package:Apka_kitchen/controller/category_controller.dart';
import 'package:Apka_kitchen/controller/localization_controller.dart';
import 'package:Apka_kitchen/data/model/response/product_model.dart';
import 'package:Apka_kitchen/data/model/response/restaurant_model.dart';
import 'package:Apka_kitchen/helper/responsive_helper.dart';
import 'package:Apka_kitchen/helper/route_helper.dart';
import 'package:Apka_kitchen/util/dimensions.dart';
import 'package:Apka_kitchen/util/styles.dart';
import 'package:Apka_kitchen/view/base/cart_widget.dart';
import 'package:Apka_kitchen/view/base/product_view.dart';
import 'package:Apka_kitchen/view/base/veg_filter_widget.dart';
import 'package:Apka_kitchen/view/base/web_menu_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/app_colors.dart';

class CategoryProductScreen extends StatefulWidget {
  final String categoryID;
  final String categoryName;
  // final String DeliveryCharges;
  final  dynamic deliveryfee;

  CategoryProductScreen(
      {@required this.categoryID, @required this.categoryName,@required this.deliveryfee});

  @override
  _CategoryProductScreenState createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController restaurantScrollController = ScrollController();
  final bool _ltr = Get.find<LocalizationController>().isLtr;
  TabController _tabController;

  @override
  void initState() {
    super.initState();


    _tabController = TabController(length: 1, initialIndex: 0, vsync: this);
    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    scrollController?.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && Get.find<CategoryController>().categoryProductList != null && !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize / 10).ceil();
        if(kDebugMode){
          print('---------$pageSize/${Get.find<CategoryController>().offset}');
        }

        if (Get.find<CategoryController>().offset < pageSize) {
          if(kDebugMode){
            print('end of the page');
          }

          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryProductList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                .subCategoryList[
            Get.find<CategoryController>().subCategoryIndex]
                .id,
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
    restaurantScrollController?.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryRestList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize =
        (Get.find<CategoryController>().restPageSize / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          if(kDebugMode){
            print('end of the page');
          }

          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryRestaurantList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                .subCategoryList[
            Get.find<CategoryController>().subCategoryIndex]
                .id,
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if(kDebugMode){
      print("delivery charges is ${widget.deliveryfee}");
    }
    return GetBuilder<CategoryController>(builder: (catController) {
      List<Product> _products;
      List<Restaurant> _restaurants;
      if (catController.categoryProductList != null &&
          catController.searchProductList != null) {
        _products = [];
        if (catController.isSearching) {
          _products.addAll(catController.searchProductList);
        } else {
          _products.addAll(catController.categoryProductList);
        }
      }
      if (catController.categoryRestList != null &&
          catController.searchRestList != null) {
        _restaurants = [];
        if (catController.isSearching) {
          _restaurants.addAll(catController.searchRestList);
        } else {
          _restaurants.addAll(catController.categoryRestList);
        }
      }

      return WillPopScope(
        onWillPop: () async {
          if (catController.isSearching) {
            catController.toggleSearch();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: ResponsiveHelper.isDesktop(context)
              ? WebMenuBar()
              : AppBar(
            title: catController.isSearching
                ? TextField(
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
              style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge),
              onSubmitted: (String query) =>
                  catController.searchData(
                    query,
                    catController.subCategoryIndex == 0 ? widget.categoryID : catController.subCategoryList[catController.subCategoryIndex].id, catController.type,
                  ),
            )
                : Text(widget.categoryName,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyText1.color,
                )),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Theme.of(context).textTheme.bodyText1.color,
              onPressed: () {
                if (catController.isSearching) {
                  catController.toggleSearch();
                } else {
                  Get.back();
                }
              },
            ),
            backgroundColor: AppColors.primarycolor,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => catController.toggleSearch(),
                icon: Icon(
                  catController.isSearching
                      ? Icons.close_sharp
                      : Icons.search,
                  color: Theme.of(context).textTheme.bodyText1.color,
                ),
              ),
              IconButton(
                onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                icon: CartWidget(
                    color: Theme.of(context).textTheme.bodyText1.color,
                    size: 25),
              ),
            ],
          ),
          body: Center(
              child: SizedBox(
                width: Dimensions.WEB_MAX_WIDTH,
                child: Column(children: [
                  (catController.subCategoryList != null &&
                      !catController.isSearching)
                      ? Center(
                      child: Container(
                        height: 50,
                        width: Dimensions.WEB_MAX_WIDTH,
                        color: AppColors.primarycolor,
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: catController.subCategoryList.length,
                          padding: EdgeInsets.only(
                              left: Dimensions.PADDING_SIZE_SMALL),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => catController.setSubCategoryIndex(index, widget.categoryID),
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: index == 0
                                      ? Dimensions.PADDING_SIZE_LARGE
                                      : Dimensions.PADDING_SIZE_SMALL,
                                  right: index ==
                                      catController.subCategoryList.length - 1
                                      ? Dimensions.PADDING_SIZE_LARGE
                                      : Dimensions.PADDING_SIZE_SMALL,
                                  top: Dimensions.PADDING_SIZE_SMALL,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(
                                      _ltr
                                          ? index == 0
                                          ? Dimensions.RADIUS_EXTRA_LARGE
                                          : 0
                                          : index ==
                                          catController.subCategoryList
                                              .length -
                                              1
                                          ? Dimensions.RADIUS_EXTRA_LARGE
                                          : 0,
                                    ),
                                    right: Radius.circular(
                                      _ltr
                                          ? index ==
                                          catController.subCategoryList
                                              .length -
                                              1
                                          ? Dimensions.RADIUS_EXTRA_LARGE
                                          : 0
                                          : index == 0
                                          ? Dimensions.RADIUS_EXTRA_LARGE
                                          : 0,
                                    ),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Column(children: [
                                  SizedBox(height: 3),
                                  Text(
                                    catController.subCategoryList[index].name,
                                    style: index == catController.subCategoryIndex
                                        ? robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color:AppColors.primarycolor)
                                        : robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Colors.grey),
                                  ),

                                  index == catController.subCategoryIndex
                                      ? Container(
                                    height: 5,
                                    width: 5,
                                    decoration: BoxDecoration(
                                        color: AppColors.primarycolor
                                        ,shape: BoxShape.circle),
                                  )
                                      : SizedBox(height: 5, width: 5),
                                ]),
                              ),
                            );
                          },
                        ),
                      ))
                      : SizedBox(),
                  Center(
                      child: Container(
                        width: Dimensions.WEB_MAX_WIDTH,
                        color: AppColors.primarycolor,
                        child: TabBar(
                          controller: _tabController,
                          indicatorColor:AppColors.primarycolor,
                          indicatorWeight: 3,
                          labelColor:Colors.white
                          ,unselectedLabelColor: Colors.white.withOpacity(0.70),
                          unselectedLabelStyle: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                          labelStyle: robotoBold.copyWith(fontSize: 18, color:Colors.white,),
                          tabs: [
                            Tab(text: 'food'.tr,),
                            // Tab(text: 'restaurants'.tr),
                          ],
                        ),
                      )),

                  // VegFilterWidget(
                  //     type: catController.type,
                  //     onSelected: (String type) {
                  //       if (catController.isSearching) {
                  //         catController.searchData(
                  //           catController.subCategoryIndex == 0
                  //               ? widget.categoryID
                  //               : catController
                  //               .subCategoryList[catController.subCategoryIndex]
                  //               .id
                  //               .toString(),
                  //           '1',
                  //           type,
                  //         );
                  //       } else {
                  //         if (catController.isRestaurant) {
                  //           catController.getCategoryRestaurantList(
                  //             catController.subCategoryIndex == 0
                  //                 ? widget.categoryID
                  //                 : catController
                  //                 .subCategoryList[
                  //             catController.subCategoryIndex]
                  //                 .id
                  //                 .toString(),
                  //             1,
                  //             type,
                  //             true,
                  //           );
                  //         } else {
                  //           catController.getCategoryProductList(
                  //             catController.subCategoryIndex == 0
                  //                 ? widget.categoryID
                  //                 : catController
                  //                 .subCategoryList[
                  //             catController.subCategoryIndex]
                  //                 .id
                  //                 .toString(),
                  //             1,
                  //             type,
                  //             true,
                  //           );
                  //         }
                  //       }
                  //     }),
                  Expanded(
                      child: NotificationListener(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollEndNotification) {
                            if ((_tabController.index == 1 &&
                                !catController.isRestaurant) ||
                                _tabController.index == 0 &&
                                    catController.isRestaurant) {
                              catController.setRestaurant(_tabController.index == 1);
                              if (catController.isSearching) {
                                catController.searchData(
                                  catController.searchText,
                                  catController.subCategoryIndex == 0
                                      ? widget.categoryID
                                      : catController
                                      .subCategoryList[
                                  catController.subCategoryIndex]
                                      .id,
                                  catController.type,
                                );
                              } else {
                                if (_tabController.index == 1) {
                                  catController.getCategoryRestaurantList(
                                    catController.subCategoryIndex == 0
                                        ? widget.categoryID
                                        : catController
                                        .subCategoryList[
                                    catController.subCategoryIndex]
                                        .id,
                                    1,
                                    catController.type,
                                    false,
                                  );
                                } else {
                                  catController.getCategoryProductList(
                                    catController.subCategoryIndex == 0
                                        ? widget.categoryID
                                        : catController
                                        .subCategoryList[
                                    catController.subCategoryIndex]
                                        .id,
                                    1,
                                    catController.type,
                                    false,
                                  );
                                }
                              }
                            }
                          }
                          return false;
                        },
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            SingleChildScrollView(
                              controller: scrollController,
                              child: ProductView(
                                isRestaurant: false,
                                products: _products,
                                // deliveryfee: widget.deliveryfee,
                                restaurants: null,
                                noDataText: 'no_category_food_found'.tr,
                              ),
                            ),

                            // SingleChildScrollView(
                            //   controller: restaurantScrollController,
                            //   child: ProductView(
                            //     isRestaurant: false,
                            //     products: null,
                            //     restaurants: _restaurants,
                            //     noDataText: 'no_category_restaurant_found'.tr,
                            //   ),
                            // ),

                          ],
                        ),
                      )),
                  catController.isLoading
                      ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF009f67))),
                      ))
                      : SizedBox(),
                ]),
              )),
        ),
      );
    });
  }
}
