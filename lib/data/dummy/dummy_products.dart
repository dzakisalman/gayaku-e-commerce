import '../models/product_model.dart';

class DummyProducts {
  static final List<ProductModel> products = [
    ProductModel(
      id: 1,
      title: 'Kaos Polos Hitam',
      price: 150000,
      description: 'Kaos polos berkualitas tinggi dengan bahan katun yang nyaman dipakai.',
      category: 'T-Shirt',
      image: 'https://i.pravatar.cc/300?img=1',
      rating: Rating(rate: 4.5, count: 120),
    ),
    ProductModel(
      id: 2,
      title: 'Celana Jeans Slim',
      price: 350000,
      description: 'Celana jeans slim fit dengan bahan denim berkualitas.',
      category: 'Jeans',
      image: 'https://i.pravatar.cc/300?img=2',
      rating: Rating(rate: 4.2, count: 85),
    ),
    ProductModel(
      id: 3,
      title: 'Jaket Denim',
      price: 450000,
      description: 'Jaket denim klasik dengan desain modern dan tahan lama.',
      category: 'Jacket',
      image: 'https://i.pravatar.cc/300?img=3',
      rating: Rating(rate: 4.8, count: 65),
    ),
    ProductModel(
      id: 4,
      title: 'Kemeja Flanel',
      price: 250000,
      description: 'Kemeja flanel hangat dengan motif kotak-kotak yang stylish.',
      category: 'Shirt',
      image: 'https://i.pravatar.cc/300?img=4',
      rating: Rating(rate: 4.3, count: 95),
    ),
  ];
} 