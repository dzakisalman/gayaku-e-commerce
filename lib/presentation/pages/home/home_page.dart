import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import 'package:gayaku/presentation/providers/auth_provider.dart';
import 'package:gayaku/presentation/providers/cart_provider.dart';
// import 'package:gayaku/data/dummy/dummy_products.dart';
import 'package:gayaku/presentation/widgets/app_drawer.dart';
import 'package:gayaku/presentation/routes/routes.dart';

class HomePage extends GetView<ProductProvider> {
  final _cartProvider = Get.find<CartProvider>();
  final _authProvider = Get.find<AuthProvider>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GayaKu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Get.toNamed(Routes.CART),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: GetBuilder<AuthProvider>(
              builder: (authController) {
                return Text(
                  'Welcome, ${authController.currentUser.value?.displayName ?? 'Guest'}!',
                  style: AppTextStyles.heading2,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: GetBuilder<ProductProvider>(
                builder: (productController) {
                  return Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: productController.selectedCategory.value.isEmpty,
                        onSelected: (selected) {
                          if (selected) {
                            productController.selectedCategory.value = '';
                            productController.update();
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      ...productController.categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: productController.selectedCategory.value == category,
                            onSelected: (selected) {
                              if (selected) {
                                productController.selectedCategory.value = category;
                                productController.update();
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GetBuilder<ProductProvider>(
              builder: (controller) {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.error.value.isNotEmpty) {
                  return Center(
                    child: Text(
                      controller.error.value,
                      style: AppTextStyles.body1.copyWith(color: Colors.red),
                    ),
                  );
                }

                final filteredProducts = controller.selectedCategory.value.isEmpty
                    ? controller.products
                    : controller.products
                        .where((product) => product.category == controller.selectedCategory.value)
                        .toList();

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () => Get.toNamed(
                        Routes.PRODUCT_DETAIL,
                        arguments: product,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 