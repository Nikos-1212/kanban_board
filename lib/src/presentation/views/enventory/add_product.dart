import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/src/config/themes.dart';
import 'package:task_tracker/src/domain/models/product_model.dart';
import 'package:task_tracker/src/presentation/blocs/product/product_bloc.dart';
import 'package:task_tracker/src/presentation/blocs/productList/product_list_bloc.dart';
import 'package:task_tracker/src/presentation/widgets/inline_field_errors.dart';
import 'package:task_tracker/src/presentation/widgets/primary_btn.dart';
import 'package:task_tracker/src/presentation/widgets/textfiled.dart';
import 'package:task_tracker/src/utils/utils.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({
    super.key,
    this.index,
  });
  final int? index;
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  List productList = [
    AppConst.selectedProductTYpe,
    'T-shirt',
    'Laptop',
    'Product',
    'Printer paper',
    'Snacks'
  ];

  @override
  void initState() {
    super.initState();
    _initValues();
  }

  Future _initValues() async {
    if (widget.index != null && widget.index is int) {
      final obj = context.read<ProductListBloc>().state as ProductListInitial;
      final eList = obj.productListModel.productList;
      final res = eList[widget.index!];
      context
          .read<ProductBloc>()
          .add(ProductInitialiseEvent(productModel: ProductModel.fromMap(res)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            AppConst.newProduct,
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _body(),
            _btn(),
          ],
        ));
  }

  Widget _body() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 15),
          child: BlocConsumer<ProductBloc, ProductFormState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Form(
                child: Column(
                  children: [
                    _productType(state),
                    const SizedBox(
                      height: 15,
                    ),
                    _productNameField(state),
                    const SizedBox(
                      height: 15,
                    ),
                    _productPriceField(state),
                    const SizedBox(
                      height: 15,
                    ),
                    _productQtyField(state),
                    const SizedBox(
                      height: 15,
                    ),
                    _productLocationField(state),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _productType(ProductFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                padding: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(color: Colors.grey),
                  // color: AppColor.grey10,
                ),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none, // Remove underline
                  ),

                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  icon: const Icon(Icons.arrow_drop_down,
                      color: Color(0xff3C3C3E)),
                  hint: const Text(
                    AppConst.selectedProductTYpe,
                    style: TextStyle(color: Color(0xffD9D9E1)),
                  ),
                  value: state.productType,
                  items: productList.map((dynamic dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      onTap: () {
                        // sourceofLeadID =dropDownStringItem.sId;
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          dropDownStringItem,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (dynamic res) {
                    context
                        .read<ProductBloc>()
                        .add(ProductTypeEvent(productType: res));
                    FocusScope.of(context).unfocus();
                  },
                  isExpanded: true,
                ),
              ),
            ),
          ],
        ),
        if (state.validProductType != null &&
            state.validProductType == false) ...[
          const SizedBox(
            height: 3,
          ),
          const InlinError(errorMessage: ' Please select valid options')
        ]
      ],
    );
  }

  Widget _productNameField(ProductFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppConst.pName,
          style: TextStyle(
            fontSize: 13,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 4,
        ),
        BorderTextField(
          controller: context.read<ProductBloc>().productNameTxt,
          hintText: AppConst.pName,
          textInputAction: TextInputAction.next,
          onSave: (p0) => state.productName,
          isSuffix: state.validProductName != null ? true : false,
          suffixIcon: state.validProductName != null
              ? Icon(
                  state.validProductName!
                      ? Icons.check_circle_outline_outlined
                      : Icons.close,
                  color: state.validProductName!
                      ? AppColors.primaryColour
                      : AppColors.errorColour,
                )
              : const SizedBox.shrink(),
          onChanged: (_) async {
            context.read<ProductBloc>().add(ProductNameEvent(productName: _));
          },
          validator: (value) {
            if (value.isEmpty ||
                state.validProductName == null ||
                state.validProductName == false) {
              return 'Empty field not allow';
            } else {
              return null;
            }
          },
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(45),
          ],
        ),
        if (state.validProductName != null &&
            state.validProductName == false) ...[
          const SizedBox(
            height: 3,
          ),
          const InlinError(errorMessage: ' >2 charecters')
        ]
      ],
    );
  }

  Widget _productPriceField(ProductFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppConst.pPrice,
          style: TextStyle(
            fontSize: 13,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 4,
        ),
        BorderTextField(
          controller: context.read<ProductBloc>().productProductPriceTxt,
          hintText: AppConst.pPrice,
          textInputAction: TextInputAction.next,
          onSave: (p0) => state.productPrice,
          isSuffix: state.validPrice != null ? true : false,
          suffixIcon: state.validPrice != null
              ? Icon(
                  state.validPrice!
                      ? Icons.check_circle_outline_outlined
                      : Icons.close,
                  color: state.validPrice!
                      ? AppColors.primaryColour
                      : AppColors.errorColour,
                )
              : const SizedBox.shrink(),
          onChanged: (_) async {
            context.read<ProductBloc>().add(ProductPriceEvent(productPrice: _));
          },
          validator: (value) {
            if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value) ||
                (state.validPrice != null && !state.validPrice!)) {
              return 'Enter valid Price';
            } else {
              return null;
            }
          },
          keyboardType: const TextInputType.numberWithOptions(
              decimal: true, signed: false),
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
        ),
        if (state.validPrice != null && state.validPrice == false) ...[
          const SizedBox(
            height: 3,
          ),
          const InlinError(errorMessage: ' Not empty and < 8 digit')
        ]
      ],
    );
  }

  Widget _productQtyField(ProductFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppConst.pQty,
          style: TextStyle(
            fontSize: 13,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 4,
        ),
        BorderTextField(
          controller: context.read<ProductBloc>().productQtyTxt,
          hintText: AppConst.pQty,
          textInputAction: TextInputAction.next,
          onSave: (p0) => state.productqty,
          isSuffix: state.validqty != null ? true : false,
          suffixIcon: state.validqty != null
              ? Icon(
                  state.validqty!
                      ? Icons.check_circle_outline_outlined
                      : Icons.close,
                  color: state.validqty!
                      ? AppColors.primaryColour
                      : AppColors.errorColour,
                )
              : const SizedBox.shrink(),
          onChanged: (_) async {
            context.read<ProductBloc>().add(ProductQtyEvent(productQty: _));
          },
          validator: (value) {
            if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value) ||
                (state.validqty != null && !state.validqty!)) {
              return 'Enter valid Qty';
            } else {
              return null;
            }
          },
          keyboardType: const TextInputType.numberWithOptions(
              decimal: true, signed: false),
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
        ),
        if (state.validqty != null && state.validqty == false) ...[
          const SizedBox(
            height: 3,
          ),
          const InlinError(errorMessage: ' Not empty and < 6 digit')
        ]
      ],
    );
  }

  Widget _productLocationField(ProductFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppConst.pLocation,
          style: TextStyle(
            fontSize: 13,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 4,
        ),
        BorderTextField(
          controller: context.read<ProductBloc>().productLocationTxt,
          hintText: AppConst.pLocation,
          textInputAction: TextInputAction.next,
          onSave: (p0) => state.productLocation,
          isSuffix: state.validLocation != null ? true : false,
          suffixIcon: state.validLocation != null
              ? Icon(
                  state.validLocation!
                      ? Icons.check_circle_outline_outlined
                      : Icons.close,
                  color: state.validLocation!
                      ? AppColors.primaryColour
                      : AppColors.errorColour,
                )
              : const SizedBox.shrink(),
          onChanged: (_) async {
            context
                .read<ProductBloc>()
                .add(ProductLocationEvent(productLocation: _));
          },
          validator: (value) {
            if (value.isEmpty ||
                state.validLocation == null ||
                state.validLocation == false) {
              return 'Empty field not allow';
            } else {
              return null;
            }
          },
          maxLines: 5,
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(45),
          ],
        ),
        if (state.validLocation != null && state.validLocation == false) ...[
          const SizedBox(
            height: 3,
          ),
          const InlinError(errorMessage: ' Empty will not allow')
        ]
      ],
    );
  }

  Widget _btn() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: StreamBuilder<bool>(
                stream: context.read<ProductBloc>().validFormStream,
                initialData: false,
                builder: (context, snapshot) {
                  return GradientPrimaryButton(
                    enableFeedback: snapshot.data,
                    text: AppConst.pSubmit,
                    onPressed: () {
                      final state = context.read<ProductBloc>().state;
                      final item = ProductModel.fromMap({
                        "productType": state.productType,
                        "productName": state.productName,
                        "qty": state.productqty,
                        "price": state.productPrice,
                        "location": state.productLocation
                      });
                      if (widget.index != null) {
                        context
                            .read<ProductListBloc>()
                            .add(UpdateProductEvent(item, widget.index!));
                      } else {
                        context
                            .read<ProductListBloc>()
                            .add(AddnewProductEvent(item));
                      }
                      context.read<ProductBloc>().add(const ResetFormEvent());
                      Navigator.pop(context);
                    },
                    textColor: AppColors.whiteColourDisabled,
                    buttonColor: snapshot.data!
                        ? ManageTheme.lightTheme.primaryColor
                        : ManageTheme.lightTheme.primaryColor.withOpacity(0.6),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
