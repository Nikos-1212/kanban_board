

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/src/presentation/blocs/app/app_bloc.dart';
import 'package:task_tracker/src/presentation/views/enventory/enventory_list.dart';
import 'package:task_tracker/src/presentation/views/time_tracker/tasks_board.dart';
import 'package:task_tracker/src/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;
  static const routeName = '/';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {  
  final List<Widget> _examples = [
    const TaskBoard(),
    const EnventoryList(),
  ];
  @override
  Widget build(BuildContext context) {
    final res = context.watch<AppBloc>().state as AppInitial;
    return Scaffold(       
          body: _examples[res.appModel.currentTab],
          bottomNavigationBar: BottomNavigationBar(                        
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex:res.appModel.currentTab,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedItemColor: AppColors.primaryColour,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.task_outlined,),
                  label: "Card Tracker"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_shopping_cart_rounded, ),
                  label: "Enventory List"),
            ],
            onTap: (int index) {
              context.read<AppBloc>().add(UpdateAppTabEvent(currentTab: index));
            },
          ));
  }

}
