import '../entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.brand,
    required super.minimumOrderQuantity,
    required super.imgUrl,
  });

  // Eski
  //   ProductModel({
  //     required int id,
  //     required String name,
  //     required String description,
  //     required String brand,
  //     required double price,
  //     required int minimumOrderQuantity,
  //   }) : super(
  //          id: id,
  //          name: name,
  //          description: description,
  //          price: price,
  //          brand: brand,
  //          minimumOrderQuantity: minimumOrderQuantity,
  //        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['title'],
      description: json['description'],
      price: json['price'],
      brand: json['brand'],
      minimumOrderQuantity: json['minimumOrderQuantity'],
      imgUrl: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price};
  }
}
