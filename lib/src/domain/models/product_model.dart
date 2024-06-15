import 'dart:convert';

ProducListtModel producListtModelFromMap(String str) =>
    ProducListtModel.fromMap(json.decode(str));

String producListtModelToMap(ProducListtModel data) =>
    json.encode(data.toMap());

class ProducListtModel {
  final List productList;
  final bool isLoading;

  const ProducListtModel({
    required this.productList,
    required this.isLoading,
  });
  const ProducListtModel.initial()
      : this(isLoading: false, productList: const []);
  ProducListtModel copyWith({
    List? productList,
    bool? isLoading,
  }) =>
      ProducListtModel(
        productList: productList ?? this.productList,
        isLoading: isLoading ?? this.isLoading,
      );

  factory ProducListtModel.fromMap(Map<String, dynamic> json) =>
      ProducListtModel(
        productList: List.from(json["productList"].map((x) => x)),
        isLoading: json["isLoading"],
      );

  Map<String, dynamic> toMap() => {
        "productList": List<dynamic>.from(productList.map((x) => x)),
        "isLoading": isLoading,
      };
}

ProductModel productModelFromMap(String str) =>
    ProductModel.fromMap(json.decode(str));

String productModelToMap(ProductModel data) => json.encode(data.toMap());

class ProductModel {
  final String productType;
  final String productName;
  final String qty;
  final String price;
  final String location;

  const ProductModel({
    required this.productType,
    required this.productName,
    required this.qty,
    required this.price,
    required this.location,
  });

  const ProductModel.initial()
      : this(
            productName: '', location: '', price: '', productType: '', qty: '');

  ProductModel copyWith({
    String? productType,
    String? productName,
    String? qty,
    String? price,
    String? location,
  }) =>
      ProductModel(
        productType: productType ?? this.productType,
        productName: productName ?? this.productName,
        qty: qty ?? this.qty,
        price: price ?? this.price,
        location: location ?? this.location,
      );

  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
        productType: json["productType"],
        productName: json["productName"],
        qty: json["qty"],
        price: json["price"],
        location: json["location"],
      );

  Map<String, dynamic> toMap() => {
        "productType": productType,
        "productName": productName,
        "qty": qty,
        "price": price,
        "location": location,
      };
}
