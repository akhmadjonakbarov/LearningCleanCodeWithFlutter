import 'package:learning_clean_code/features/product/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts();
  Future<bool> createProduct();
  Future<bool> updateProduct();
  Future<bool> deleteProduct();
}
