import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/product_card.dart';
import '../../routes/routes.dart';

class WishlistPage extends GetView<WishlistProvider> {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: GetBuilder<WishlistProvider>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.wishlist.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add products to your wishlist to save them for later',
                    style: AppTextStyles.body1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: controller.wishlist.length,
            itemBuilder: (context, index) {
              final item = controller.wishlist[index];
              return ProductCard(
                product: item.product,
                onTap: () => Get.toNamed(
                  Routes.PRODUCT_DETAIL,
                  arguments: item.product,
                ),
              );
            },
          );
        },
      ),
    );
  }
} 