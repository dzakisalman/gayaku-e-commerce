import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/models/cart_model.dart';
import '../../data/services/cart_service.dart';
import 'auth_provider.dart';
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
  final _authProvider = Get.find<AuthProvider>();
  final _cartService = CartService();
  final items = <ProductModel>[].obs;
  final quantities = <int, int>{}.obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      isLoading.value = true;
      final userId = _authProvider.currentUser.value?.uid;
      if (userId == null) throw 'User not logged in';
      
      final cartItems = await _cartService.getCart(userId);
      
      // Update local state
      items.clear();
      quantities.clear();
      for (var item in cartItems) {
        items.add(item.product);
        quantities[item.product.id] = item.quantity;
      }
      update();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  double get totalPrice {
    double total = 0;
    for (var item in items) {
      total += item.price * (quantities[item.id] ?? 0);
    }
    return total;
  }

  int get itemCount => items.length;

  Future<void> addToCart(ProductModel product) async {
    try {
      final userId = _authProvider.currentUser.value?.uid;
      if (userId == null) throw 'User not logged in';

      await _cartService.addToCart(userId, product, 1);
      await loadCart(); // Reload cart after adding
      
      Get.snackbar(
        'Berhasil',
        'Produk ditambahkan ke keranjang',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      rethrow;
    }
  }

  Future<void> removeFromCart(ProductModel product) async {
    try {
      final userId = _authProvider.currentUser.value?.uid;
      if (userId == null) throw 'User not logged in';

      // Find the cart item to get its ID
      final cartItems = await _cartService.getCart(userId);
      final cartItem = cartItems.firstWhere(
        (item) => item.product.id == product.id,
        orElse: () => throw 'Item not found in cart',
      );

      if (cartItem.id == null) {
        throw 'Cart item ID is null';
      }

      await _cartService.removeFromCart(cartItem.id!);
      await loadCart(); // Reload cart after removing
    } catch (e) {
      error.value = e.toString();
      rethrow;
    }
  }

  Future<void> updateQuantity(ProductModel product, int quantity) async {
    try {
      final userId = _authProvider.currentUser.value?.uid;
      if (userId == null) throw 'User not logged in';

      if (quantity <= 0) {
        await removeFromCart(product);
      } else {
        // Find the cart item to get its ID
        final cartItems = await _cartService.getCart(userId);
        final cartItem = cartItems.firstWhere(
          (item) => item.product.id == product.id,
          orElse: () => throw 'Item not found in cart',
        );

        if (cartItem.id == null) {
          throw 'Cart item ID is null';
        }

        await _cartService.updateCartItem(cartItem.id!, quantity);
        await loadCart(); // Reload cart after updating
      }
    } catch (e) {
      error.value = e.toString();
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      final userId = _authProvider.currentUser.value?.uid;
      if (userId == null) throw 'User not logged in';

      await _cartService.clearCart(userId);
      await loadCart(); // Reload cart after clearing
    } catch (e) {
      error.value = e.toString();
      rethrow;
    }
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
      await clearCart();
      
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