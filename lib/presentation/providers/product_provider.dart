import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/services/product_service.dart';

class ProductProvider extends GetxController {
  final ProductService _productService = ProductService();
  final products = <ProductModel>[].obs;
  final categories = <String>[].obs;
  final selectedCategory = RxString('');
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    loadCategories();
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      error.value = '';
      final fetchedProducts = await _productService.getProducts(
        category: selectedCategory.value.isEmpty ? null : selectedCategory.value,
      );
      products.assignAll(fetchedProducts);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCategories() async {
    try {
      final fetchedCategories = await _productService.getCategories();
      categories.assignAll(fetchedCategories);
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      return await _productService.getProductById(id);
    } catch (e) {
      error.value = e.toString();
      rethrow;
    }
  }

  void setCategory(String category) {
    if (selectedCategory.value == category) return;
    selectedCategory.value = category;
    loadProducts();
  }

  void clearCategory() {
    if (selectedCategory.value.isEmpty) return;
    selectedCategory.value = '';
    loadProducts();
  }
} 