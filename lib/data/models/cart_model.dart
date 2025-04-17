import 'product_model.dart';

class CartModel {
  String? id;
  final String userId;
  final ProductModel product;
  final int quantity;
  final DateTime addedAt;

  CartModel({
    this.id,
    required this.userId,
    required this.product,
    required this.quantity,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'product': product.toJson(),
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      userId: json['userId'],
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }
} 