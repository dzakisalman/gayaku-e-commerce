import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'carts';

  Future<List<CartModel>> getCart(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID to the data
        return CartModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load cart: $e');
    }
  }

  Future<void> addToCart(String userId, ProductModel product, int quantity) async {
    try {
      // Check if product already exists in cart
      final existingDoc = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('product.id', isEqualTo: product.id.toString())
          .get();

      if (existingDoc.docs.isNotEmpty) {
        // Update quantity if product exists
        final docId = existingDoc.docs.first.id;
        await _firestore.collection(_collection).doc(docId).update({
          'quantity': FieldValue.increment(quantity),
        });
      } else {
        // Add new item if product doesn't exist
        final cartItem = CartModel(
          userId: userId,
          product: product,
          quantity: quantity,
          addedAt: DateTime.now(),
        );

        final docRef = await _firestore.collection(_collection).add(cartItem.toJson());
        cartItem.id = docRef.id; // Set the document ID
      }
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  Future<void> updateCartItem(String cartId, int quantity) async {
    try {
      if (quantity <= 0) {
        await removeFromCart(cartId);
      } else {
        await _firestore.collection(_collection).doc(cartId).update({
          'quantity': quantity,
        });
      }
    } catch (e) {
      throw Exception('Failed to update cart item: $e');
    }
  }

  Future<void> removeFromCart(String cartId) async {
    try {
      await _firestore.collection(_collection).doc(cartId).delete();
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }

  Future<void> clearCart(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }
} 