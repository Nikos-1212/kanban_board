part of 'product_list_bloc.dart';

sealed class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

final class ProductListInitial extends ProductListState {
  const ProductListInitial(this.productListModel);
  final ProducListtModel productListModel;

  @override
  List<Object> get props => [productListModel];
}
