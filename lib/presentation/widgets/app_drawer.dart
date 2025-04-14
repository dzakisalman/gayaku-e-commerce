import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gayaku/core/theme/app_colors.dart';
import 'package:gayaku/core/theme/app_text_styles.dart';
import 'package:gayaku/presentation/providers/auth_provider.dart';
import 'package:gayaku/presentation/routes/routes.dart';

class AppDrawer extends StatelessWidget {
  final _authProvider = Get.find<AuthProvider>();

  AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GetBuilder<AuthProvider>(
                    builder: (controller) {
                      final user = controller.currentUser.value;
                      return CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.white,
                        child: user?.photoURL != null
                            ? ClipOval(
                                child: Image.network(
                                  user!.photoURL!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Text(
                                user?.displayName?.substring(0, 1).toUpperCase() ?? 'G',
                                style: AppTextStyles.heading1.copyWith(color: AppColors.primary),
                              ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  GetBuilder<AuthProvider>(
                    builder: (controller) {
                      final user = controller.currentUser.value;
                      return Text(
                        user?.displayName ?? 'Guest',
                        style: AppTextStyles.subtitle1.copyWith(color: AppColors.white),
                      );
                    },
                  ),
                  GetBuilder<AuthProvider>(
                    builder: (controller) {
                      final user = controller.currentUser.value;
                      return Text(
                        user?.email ?? '',
                        style: AppTextStyles.body2.copyWith(color: AppColors.white.withOpacity(0.8)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Get.back();
                    Get.offAllNamed(Routes.HOME);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('Wishlist'),
                  onTap: () {
                    Get.back();
                    Get.toNamed(Routes.WISHLIST);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('Cart'),
                  onTap: () {
                    Get.back();
                    Get.toNamed(Routes.CART);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Get.back();
                    Get.toNamed(Routes.PROFILE);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    try {
                      await _authProvider.logout();
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Failed to sign out: ${e.toString()}',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 60,
                    width: 60,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'GayaKu v1.0.0',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 