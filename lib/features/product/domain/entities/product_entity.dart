class ProductEntity {
  final int id;
  final String name;
  final String description;
  final double price;
  final String brand;
  final int minimumOrderQuantity;
  final String imgUrl;
  ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.brand,
    required this.minimumOrderQuantity,
    required this.imgUrl,
  });
}
