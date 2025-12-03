import 'package:dio/dio.dart';
import 'package:learning_clean_code/features/home/services/todo_service.dart';

import '../models/product.dart';
import '../models/todo.dart';

class TodoController {
  TodoService service = TodoService(Dio());

  Future<List<Todo>> fetchTodos() async {
    try {
      final todos = await service.fetchTodos();
      return todos;
    } catch (e) {
      rethrow;
    }
  }
}

class ProductController {
  // ProductService service = ProductService(Dio());

  // get // fetch
  // getById // fetchById

  Future<List<Product>> fetchProducts() async {
    try {
      // final products = await service.fetchProducts();
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
