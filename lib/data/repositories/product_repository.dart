import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../datasources/remote/product_remote_datasource.dart';
import '../models/product_model.dart';

/// Result wrapper so callers don't need a try/catch — they just check
/// which side of the Result is populated. Simple hand-rolled alternative
/// to bringing in a package like dartz/fpdart.
class Result<T> {
  final T? data;
  final Failure? failure;

  const Result.success(this.data) : failure = null;
  const Result.failureResult(this.failure) : data = null;

  bool get isSuccess => failure == null;
}

abstract class ProductRepository {
  Future<Result<List<ProductModel>>> getAllProducts();
  Future<Result<ProductModel>> getProductById(int id);
  Future<Result<List<ProductModel>>> getProductsByCategory(String category);
  Future<Result<List<String>>> getCategories();
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<ProductModel>>> getAllProducts() async {
    try {
      final products = await remoteDataSource.getAllProducts();
      return Result.success(products);
    } on NetworkException catch (e) {
      return Result.failureResult(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Result.failureResult(ServerFailure(e.message));
    } catch (e) {
      return Result.failureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<ProductModel>> getProductById(int id) async {
    try {
      final product = await remoteDataSource.getProductById(id);
      return Result.success(product);
    } on NetworkException catch (e) {
      return Result.failureResult(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Result.failureResult(ServerFailure(e.message));
    } catch (e) {
      return Result.failureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<ProductModel>>> getProductsByCategory(
      String category) async {
    try {
      final products =
          await remoteDataSource.getProductsByCategory(category);
      return Result.success(products);
    } on NetworkException catch (e) {
      return Result.failureResult(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Result.failureResult(ServerFailure(e.message));
    } catch (e) {
      return Result.failureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<String>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Result.success(categories);
    } on NetworkException catch (e) {
      return Result.failureResult(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Result.failureResult(ServerFailure(e.message));
    } catch (e) {
      return Result.failureResult(UnknownFailure(e.toString()));
    }
  }
}