import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gayaku/core/routes/app_pages.dart';
import 'package:gayaku/core/theme/app_theme.dart';
import 'package:gayaku/presentation/providers/auth_provider.dart';
import 'package:gayaku/presentation/providers/cart_provider.dart';
import 'package:gayaku/presentation/providers/product_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize providers
  Get.put(AuthProvider());
  Get.put(ProductProvider());
  Get.put(CartProvider());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GayaKu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
