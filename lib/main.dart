import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:task_tracker/src/config/themes.dart';
import 'package:task_tracker/src/presentation/blocs/productList/product_list_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_tracker/src/presentation/blocs/task/task_bloc.dart';
import 'src/config/config.dart';
import 'src/presentation/blocs/app/app_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _init();
  runApp(const MyApp());
}

Future _init() async {
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (BuildContext context) => AppBloc(),
        ),
        BlocProvider<TaskBloc>(
          create: (BuildContext context) => TaskBloc(),
        ),
        BlocProvider<ProductListBloc>(
          create: (BuildContext context) => ProductListBloc(),
        ),
      ],
      child: BlocConsumer<AppBloc, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cs = state as AppInitial;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ManageTheme.lightTheme,
            darkTheme: ManageTheme.darkTheme,
            themeMode:
                cs.appModel.isLightTheme ? ThemeMode.light : ThemeMode.dark,
            onGenerateRoute: (settings) => generateRoute(settings),
          );
        },
      ),
    );
  }
}
