import 'package:learning_clean_code/features/product/domain/entities/product_entity.dart';
import 'package:learning_clean_code/features/product/domain/repositories/product_repository.dart';

class ProductController {
  final ProductRepository productRepository;
  ProductController({required this.productRepository});

  //
  List<ProductEntity> products = [];
  bool isLoading = false;

  Future<void> getProducts() async {
    isLoading = true;
    products = await productRepository.getProducts();
    print(products);
    isLoading = false;
  }

  updatePruduct() {}
}
