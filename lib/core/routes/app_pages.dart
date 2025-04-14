import 'package:get/get.dart';
import 'package:gayaku/data/models/product_model.dart';
import 'package:gayaku/presentation/pages/auth/login_page.dart';
import 'package:gayaku/presentation/pages/auth/register_page.dart';
import 'package:gayaku/presentation/pages/cart/cart_page.dart';
import 'package:gayaku/presentation/pages/checkout/checkout_page.dart';
import 'package:gayaku/presentation/pages/home/home_page.dart';
import 'package:gayaku/presentation/pages/product/product_detail_page.dart';
import 'package:gayaku/presentation/pages/profile/profile_page.dart';
import 'package:gayaku/presentation/providers/auth_provider.dart';
import 'package:gayaku/presentation/providers/cart_provider.dart';
import 'package:gayaku/presentation/providers/wishlist_provider.dart';
import 'package:gayaku/presentation/pages/wishlist/wishlist_page.dart';
import 'package:gayaku/presentation/routes/routes.dart';
import 'package:gayaku/presentation/providers/product_provider.dart';
// import 'package:flutter/material.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: BindingsBuilder(() {
        Get.put(AuthProvider());
      }),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      binding: BindingsBuilder(() {
        Get.put(ProductProvider());
        Get.put(WishlistProvider());
        Get.put(CartProvider());
      }),
    ),
    GetPage(
      name: Routes.PRODUCT_DETAIL,
      page: () => ProductDetailPage(product: Get.arguments),
      binding: BindingsBuilder(() {
        Get.put(ProductProvider());
        Get.put(WishlistProvider());
        Get.put(CartProvider());
      }),
    ),
    GetPage(
      name: Routes.CART,
      page: () => CartPage(),
      binding: BindingsBuilder(() {
        Get.put(CartProvider());
        Get.put(WishlistProvider());
      }),
    ),
    GetPage(
      name: Routes.CHECKOUT,
      page: () => CheckoutPage(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfilePage(),
      binding: BindingsBuilder(() {
        Get.put(AuthProvider());
        Get.put(WishlistProvider());
      }),
    ),
    GetPage(
      name: Routes.WISHLIST,
      page: () => const WishlistPage(),
      binding: BindingsBuilder(() {
        Get.put(WishlistProvider());
      }),
    ),
  ];
}