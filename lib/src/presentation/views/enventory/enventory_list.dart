import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/src/config/config.dart';
import 'package:task_tracker/src/domain/models/models.dart';
import 'package:task_tracker/src/presentation/blocs/app/app_bloc.dart';
import 'package:task_tracker/src/presentation/blocs/get_user_bloc/getuser_bloc.dart';
import 'package:task_tracker/src/presentation/blocs/product/product_bloc.dart';
import 'package:task_tracker/src/presentation/blocs/productList/product_list_bloc.dart';
import 'package:task_tracker/src/presentation/views/enventory/add_product.dart';
import 'package:task_tracker/src/presentation/views/user_list_bloc.dart';
import 'package:task_tracker/src/presentation/widgets/inventory_card.dart';
import 'package:task_tracker/src/utils/utils.dart';

class EnventoryList extends StatelessWidget {
  const EnventoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                GeneralNavigator(
                    context: context,
                    page: BlocProvider<GetuserBloc>(
                      create: (context) =>
                          GetuserBloc()..add(const InitialGetuserEvent(1, 20)),
                      child: const UserPageList(20, 1),
                    )).navigateFromRight();
              },
              icon: const Icon(CupertinoIcons.person_2_square_stack)),
          _switch(context),
          const SizedBox(
            width: 10,
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(AppConst.enventoryList),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GeneralNavigator(
              context: context,
              page: BlocProvider<ProductBloc>(
                create: (context) => ProductBloc(),
                child: const AddProduct(),
              )).navigateFromRight();
        },
        tooltip: AppConst.addProductSign,
        child: const Icon(Icons.add),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return BlocBuilder<ProductListBloc, ProductListState>(
      builder: (context, state) {
        if (state is ProductListInitial) {
          final list = state.productListModel.productList;
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, int index) {
                  final data = ProductModel.fromMap(
                    list[index],
                  );
                  return Dismissible(
                      background: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.red,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(CupertinoIcons.delete_simple,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        context
                            .read<ProductListBloc>()
                            .add(DeleteProductEvent(index));
                      },
                      child: InventoryCards(data: data, index: index));
                }),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _switch(BuildContext context) {    
    return BlocSelector<AppBloc, AppState, bool>(
       selector: (state) {
        if (state is AppInitial) {
          return state.appModel.isLightTheme;
        }
        return true; // default value in case state is not AppInitial
        // final res = context.read<AppBloc>().state as AppInitial;
      },
      builder: (context, isLightTheme) {
        return GestureDetector(
              onTap: () => context.read<AppBloc>().add(
            UpdateAppLightEvent(isLightTheme: !isLightTheme),
          ),
            child: Icon(
              isLightTheme ? Icons.light : Icons.light_outlined,
              size: 28,
            ));
      },
    );
  }
}
