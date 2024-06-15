part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class ProductTypeEvent extends ProductEvent {
  final String productType;
  const ProductTypeEvent({required this.productType});

  @override
  List<Object> get props => [productType];
}

class ProductNameEvent extends ProductEvent {
  final String productName;
  const ProductNameEvent({required this.productName});

  @override
  List<Object> get props => [productName];
}

class ProductPriceEvent extends ProductEvent {
  final String productPrice;
  const ProductPriceEvent({required this.productPrice});

  @override
  List<Object> get props => [productPrice];
}

class ProductQtyEvent extends ProductEvent {
  final String productQty;
  const ProductQtyEvent({required this.productQty});

  @override
  List<Object> get props => [productQty];
}

class ProductLocationEvent extends ProductEvent {
  final String productLocation;
  const ProductLocationEvent({required this.productLocation});

  @override
  List<Object> get props => [productLocation];
}

class ResetFormEvent extends ProductEvent {
  const ResetFormEvent();

  @override
  List<Object> get props => [];
}

class ProductInitialiseEvent extends ProductEvent {
  final ProductModel productModel;
  const ProductInitialiseEvent({required this.productModel});

  @override
  List<Object> get props => [productModel];
}
