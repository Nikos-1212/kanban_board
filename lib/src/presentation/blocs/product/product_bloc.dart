import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker/src/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/models/product_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductFormState> {
  late BehaviorSubject<bool> _validFormSubject;

  ProductBloc() : super(const ProductFormState.initial()) {
    on<ProductTypeEvent>(_productTypeEvent);
    on<ProductNameEvent>(_productNameEvent);
    on<ProductPriceEvent>(_productPriceEvent);
    on<ProductQtyEvent>(_productQtyEvent);
    on<ProductLocationEvent>(_productLocationEvent);
    on<ResetFormEvent>(_resetFormEvent);
    _validFormSubject = BehaviorSubject<bool>.seeded(false);
    _updateValidForm();
    on<ProductInitialiseEvent>(_productInitialiseEvent);
  }
  final TextEditingController productNameTxt = TextEditingController();
  final TextEditingController productProductPriceTxt = TextEditingController();
  final TextEditingController productQtyTxt = TextEditingController();
  final TextEditingController productLocationTxt = TextEditingController();
  FutureOr<void> _productTypeEvent(
      ProductTypeEvent event, Emitter<ProductFormState> emit) {
    final us = state.copyWith(
        productType: event.productType,
        validProductType:
            event.productType != AppConst.selectedProductTYpe ? true : false);
    emit(us);
    _updateValidForm();
  }

  FutureOr<void> _productNameEvent(
      ProductNameEvent event, Emitter<ProductFormState> emit) {
    final us = state.copyWith(
        productName: event.productName,
        validProductName:
            event.productName.isEmpty || event.productName.length < 2
                ? false
                : true);
    emit(us);
    _updateValidForm();
  }

  FutureOr<void> _productPriceEvent(
      ProductPriceEvent event, Emitter<ProductFormState> emit) {
    final us = state.copyWith(
        productPrice: event.productPrice,
        validPrice: event.productPrice.isEmpty || event.productPrice.length > 8
            ? false
            : true);
    emit(us);
    _updateValidForm();
  }

  FutureOr<void> _productQtyEvent(
      ProductQtyEvent event, Emitter<ProductFormState> emit) {
    final us = state.copyWith(
        productqty: event.productQty,
        validqty: event.productQty.isEmpty || event.productQty.length > 6
            ? false
            : true);
    emit(us);
    _updateValidForm();
  }

  FutureOr<void> _productLocationEvent(
      ProductLocationEvent event, Emitter<ProductFormState> emit) {
    final us = state.copyWith(
        productLocation: event.productLocation,
        validLocation: event.productLocation.isEmpty ? false : true);
    emit(us);
    _updateValidForm();
  }

  Future<bool> validateForm() async {
    try {
      final newState = state.copyWith(
        validLocation: state.validLocation ?? false,
        validPrice: state.validPrice ?? false,
        validProductName: state.validProductName ?? false,
        validProductType: state.validProductType ?? false,
        validqty: state.validqty ?? false,
      );
      return newState.validProductType! &&
          newState.validProductName! &&
          newState.validPrice! &&
          newState.validqty! &&
          newState.validLocation!;
    } catch (e) {
      return false;
    }
  }

  Stream<bool> get validFormStream => _validFormSubject.stream;
  void _updateValidForm() {
    final newState = state.copyWith(
      validLocation: state.validLocation ?? false,
      validPrice: state.validPrice ?? false,
      validProductName: state.validProductName ?? false,
      validProductType: state.validProductType ?? false,
      validqty: state.validqty ?? false,
    );
    final isValid = newState.validProductType! &&
        newState.validProductName! &&
        newState.validPrice! &&
        newState.validqty! &&
        newState.validLocation!;
    _validFormSubject.add(isValid);
  }

  @override
  Future<void> close() {
    _validFormSubject.close();
    productNameTxt.clear();
    productProductPriceTxt.clear();
    productQtyTxt.clear();
    productLocationTxt.clear();
    return super.close();
  }

  FutureOr<void> _resetFormEvent(
      ResetFormEvent event, Emitter<ProductFormState> emit) async {
    productNameTxt.clear();
    productProductPriceTxt.clear();
    productQtyTxt.clear();
    productLocationTxt.clear();
    emit(const ProductFormState.initial());
  }

  FutureOr<void> _productInitialiseEvent(
      ProductInitialiseEvent event, Emitter<ProductFormState> emit) {
    final us = state.copyWith(
        productLocation: event.productModel.location,
        productName: event.productModel.productName,
        productPrice: event.productModel.price,
        productType: event.productModel.productType,
        productqty: event.productModel.qty,
        validLocation: true,
        validPrice: true,
        validProductName: true,
        validProductType: true,
        validqty: true);
    productNameTxt.text = event.productModel.productName;
    productProductPriceTxt.text = event.productModel.price;
    productQtyTxt.text = event.productModel.qty;
    productLocationTxt.text = event.productModel.location;
    emit(us);
  }
}
