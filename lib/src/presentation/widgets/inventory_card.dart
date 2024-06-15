import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/src/config/themes.dart';
import 'package:task_tracker/src/utils/utils.dart';
import '../../config/router_config.dart';
import '../../domain/models/product_model.dart';
import '../blocs/app/app_bloc.dart';
import '../blocs/product/product_bloc.dart';
import '../views/enventory/add_product.dart';

class InventoryCards extends StatelessWidget {
  const InventoryCards({super.key, required this.data, required this.index});
  final ProductModel data;
  final int index;
  @override
  Widget build(BuildContext context) {
    final res = context.read<AppBloc>().state as AppInitial;
    return GestureDetector(
      onTap: () {
        GeneralNavigator(
            context: context,
            page: BlocProvider<ProductBloc>(
              create: (context) => ProductBloc(),
              child: AddProduct(index: index),
            )).navigateFromRight();
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 8, top: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.2)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    data.productName,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  )),
                  Text(
                    data.qty,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    data.location,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  )),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '${data.price} * ${data.qty} ',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: res.appModel.isLightTheme
                                  ? ManageTheme.lightTheme.primaryColor
                                  : ManageTheme.darkTheme.dividerColor),
                        ),
                        TextSpan(
                          text: '=> ${data.price.multiply(data.qty)}',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: ManageTheme.lightTheme.primaryColorDark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
