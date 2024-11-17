import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_repository/service/firestore_service.dart';
import 'package:equatable/equatable.dart';
import 'package:product_repository/models/product.dart';

part 'event.dart';
part 'state.dart';

/*
 * Main description:
This file describes every event that bloc can have and connects those events with the states and repositories
 */
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FirestoreProductService productRepository;

  ProductBloc({
    required this.productRepository,
  }) : super(const ProductState()) {
    on<LoadProducts>(_mapLoadProductsEvent);
    on<AddProduct>(_mapAddProductEvent);
    on<UpdateProduct>(_mapUpdateProductEvent);
    on<DeleteProduct>(_mapDeleteProductEvent);
  }

  // Event Handlers

  void _mapLoadProductsEvent(LoadProducts event, Emitter<ProductState> emit) async {
    try {
      emit(state.copyWith(status: ProductStatus.loading));
      final products = await productRepository.getProducts();
      emit(state.copyWith(status: ProductStatus.success, products: products));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: 'Failed to load products'));
    }
  }

  void _mapAddProductEvent(AddProduct event, Emitter<ProductState> emit) async {
    try {
      emit(state.copyWith(status: ProductStatus.loading));
      await productRepository.addProduct(event.product);
      final updatedProducts = await productRepository.getProducts();
      emit(state.copyWith(status: ProductStatus.success, products: updatedProducts));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: 'Failed to add product'));
    }
  }

  void _mapUpdateProductEvent(UpdateProduct event, Emitter<ProductState> emit) async {
    try {
      emit(state.copyWith(status: ProductStatus.loading));
      await productRepository.updateProduct(event.product);
      final updatedProducts = await productRepository.getProducts();
      emit(state.copyWith(status: ProductStatus.success, products: updatedProducts));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: 'Failed to update product'));
    }
  }

  void _mapDeleteProductEvent(DeleteProduct event, Emitter<ProductState> emit) async {
    try {
      emit(state.copyWith(status: ProductStatus.loading));
      await productRepository.deleteProduct(event.productId);
      final updatedProducts = await productRepository.getProducts();
      emit(state.copyWith(status: ProductStatus.success, products: updatedProducts));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: 'Failed to delete product'));
    }
  }
}
