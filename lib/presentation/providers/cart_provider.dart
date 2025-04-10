import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import 'package:flutter/material.dart';

class CartItem {
  final ProductModel product;
  final int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}

class CartProvider extends GetxController {
  final RxList<ProductModel> items = <ProductModel>[].obs;
  final RxMap<int, int> quantities = <int, int>{}.obs;
  final isLoading = false.obs;

  double get totalPrice {
    double total = 0;
    for (var item in items) {
      total += item.price * (quantities[item.id] ?? 0);
    }
    return total;
  }

  int get itemCount => items.length;

  void addToCart(ProductModel product) {
    if (!items.contains(product)) {
      items.add(product);
      quantities[product.id] = 1;
    } else {
      quantities[product.id] = (quantities[product.id] ?? 0) + 1;
    }
    update();
    
    Get.snackbar(
      'Berhasil',
      'Produk ditambahkan ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void removeFromCart(ProductModel product) {
    items.remove(product);
    quantities.remove(product.id);
    update();
  }

  void updateQuantity(ProductModel product, int quantity) {
    if (quantity <= 0) {
      removeFromCart(product);
    } else {
      quantities[product.id] = quantity;
    }
    update();
  }

  void clearCart() {
    items.clear();
    quantities.clear();
    update();
  }

  int getQuantity(ProductModel product) {
    return quantities[product.id] ?? 0;
  }

  Future<void> checkout() async {
    try {
      isLoading.value = true;
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Clear cart after successful checkout
      clearCart();
      
      Get.snackbar(
        'Berhasil',
        'Pesanan berhasil diproses',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate back to home
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memproses pesanan. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
} 