import 'dart:convert';

import 'package:Apka_kitchen/controller/auth_controller.dart';
import 'package:Apka_kitchen/controller/banner_controller.dart';
import 'package:Apka_kitchen/controller/campaign_controller.dart';
import 'package:Apka_kitchen/controller/cart_controller.dart';
import 'package:Apka_kitchen/controller/category_controller.dart';
import 'package:Apka_kitchen/controller/coupon_controller.dart';
import 'package:Apka_kitchen/controller/localization_controller.dart';
import 'package:Apka_kitchen/controller/location_controller.dart';
import 'package:Apka_kitchen/controller/notification_controller.dart';
import 'package:Apka_kitchen/controller/onboarding_controller.dart';
import 'package:Apka_kitchen/controller/order_controller.dart';
import 'package:Apka_kitchen/controller/product_controller.dart';
import 'package:Apka_kitchen/controller/restaurant_controller.dart';
import 'package:Apka_kitchen/controller/search_controller.dart';
// import 'package:Apka_kitchen/controller/sendController.dart';
import 'package:Apka_kitchen/controller/splash_controller.dart';
import 'package:Apka_kitchen/controller/theme_controller.dart';
import 'package:Apka_kitchen/controller/user_controller.dart';
import 'package:Apka_kitchen/controller/wishlist_controller.dart';
import 'package:Apka_kitchen/data/api/api_client.dart';
import 'package:Apka_kitchen/data/model/response/language_model.dart';
import 'package:Apka_kitchen/data/repository/auth_repo.dart';
import 'package:Apka_kitchen/data/repository/banner_repo.dart';
import 'package:Apka_kitchen/data/repository/campaign_repo.dart';
import 'package:Apka_kitchen/data/repository/cart_repo.dart';
import 'package:Apka_kitchen/data/repository/category_repo.dart';
import 'package:Apka_kitchen/data/repository/coupon_repo.dart';
import 'package:Apka_kitchen/data/repository/language_repo.dart';
import 'package:Apka_kitchen/data/repository/location_repo.dart';
import 'package:Apka_kitchen/data/repository/notification_repo.dart';
import 'package:Apka_kitchen/data/repository/onboarding_repo.dart';
import 'package:Apka_kitchen/data/repository/order_repo.dart';
import 'package:Apka_kitchen/data/repository/product_repo.dart';
import 'package:Apka_kitchen/data/repository/restaurant_repo.dart';
import 'package:Apka_kitchen/data/repository/search_repo.dart';
// import 'package:Apka_kitchen/data/repository/send_message_repo.dart';
import 'package:Apka_kitchen/data/repository/splash_repo.dart';
import 'package:Apka_kitchen/data/repository/user_repo.dart';
import 'package:Apka_kitchen/data/repository/wishlist_repo.dart';
import 'package:Apka_kitchen/util/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/chat_controller.dart';
import '../controller/send_msg_controller.dart';
import '../data/repository/chat_repo.dart';
import '../data/repository/send_msg_repo.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  // Repository
  Get.lazyPut(() => SplashRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => LanguageRepo());
  Get.lazyPut(() => OnBoardingRepo());
  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => LocationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));
  Get.lazyPut(() => BannerRepo(apiClient: Get.find()));
  Get.lazyPut(() => CategoryRepo(apiClient: Get.find()));
  Get.lazyPut(() => RestaurantRepo(apiClient: Get.find()));
  Get.lazyPut(() => WishListRepo(apiClient: Get.find()));
  Get.lazyPut(() => ProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => SearchRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CouponRepo(apiClient: Get.find()));
  Get.lazyPut(() => OrderRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => NotificationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CampaignRepo(apiClient: Get.find()));
  Get.lazyPut(() => SendRepo(apiClient: Get.find()));
  Get.lazyPut(() => ChatRepo(apiClient: Get.find()));

  // Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => SendMessageController(sendRepo: Get.find()));
  Get.lazyPut(() => ReciverMsgController(chatRepo: Get.find()));
  Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => OnBoardingController(onboardingRepo: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(() => BannerController(bannerRepo: Get.find()));
  Get.lazyPut(() => CategoryController(categoryRepo: Get.find()));
  Get.lazyPut(() => ProductController(productRepo: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.lazyPut(() => RestaurantController(restaurantRepo: Get.find()));
  Get.lazyPut(() => WishListController(wishListRepo: Get.find(), productRepo: Get.find()));
  Get.lazyPut(() => SearchController(searchRepo: Get.find()));
  Get.lazyPut(() => CouponController(couponRepo: Get.find()));
  Get.lazyPut(() => OrderController(orderRepo: Get.find()));
  Get.lazyPut(() => NotificationController(notificationRepo: Get.find()));
  Get.lazyPut(() => CampaignController(campaignRepo: Get.find()));

  // Retrieving localized data
  Map<String, Map<String, String>> _languages = Map();
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> _mappedJson = json.decode(jsonStringValues);
    Map<String, String> _json = Map();
    _mappedJson.forEach((key, value) {
      _json[key] = value.toString();
    });
    _languages['${languageModel.languageCode}_${languageModel.countryCode}'] = _json;
  }
  return _languages;
}
