
import 'package:Apka_kitchen/view/base/discount_tag.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Apka_kitchen/controller/banner_controller.dart';
import 'package:Apka_kitchen/controller/category_controller.dart';
import 'package:Apka_kitchen/controller/localization_controller.dart';
import 'package:Apka_kitchen/controller/product_controller.dart';
import 'package:Apka_kitchen/controller/restaurant_controller.dart';
import 'package:Apka_kitchen/controller/wishlist_controller.dart';
import 'package:Apka_kitchen/data/model/response/category_model.dart';
import 'package:Apka_kitchen/data/model/response/product_model.dart';
import 'package:Apka_kitchen/data/model/response/restaurant_model.dart';
import 'package:Apka_kitchen/helper/date_converter.dart';
import 'package:Apka_kitchen/helper/price_converter.dart';
import 'package:Apka_kitchen/helper/responsive_helper.dart';
import 'package:Apka_kitchen/helper/route_helper.dart';
import 'package:Apka_kitchen/util/app_colors.dart';
import 'package:Apka_kitchen/util/dimensions.dart';
import 'package:Apka_kitchen/util/styles.dart';
import 'package:Apka_kitchen/view/base/cart_widget.dart';
import 'package:Apka_kitchen/view/base/product_view.dart';
import 'package:Apka_kitchen/view/base/web_menu_bar.dart';
import 'package:Apka_kitchen/view/screens/chat_screen/chat_screen.dart';
import 'package:Apka_kitchen/view/screens/home/widget/banner_view.dart';
import 'package:Apka_kitchen/view/screens/restaurant/detail_category_screen.dart';
import 'package:Apka_kitchen/view/screens/restaurant/product_detail_screen.dart';
import 'package:Apka_kitchen/view/screens/restaurant/widget/restaurant_description_view.dart';
import 'package:Apka_kitchen/view/screens/search/search_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../base/custom_image.dart';
import '../category/category_product_screen.dart';

class RestaurantScreen extends StatefulWidget {
  final Restaurant restaurant;

  RestaurantScreen({@required this.restaurant});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final ScrollController scrollController = ScrollController();
  final bool _ltr = Get.find<LocalizationController>().isLtr;
  final PageController controller = PageController();

  // final List<Map<String, dynamic>> items = [
  //   {
  //     'image': "assets/image/img_1.png",
  //     'discount': "50",
  //     'offerText': "Order any item and get a discount",
  //   },
  //   // Add more items as needed
  // ];

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
    Get.find<ProductController>().getAllProductList();
    Get.find<ProductController>().getListenerPaginationCall();
    Get.find<RestaurantController>().getRestaurantDetails(Restaurant(id: 1));
    if (Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    Get.find<RestaurantController>().getRestaurantProductList(1, 1, false);
    Get.find<ProductController>().getPopularProductList(true, 'all', false);

    // scrollController?.addListener(() {
    //   if (scrollController.position.pixels ==
    //           scrollController.position.maxScrollExtent &&
    //       Get.find<RestaurantController>().restaurantProducts != null &&
    //       !Get.find<RestaurantController>().foodPaginate) {
    //     int pageSize =
    //         (Get.find<RestaurantController>().foodPageSize / 10).ceil();
    //     if (Get.find<RestaurantController>().foodOffset < pageSize) {
    //       Get.find<RestaurantController>()
    //           .setFoodOffset(Get.find<RestaurantController>().foodOffset + 1);
    //       print('end of the page');
    //       Get.find<RestaurantController>().showFoodBottomLoader();
    //       Get.find<RestaurantController>().getRestaurantProductList(
    //         widget.restaurant.id,
    //         Get.find<RestaurantController>().foodOffset,
    //         false,
    //       );
    //     }
    //   }
    // });
  }

  Future<void> _checkNotificationPermission() async {
    PermissionStatus notificationStatus = await Permission.notification.status;
    if (!notificationStatus.isGranted) {
      _requestNotificationPermission();
    }
  }

  Future<void> _requestNotificationPermission() async {
    PermissionStatus permissionStatus = await Permission.notification.request();
    if (!permissionStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notification permission is required.')));
    }
  }

  TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    scrollController?.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: Colors.white,
        onRefresh: () async {
          Get.find<ProductController>().getAllProductList();
          Get.find<ProductController>().getListenerPaginationCall();
          Get.find<RestaurantController>()
              .getRestaurantDetails(Restaurant(id: 1));
          if (Get.find<CategoryController>().categoryList == null) {
            Get.find<CategoryController>().getCategoryList(true);
          }
          Get.find<RestaurantController>()
              .getRestaurantProductList(1, 1, false);
          Get.find<ProductController>()
              .getPopularProductList(true, 'all', false);
          // await Get.find<BannerController>().getBannerList(true);
          // await Get.find<CategoryController>().getCategoryList(true);
          // //  await Get.find<RestaurantController>().getPopularRestaurantList(true, 'all', false);
          // //   await Get.find<CampaignController>().getItemCampaignList(true);
          // await Get.find<ProductController>().getPopularProductList(true, 'all', false);
          //   await Get.find<RestaurantController>().getLatestRestaurantList(true, 'all', false);
          // //   await Get.find<ProductController>().getReviewedProductList(true, 'all', false);
          // await Get.find<RestaurantController>().getRestaurantList('1', true);
          // if (Get.find<AuthController>().isLoggedIn()) {
          //   await Get.find<UserController>().getUserInfo();
          //   await Get.find<NotificationController>().getNotificationList(true);
          // }
        },
        child: GetBuilder<RestaurantController>(builder: (restController) {
          return GetBuilder<CategoryController>(builder: (categoryController) {
            Restaurant _restaurant;
            if (restController.restaurant != null &&
                restController.restaurant.name != null &&
                categoryController.categoryList != null) {
              _restaurant = restController.restaurant;
            }
            restController.setCategoryList();

            return (restController.restaurant != null &&
                restController.restaurant.name != null &&
                categoryController.categoryList != null)
                ? CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              slivers: [
                ResponsiveHelper.isDesktop(context)
                    ? SliverToBoxAdapter(
                  child: Container(
                    // color: Color(0xFF171A29),
                    padding: EdgeInsets.all(
                        Dimensions.PADDING_SIZE_LARGE),
                    alignment: Alignment.center,
                    child: Center(
                        child: SizedBox(
                            width: Dimensions.WEB_MAX_WIDTH,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions
                                      .PADDING_SIZE_SMALL),
                              child: Row(children: [
                                //   Expanded(
                                // child: CustomImage(
                                // fit: BoxFit.cover, placeholder: Images.restaurant_cover, height: 220,
                                //  image: '${Get.find<SplashController>().configModel.baseUrls.restaurantCoverPhotoUrl}/${_restaurant.coverPhoto}',
                                // ),
                                // ),
                                // ),
                                // SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

                                Expanded(
                                    child:
                                    RestaurantDescriptionView(
                                        restaurant:
                                        _restaurant)),
                              ]),
                            ))),
                  ),
                )
                    : SliverAppBar(
                  expandedHeight: 50,
                  toolbarHeight: 50,
                  pinned: true,
                  floating: false,
                  backgroundColor: AppColors.primarycolor,
                  leading: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    color: AppColors.primarycolor,
                    height: 50,
                    // width: 125,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 6,
                        ),
                        Image.asset("assets/image/whitelogo.png"),
                      ],
                    ),
                  ),
                  actions: [
                    GestureDetector(
                        onTap: () {
                          Get.toNamed(
                              RouteHelper.getNotificationRoute());
                        },
                        child: Icon(Icons.notifications,
                            color: Colors.white)),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: () =>
                          Get.toNamed(RouteHelper.getCartRoute()),
                      icon: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black),
                        alignment: Alignment.center,
                        child: CartWidget(
                            color: Theme.of(context).cardColor,
                            size: 15,
                            fromRestaurant: true),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.to(() => SearchScreen());
                        },
                        child: Icon(Icons.search)),
                    SizedBox(
                      width: 22,
                    ),
                    GestureDetector(
                        onTap: () async {
                          Get.to(() => ChatScreen2());
                        },
                        child: Icon(
                          Icons.message,
                          size: 20,
                        )),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),

                SliverToBoxAdapter(
                    child: Center(
                        child: Container(
                          width: Dimensions.WEB_MAX_WIDTH,
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          color: Colors.white,
                          child: Column(children: [
                            // GetBuilder<BannerController>(
                            //     builder: (bannerController) {
                            //       return bannerController.bannerImageList == null
                            //           ? BannerView(bannerController: bannerController)
                            //           : bannerController.bannerImageList.length == 0
                            //           ? SizedBox()
                            //           : BannerView(
                            //           bannerController: bannerController);
                            //     }),
                            // ResponsiveHelper.isDesktop(context)
                            //     ? SizedBox()
                            //     : RestaurantDescriptionView(
                            //     restaurant: _restaurant),

                            // GetBuilder<ProductController>(builder: (product) {
                            //   return SizedBox(
                            //     height: 45,
                            //     width: 368,
                            //     child: TextField(
                            //       controller: _controller,
                            //       style: TextStyle(color: Colors.black),
                            //       decoration: InputDecoration(
                            //           enabledBorder: OutlineInputBorder(
                            //               borderSide: BorderSide.none,
                            //               borderRadius: BorderRadius.circular(28)),
                            //           suffixIcon: Padding(
                            //             padding: const EdgeInsets.all(12.0),
                            //             child: SvgPicture.asset(
                            //               "assets/image/searchicon.svg",
                            //             ),
                            //           ),
                            //           fillColor:
                            //           Color(0xff3734910F).withOpacity(0.06),
                            //           filled: true,
                            //           border: OutlineInputBorder(
                            //               borderSide: BorderSide.none,
                            //               borderRadius: BorderRadius.circular(28)),
                            //           hintText: 'Serach  Product ',
                            //           hintStyle: TextStyle(
                            //               color: Colors.grey,
                            //               fontSize: 14,
                            //               fontWeight: FontWeight.w400)),
                            //       onChanged: (value) {
                            //         setState(() {});
                            //       },
                            //     ),
                            //   );
                            // }),
                            _restaurant.discount != null
                                ? Container(
                              width: context.width,
                              margin: EdgeInsets.symmetric(
                                  vertical: Dimensions.PADDING_SIZE_SMALL),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                  color: Color(0xFF009f67)),
                              padding: EdgeInsets.all(
                                  Dimensions.PADDING_SIZE_SMALL),
                              child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _restaurant.discount.discountType ==
                                          'percent'
                                          ? '${_restaurant.discount.discount}% OFF'
                                          : '${PriceConverter.convertPrice(_restaurant.discount.discount)} OFF',
                                      style: robotoMedium.copyWith(
                                          fontSize:
                                          Dimensions.fontSizeLarge,
                                          color:
                                          Theme.of(context).cardColor),
                                    ),
                                    Text(
                                      _restaurant.discount.discountType ==
                                          'percent'
                                          ? '${'enjoy'.tr} ${_restaurant.discount.discount}% ${'off_on_all_categories'.tr}'
                                          : '${'enjoy'.tr} ${PriceConverter.convertPrice(_restaurant.discount.discount)}'
                                          ' ${'off_on_all_categories'.tr}',
                                      style: robotoMedium.copyWith(
                                          fontSize:
                                          Dimensions.fontSizeSmall,
                                          color:
                                          Theme.of(context).cardColor),
                                    ),
                                    SizedBox(
                                        height: (_restaurant.discount
                                            .minPurchase !=
                                            0 ||
                                            _restaurant.discount
                                                .maxDiscount !=
                                                0)
                                            ? 5
                                            : 0),
                                    _restaurant.discount.minPurchase != 0
                                        ? Text(
                                      '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(_restaurant.discount.minPurchase)} ]',
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions
                                              .fontSizeExtraSmall,
                                          color: Theme.of(context)
                                              .cardColor),
                                    )
                                        : SizedBox(),
                                    _restaurant.discount.maxDiscount != 0
                                        ? Text(
                                      '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(_restaurant.discount.maxDiscount)} ]',
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions
                                              .fontSizeExtraSmall,
                                          color: Theme.of(context)
                                              .cardColor),
                                    )
                                        : SizedBox(),
                                    Text(
                                      '[ ${'daily_time'.tr}: ${DateConverter.convertTimeToTime(_restaurant.discount.startTime)} '
                                          '- ${DateConverter.convertTimeToTime(_restaurant.discount.endTime)} ]',
                                      style: robotoRegular.copyWith(
                                          fontSize:
                                          Dimensions.fontSizeExtraSmall,
                                          color:
                                          Theme.of(context).cardColor),
                                    ),
                                  ]),
                            )
                                : SizedBox(),
                          ]),
                        ))),

                /// category tabs
                /// category tabs

                SliverToBoxAdapter(child: Center(
                  child: GetBuilder<ProductController>(
                    builder: (productcontroller) {
                      List<Product> filteredProducts =
                          productcontroller.allproductList ?? [];
                      filteredProducts = filteredProducts
                          .where((product) =>
                      _controller.text.isEmpty ||
                          product.name.toLowerCase().contains(
                              _controller.text.toLowerCase()))
                          .toList();

                      // Reorder the list to place matching items at the beginning
                      filteredProducts.sort((a, b) {
                        bool containsSearchA = a.name
                            .toLowerCase()
                            .contains(_controller.text.toLowerCase());
                        bool containsSearchB = b.name
                            .toLowerCase()
                            .contains(_controller.text.toLowerCase());

                        if (containsSearchA && !containsSearchB) {
                          return -1; // Place A before B
                        } else if (!containsSearchA && containsSearchB) {
                          return 1; // Place B before A
                        } else if (containsSearchA && containsSearchB) {
                          return 0; // Maintain the existing order for items that both contain the search text
                        } else {
                          return 0; // Maintain the existing order for items that don't contain the search text
                        }
                      });

                      return GetBuilder<WishListController>(
                          builder: (wishList) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                  Dimensions.PADDING_SIZE_DEFAULT),
                              width: Dimensions.WEB_MAX_WIDTH,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 17,
                                    ),
                                    Container(
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: buildItem()),

                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text('Categories'.tr,
                                        style: robotoMedium.copyWith(
                                            fontSize:
                                            Dimensions.fontSizeLarge + 2,
                                            fontWeight: FontWeight.w700)),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    GridView.builder(
                                        itemCount: restController
                                            .categoryList.length,
                                        scrollDirection: Axis.vertical,
                                        padding: EdgeInsets.zero,
                                        physics:
                                        NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 8 / 7,
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 8,
                                          mainAxisExtent: 160,
                                          mainAxisSpacing: 6,
                                        ),
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              // print("this is category list ${restController.categoryList[index].name}");
                                              Get.to(
                                                    () => CategoryProductScreen(
                                                  categoryID: restController.categoryList[index].id.toString(),
                                                  categoryName: restController.categoryList[index].name,
                                                  deliveryfee: categoryController.categoryList != null && categoryController.categoryList.isNotEmpty && index < categoryController.categoryList.length
                                                      ? [double.tryParse(categoryController.categoryList[index].deliverycharges ?? '50.0')]
                                                      : [50.0],

                                                  // deliveryfee: productcontroller.allproductList.isNotEmpty && index < productcontroller.allproductList.length
                                                  //     ? [double.parse(categoryController.categoryList[index].deliverycharges)]
                                                  //     : [], // Start with an empty list

                                                ),
                                              );
                                              //
                                              //
                                              // CategoryProductScreen(categoryID: restController.categoryList[index].id.toString(),categoryName: restController.categoryList[index].name,));
                                              // restController.setCategoryIndex(index);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      6),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(
                                                            0.10),
                                                        spreadRadius: 0,
                                                        blurRadius: 23,
                                                        offset: Offset(0, 1)),
                                                  ]),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 120,
                                                    // color: Colors.red,
                                                    width: Get.width,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 17,
                                                        ),
                                                        // Image.asset("assets/image/img_5.png",height: 85,width: 88,),
                                                        Container(
                                                            height: 88,
                                                            width: 88,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    10)),
                                                            child: ClipRRect(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    10),
                                                                child: Image
                                                                    .network(
                                                                  // "https://s3bits.com/ansaarbazar/storage/app/public/category/${restController.categoryList[index].image}",
                                                                  // "http://23.108.96.28/~s3bitsdev/ansaarbazar/storage/app/public/category/${restController.categoryList[index].image}",
                                                                  "https://ansaarbazar.com/api/storage/app/public/category/${restController.categoryList[index].image}",
                                                                  height: 85,
                                                                  width: 88,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                )))
                                                      ],
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                        restController
                                                            .categoryList[
                                                        index]
                                                            .name,
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: robotoMedium
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeDefault,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),

                                    ///under tabs products
                                    ///under tabs products

                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text('Recomended Products',
                                        style: robotoMedium.copyWith(
                                            fontSize:
                                            Dimensions.fontSizeLarge + 2,
                                            fontWeight: FontWeight.w700)),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      height: 500,
                                      color: Colors.white,
                                      child: NotificationListener<ScrollNotification>(
                                        onNotification: (ScrollNotification scrollInfo) {
                                          if (!productcontroller.isLoadingMore &&
                                              scrollInfo.metrics.pixels ==
                                                  scrollInfo.metrics.maxScrollExtent) {
                                            // Start loading more products here
                                            productcontroller.getListenerPaginationData();
                                            return true;
                                          }
                                          return false;
                                        },
                                        child: GridView.builder(
                                          itemCount: productcontroller.isLoadingMore
                                              ? productcontroller.allproductList.length + 1
                                              : productcontroller.allproductList.length,
                                          scrollDirection: Axis.vertical,
                                          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                                          controller: productcontroller.scrollController,
                                          physics: AlwaysScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 8 / 7,
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 3,
                                            mainAxisExtent: 230,
                                            mainAxisSpacing: 10,
                                          ),
                                          itemBuilder: (context, index) {
                                            if (index < productcontroller.allproductList.length) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 4, vertical: 2),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                height: 202,
                                                width: 163,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.24),
                                                      spreadRadius: 0,
                                                      blurRadius: 23,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 8,
                                                    ),


                                                    Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Container(
                                                          height: 120,
                                                          width:
                                                          double.infinity,
                                                          decoration:
                                                          BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                4),
                                                            child: CustomImage(
                                                              height: 120,
                                                              width: 120,
                                                              fit: BoxFit.fill,

                                                              // placeholder: "assets/image/placeholderiages.png",
                                                              image:
                                                              "https://ansaarbazar.com/api/storage/app/public/product/${productcontroller.allproductList[index].image}",
                                                            ),
                                                          ),
                                                        ),

                                                        GestureDetector(
                                                          onTap: () {
                                                            wishList.addToWishList(
                                                                productcontroller
                                                                    .allproductList[
                                                                index],
                                                                Restaurant(),
                                                                false);
                                                            if (kDebugMode) {
                                                              print('Done');
                                                            }
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                            children: [
                                                              // Icon(Icons.favorite_border,color: wishList.,)
                                                              wishList.isInWishList(
                                                                id: productcontroller
                                                                    .allproductList[
                                                                index]
                                                                    .id,
                                                                isRestaurant:
                                                                false,
                                                              )
                                                                  ? Icon(
                                                                Icons
                                                                    .favorite,
                                                                color: Colors
                                                                    .red,
                                                              )
                                                                  : Icon(
                                                                Icons
                                                                    .favorite,
                                                                color: Colors
                                                                    .blue,
                                                              ),
                                                              SizedBox(
                                                                width: 4,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        DiscountTag(
                                                            discount: productcontroller.allproductList[index].discount,
                                                            discountType: productcontroller.allproductList[index].discountType,
                                                            freeDelivery: false
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text(
                                                      productcontroller
                                                          .allproductList[index]
                                                          .name,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                      maxLines: 2,
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      "${productcontroller.allproductList[index].unit} , RS: ${productcontroller.allproductList[index].price.toString()}",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        // color: Color(0xff373491),
                                                        color: Colors.black,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.to(() =>
                                                            ProductDetailScreen(
                                                                deliveryCharges: [
                                                                  double.parse(productcontroller.allproductList[index].delivery_price)
                                                                ],
                                                                // deliveryCharges: [double.parse(productcontroller.allproductList[index].delivery_price)],
                                                                product:
                                                                productcontroller
                                                                    .allproductList[
                                                                index],
                                                                inRestaurantPage:
                                                                true,
                                                                isCampaign:
                                                                false));
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .end,
                                                        children: [
                                                          Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration:
                                                            BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: AppColors
                                                                  .primarycolor,
                                                              // color: Color(0xff189084),
                                                            ),
                                                            child: Icon(
                                                              Icons.add,
                                                              color:
                                                              Colors.white,
                                                              size: 18,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );

                                            } else {
                                              return Center(
                                                child: CircularProgressIndicator(color: Colors.blue),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                    )
                                  ]),
                            );
                          });

                      ///
                    },
                  ),
                ))
              ],
            )
                : Center(child: CircularProgressIndicator());
          });
        }),
      ),
    );
  }

  Widget buildItem() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(
            left: 25,
          ),
          height: 147,
          width: 335,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 24,
                spreadRadius: 4,
                offset: Offset(4, 4),
              )
            ],
            image: DecorationImage(
              image: AssetImage("assets/image/img_13.png"),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(15),
            color: AppColors.primarycolor,
          ),
        ),
      ],
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}

class CategoryProduct {
  CategoryModel category;
  List<Product> products;
  CategoryProduct(this.category, this.products);
}

