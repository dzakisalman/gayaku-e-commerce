import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;
  final _cartProvider = Get.find<CartProvider>();
  final _wishlistProvider = Get.find<WishlistProvider>();

  ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          GetBuilder<WishlistProvider>(
            builder: (controller) {
              final isInWishlist = controller.isInWishlist(product);
              return IconButton(
                icon: Icon(
                  isInWishlist ? Icons.favorite : Icons.favorite_border,
                  color: isInWishlist ? Colors.red : Colors.white,
                ),
                onPressed: () => controller.toggleWishlist(product),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.error_outline, size: 48),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.category,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.rate.toString(),
                        style: AppTextStyles.body2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Rp ${product.price.toStringAsFixed(0)}',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: AppTextStyles.subtitle1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: AppTextStyles.body1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GetBuilder<CartProvider>(
        builder: (controller) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  controller.addToCart(product);
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'Product added to cart',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: const Text('Add to Cart'),
              ),
            ),
          );
        },
      ),
    );
  }
} 