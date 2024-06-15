part of 'product_bloc.dart';

class ProductFormState extends Equatable {
  final String productType;
  final String productName;
  final String productPrice;
  final String productqty;
  final String productLocation;

  final bool? validProductType;
  final bool? validProductName;
  final bool? validqty;
  final bool? validPrice;
  final bool? validLocation;
  final bool? isLoading;

  const ProductFormState({
    this.validProductType,
    this.validProductName,
    this.validqty,
    this.validPrice,
    this.validLocation,
    this.isLoading = false,
    this.productType = AppConst.selectedProductTYpe,
    this.productName = '',
    this.productPrice = '',
    this.productqty = '',
    this.productLocation = '',
  });

  const ProductFormState.initial()
      : this(
            productType: AppConst.selectedProductTYpe,
            productName: '',
            productPrice: '',
            productqty: '',
            productLocation: '',
            isLoading: false,
            validLocation: null,
            validPrice: null,
            validProductName: null,
            validProductType: null,
            validqty: null);

  ProductFormState copyWith({
    String? productType,
    String? productName,
    String? productPrice,
    String? productqty,
    String? productLocation,
    bool? validProductType,
    bool? validProductName,
    bool? validqty,
    bool? validPrice,
    bool? validLocation,
  }) {
    return ProductFormState(
      productType: productType ?? this.productType,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      productqty: productqty ?? this.productqty,
      productLocation: productLocation ?? this.productLocation,
      isLoading: isLoading ?? isLoading,
      validLocation: validLocation ?? this.validLocation,
      validPrice: validPrice ?? this.validPrice,
      validProductName: validProductName ?? this.validProductName,
      validProductType: validProductType ?? this.validProductType,
      validqty: validqty ?? this.validqty,
    );
  }

  @override
  List<Object?> get props => [
        productType,
        productName,
        productPrice,
        productqty,
        productLocation,
        validProductType,
        validProductName,
        validqty,
        validPrice,
        validLocation,
        isLoading,
      ];
}
