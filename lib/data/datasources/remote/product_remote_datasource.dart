import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/error_handler.dart';
import '../../models/product_model.dart';

/// Talks directly to the Fake Store API for product data.
/// Returns raw ProductModel lists/objects, or throws our custom Exceptions.
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(int id);
  Future<List<ProductModel>> getProductsByCategory(String category);
  Future<List<String>> getCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await dio.get(ApiConstants.products);
      final data = response.data as List;
      return data
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await dio.get(ApiConstants.productById(id));
      return ProductModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await dio.get(ApiConstants.productsByCategory(category));
      final data = response.data as List;
      return data
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await dio.get(ApiConstants.categories);
      final data = response.data as List;
      return data.map((e) => e.toString()).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}