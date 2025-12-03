import 'package:learning_clean_code/features/product/domain/entities/user_entity.dart';

class UserDBModel extends UserEntity {
  UserDBModel({
    required super.id,
    required super.username,
    required super.email,
  });

  factory UserDBModel.fromJson(Map<String, dynamic> json) {
    return UserDBModel(
      id: json['user_id'],
      username: json['user_username'],
      email: json['user_email'],
    );
  }
}
