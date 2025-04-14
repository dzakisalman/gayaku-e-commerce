import 'package:get/get.dart';
import '../../data/models/wishlist_model.dart';
import '../../data/models/product_model.dart';
import '../../data/services/wishlist_service.dart';
import 'auth_provider.dart';

class WishlistProvider extends GetxController {
  final _authProvider = Get.find<AuthProvider>();
  final _wishlistService = WishlistService();
  final wishlist = <WishlistModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  @override
  void onClose() {
    wishlist.clear();
    super.onClose();
  }

  Future<void> loadWishlist() async {
    try {
      isLoading.value = true;
      final userId = _authProvider.currentUser.value?.uid;
      if (userId == null) throw 'User not logged in';
      
      final items = await _wishlistService.getWishlist(userId);
      wishlist.assignAll(items);
      update();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  bool isInWishlist(ProductModel product) {
    return wishlist.any((item) => item.product.id == product.id);
  }

  Future<void> toggleWishlist(ProductModel product) async {
    try {
      final userId = _authProvider.currentUser.value?.uid;
      if (userId == null) throw 'User not logged in';

      if (isInWishlist(product)) {
        await removeFromWishlist(product);
      } else {
        await addToWishlist(product);
      }
    } catch (e) {
      error.value = e.toString();
      rethrow;
    }
  }

  Future<void> addToWishlist(ProductModel product) async {
    try {
      final userId = _authProvider.currentUser.value?.uid;
      if (userId == null) throw 'User not logged in';

      await _wishlistService.addToWishlist(userId, product);
      await loadWishlist(); // Reload wishlist after adding
      Get.snackbar(
        'Success',
        'Added to wishlist',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
      rethrow;
    }
  }

  Future<void> removeFromWishlist(ProductModel product) async {
    try {
      final userId = _authProvider.currentUser.value?.uid;
      if (userId == null) throw 'User not logged in';

      // Find the wishlist item to get its ID
      final wishlistItem = wishlist.firstWhere(
        (item) => item.product.id == product.id,
        orElse: () => throw 'Item not found in wishlist',
      );

      if (wishlistItem.id == null) {
        throw 'Wishlist item ID is null';
      }

      // Remove from Firestore using the wishlist item ID
      await _wishlistService.removeFromWishlist(wishlistItem.id!);
      
      // Remove from local list
      wishlist.removeWhere((item) => item.product.id == product.id);
      update();

      Get.snackbar(
        'Success',
        'Removed from wishlist',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
      rethrow;
    }
  }
} 