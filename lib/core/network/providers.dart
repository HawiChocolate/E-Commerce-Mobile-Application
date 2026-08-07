import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'dio_client.dart';
import '../../data/datasources/remote/product_remote_datasource.dart';
import '../../data/repositories/product_repository.dart';

/// Exposes the single shared Dio instance to the Riverpod tree.
final dioProvider = Provider<Dio>((ref) => DioClient().dio);

/// Exposes the ProductRemoteDataSource, built on top of dioProvider.
final productRemoteDataSourceProvider =
    Provider<ProductRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return ProductRemoteDataSourceImpl(dio);
});

/// Exposes the ProductRepository, built on top of the datasource.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  return ProductRepositoryImpl(remoteDataSource);
});