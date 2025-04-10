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
            onPressed: () => Get.toNamed('/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authProvider.logout(),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: Obx(() {
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
              return _buildProductGrid();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        final currentCategory = controller.selectedCategory.value;
        
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: const Text('All'),
                  selected: currentCategory.isEmpty,
                  onSelected: (_) => controller.clearCategory(),
                  selectedColor: AppColors.primary.withOpacity(0.3),
                  checkmarkColor: AppColors.primary,
                ),
              );
            }
            final category = controller.categories[index - 1];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category),
                selected: currentCategory == category,
                onSelected: (_) => controller.setCategory(category),
                selectedColor: AppColors.primary.withOpacity(0.3),
                checkmarkColor: AppColors.primary,
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildProductGrid() {
    return Obx(() => GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: controller.products.length,
      itemBuilder: (context, index) {
        final product = controller.products[index];
        return ProductCard(
          product: product,
          onTap: () => Get.toNamed(
            '/product-detail',
            arguments: product,
          ),
        );
      },
    ));
  }
} 