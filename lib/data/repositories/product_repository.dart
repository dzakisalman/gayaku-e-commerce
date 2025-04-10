import 'package:gayaku/data/dummy/dummy_products.dart';
import 'package:gayaku/data/models/product_model.dart';

class ProductRepository {
  Future<List<ProductModel>> getProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return DummyProducts.products;
  }

  Future<ProductModel> getProductById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return DummyProducts.products.firstWhere((product) => product.id == id);
  }
} 