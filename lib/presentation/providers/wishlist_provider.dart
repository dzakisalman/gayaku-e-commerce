import 'package:get/get.dart';
import '../../data/models/wishlist_model.dart';
import '../../data/models/product_model.dart';
import 'auth_provider.dart';

class WishlistProvider extends GetxController {
  final _authProvider = Get.find<AuthProvider>();
  final wishlist = <WishlistModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    try {
      isLoading.value = true;
      // TODO: Implement loading wishlist from backend
      // For now, we'll use dummy data
      wishlist.value = [];
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

      final wishlistItem = WishlistModel(
        userId: userId,
        product: product,
        addedAt: DateTime.now(),
      );

      // TODO: Implement adding to backend
      wishlist.add(wishlistItem);
      update();
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
      // TODO: Implement removing from backend
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