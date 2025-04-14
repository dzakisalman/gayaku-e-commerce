import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wishlist_model.dart';
import '../models/product_model.dart';

class WishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'wishlists';

  Future<List<WishlistModel>> getWishlist(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID to the data
        return WishlistModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load wishlist: $e');
    }
  }

  Future<void> addToWishlist(String userId, ProductModel product) async {
    try {
      // Check if product already exists in wishlist
      final existingDoc = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('product.id', isEqualTo: product.id.toString())
          .get();

      if (existingDoc.docs.isNotEmpty) {
        throw Exception('Product already in wishlist');
      }

      final wishlistItem = WishlistModel(
        userId: userId,
        product: product,
        addedAt: DateTime.now(),
      );

      final docRef = await _firestore.collection(_collection).add(wishlistItem.toJson());
      wishlistItem.id = docRef.id; // Set the document ID
    } catch (e) {
      throw Exception('Failed to add to wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(String wishlistId) async {
    try {
      await _firestore.collection(_collection).doc(wishlistId).delete();
    } catch (e) {
      throw Exception('Failed to remove from wishlist: $e');
    }
  }

  Future<void> removeFromWishlistByProduct(String userId, String productId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('product.id', isEqualTo: productId.toString())
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to remove from wishlist: $e');
    }
  }
} 