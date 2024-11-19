part of 'bloc.dart';

enum ProductStatus { initial, loading, success, error }

extension ProductStatusX on ProductStatus {
  bool get isInitial => this == ProductStatus.initial;
  bool get isLoading => this == ProductStatus.loading;
  bool get isSuccess => this == ProductStatus.success;
  bool get isError => this == ProductStatus.error;
}

class ProductState extends Equatable {
  final ProductStatus status;
  final List<Product> products;
  final String message;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.message = '',
  });

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? products,
    String? message,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, products, message];
}
