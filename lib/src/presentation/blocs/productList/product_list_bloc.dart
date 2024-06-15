import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:task_tracker/src/domain/models/product_model.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends HydratedBloc<ProductListEvent, ProductListState> {
  ProductListBloc()
      : super(const ProductListInitial(ProducListtModel.initial())) {
    on<AddnewProductEvent>(_newProduct);
    on<RemoveProductEvent>(_removeProductEvent);
    on<UpdateProductEvent>(_updateProductEvent);
    on<DeleteProductEvent>(_deleteProductEvent);
    // on<ProductListEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }

  FutureOr<void> _newProduct(
      AddnewProductEvent event, Emitter<ProductListState> emit) {
    if (state is ProductListInitial) {
      final cs = state as ProductListInitial;
      final loading = cs.productListModel.copyWith(isLoading: true);
      emit(ProductListInitial(loading));

      // Create a copy of the existing list before modifying it
      final existingList = List.from(cs.productListModel.productList);
      existingList.add(event.addNewproduct.toMap());

      final updated = cs.productListModel.copyWith(
        productList: existingList,
        isLoading: false,
      );
      emit(ProductListInitial(updated));
    }
  }

  FutureOr<void> _removeProductEvent(
      RemoveProductEvent event, Emitter<ProductListState> emit) {
    if (state is ProductListInitial) {
      final cs = state as ProductListInitial;
      final existingList = cs.productListModel.productList;
      existingList.removeAt(event.index);
      final updated = cs.productListModel
          .copyWith(productList: existingList, isLoading: false);
      emit(ProductListInitial(updated));
    }
  }

  @override
  Map<String, dynamic> toJson(ProductListState state) {
    if (state is ProductListInitial) {
      final modelJson = state.productListModel.toMap();
      return {'productListModel': modelJson}; ////
    }
    return {};
  }

  @override
  ProductListState? fromJson(Map<String, dynamic> json) {
    try {
      return ProductListInitial(
        ProducListtModel.fromMap(
            json['productListModel'] as Map<String, dynamic>),
      );
    } catch (_) {
      return null;
    }
    // throw UnimplementedError();
  }

  FutureOr<void> _updateProductEvent(
      UpdateProductEvent event, Emitter<ProductListState> emit) {
    if (state is ProductListInitial) {
      final cs = state as ProductListInitial;
      final loading = cs.productListModel.copyWith(isLoading: true);
      emit(ProductListInitial(loading));
      final existingList = List.from(cs.productListModel.productList);
      existingList[event.index] = event.addNewproduct.toMap();
      final updated = cs.productListModel.copyWith(
        productList: existingList,
        isLoading: false,
      );
      emit(ProductListInitial(updated));
    }
  }

  FutureOr<void> _deleteProductEvent(
      DeleteProductEvent event, Emitter<ProductListState> emit) {
    if (state is ProductListInitial) {
      final cs = state as ProductListInitial;
      final loading = cs.productListModel.copyWith(isLoading: true);
      emit(ProductListInitial(loading));
      final existingList = List.from(cs.productListModel.productList);
      existingList.removeAt(event.index);
      final updated = cs.productListModel.copyWith(
        productList: existingList,
        isLoading: false,
      );
      emit(ProductListInitial(updated));
    }
  }
}
