import '../entities/product_entity.dart';

class ProductModelFromLocal extends ProductEntity {
  ProductModelFromLocal({
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

  factory ProductModelFromLocal.fromJson(Map<String, dynamic> json) {
    return ProductModelFromLocal(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      brand: json['brand'],
      minimumOrderQuantity: json['minimumOrderQuantity'],
      imgUrl: json['imgUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price};
  }
}
