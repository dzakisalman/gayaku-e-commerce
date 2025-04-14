import 'product_model.dart';

class WishlistModel {
  String? id;
  final String userId;
  final ProductModel product;
  final DateTime addedAt;

  WishlistModel({
    this.id,
    required this.userId,
    required this.product,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'product': product.toJson(),
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'],
      userId: json['userId'],
      product: ProductModel.fromJson(json['product']),
      addedAt: DateTime.parse(json['addedAt']),
    );
  }
} 