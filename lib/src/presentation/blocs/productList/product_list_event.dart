part of 'product_list_bloc.dart';

sealed class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object> get props => [];
}

class AddnewProductEvent extends ProductListEvent {
  const AddnewProductEvent(this.addNewproduct);
  final ProductModel addNewproduct;
  @override
  List<Object> get props => [addNewproduct];
}

class RemoveProductEvent extends ProductListEvent {
  const RemoveProductEvent(this.index);
  final int index;
  @override
  List<Object> get props => [index];
}

class UpdateProductEvent extends ProductListEvent {
  const UpdateProductEvent(this.addNewproduct, this.index);
  final ProductModel addNewproduct;
  final int index;
  @override
  List<Object> get props => [addNewproduct, index];
}

class DeleteProductEvent extends ProductListEvent {
  const DeleteProductEvent(this.index);
  final int index;
  @override
  List<Object> get props => [index];
}
