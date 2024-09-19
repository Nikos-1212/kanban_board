import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/src/config/themes.dart';
import 'package:task_tracker/src/customr_resources/kanban_board.dart';
import 'package:task_tracker/src/domain/models/task_model.dart';
import 'package:task_tracker/src/presentation/blocs/app/app_bloc.dart';
import 'package:task_tracker/src/presentation/blocs/task/task_bloc.dart';
import 'package:task_tracker/src/presentation/widgets/primary_btn.dart';
import 'package:task_tracker/src/presentation/widgets/textfiled.dart';
import 'package:task_tracker/src/utils/utils.dart';

class TaskBoard extends StatelessWidget {
  const TaskBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(AppConst.taskTracker),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return 
     BlocSelector<AppBloc, AppState, bool>(
       selector: (state) {
        if (state is AppInitial) {
          return state.appModel.isLightTheme;
        }
        return true; // default value in case state is not AppInitial
        // final res = context.read<AppBloc>().state as AppInitial;
      },
      builder: (bc, isLightTheme) {
    
    return AppFlowyBoard(
        controller: context.read<TaskBloc>().controller,
        cardBuilder: (c, group, groupItem,index) {          
          return AppFlowyGroupCard(
            key: ValueKey(groupItem.id),
            onTap: () {
            
            },
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.5),              
              color: isLightTheme?Colors.white:AppColors.primaryColour.withOpacity(0.5)
            ),
            child: _buildCard(groupItem,group,index,context),
          );
        },
        boardScrollController: context.read<TaskBloc>().boardController,
        footerBuilder: (context, columnData) {
          return const AppFlowyGroupFooter(
            // icon: const Icon(Icons.add, size: 20),
            // title: const Text('New'),
            height: 12,
            // margin: AppFlowyBoardConfig(
            //   groupBackgroundColor: HexColor.fromHex('#F7F8FC'),
            //   stretchGroupHeight: false,
            // ).groupBodyPadding,
            // onAddButtonClick: () {
            //   context
            //       .read<TaskBloc>()
            //       .boardController
            //       .scrollToBottom(columnData.id);
            // },
          );
        },
        headerBuilder: (context, columnData) {
          return AppFlowyGroupHeader(
            icon: const Icon(Icons.lightbulb_circle),
            onAddButtonClick: () {
              // context.read<TaskBloc>().add(ResetControllersEvent());
              if (columnData.id == '1') {
                _addNewTaskDialog(context, 1);
              } else if (columnData.id == '2') {
                _addNewTaskDialog(context, 2);
                // context.read<TaskBloc>().add(AddnewTaskEvent(addNewTask, 2));
              } else if (columnData.id == '3') {
                _addNewTaskDialog(context, 3);
                // context.read<TaskBloc>().add(AddnewTaskEvent(addNewTask, 2));
              }
              print(columnData.id);
            },

            title: Expanded(child: Text(columnData.headerData.groupName)),
            //  SizedBox(
            //   width: 120,
            //   child: TextField(
            //     controller: TextEditingController()
            //       ..text = columnData.headerData.groupName,
            //     onSubmitted: (val) {
            //       controller
            //           .getGroupController(columnData.headerData.groupId)!
            //           .updateGroupName(val);
            //     },
            //   ),
            // ),
            addIcon: const Icon(Icons.add, size: 20),
            moreIcon: const Icon(Icons.more_horiz, size: 20),
            height: 50,
            margin: AppFlowyBoardConfig(
              groupBackgroundColor: HexColor.fromHex('#F7F8FC'),
              stretchGroupHeight: false,
            ).groupBodyPadding,
          );
        },
        groupConstraints: BoxConstraints.tightFor(
            width: Platform.isIOS || Platform.isAndroid
                ? MediaQuery.of(context).size.width - 45
                : 240),
        config: AppFlowyBoardConfig(
          groupBackgroundColor: HexColor.fromHex('#F7F8FC'),
          stretchGroupHeight: false,
        ), onMoveGroupItem: (String groupId, int fromIndex, int toIndex) {  

          debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');
        }, onMoveGroupItemToGroup: (String fromGroupId, int fromIndex, String toGroupId, int toIndex) { 
          debugPrint('Move $fromGroupId:$fromIndex to $toGroupId:$toIndex');
         },);
      });
  }

  Widget _buildCard(AppFlowyGroupItem item,AppFlowyGroupData<dynamic> group,int index,BuildContext context) {
    if (item is DataList) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                     Row(                
                      crossAxisAlignment: CrossAxisAlignment.start,                       
                       children: [
                         Expanded(child: Text(item.titile).text13W500()),
                         _menu(item,group,index,context)
                       ],
                     ),
                     item.description.readMoreTextDefault(),
                ],
              ),
            ),
          ],
        ),
      );
    }
    // if (item is RichTextItem) {
    //   return RichTextCard(item: item);
    // }
    throw UnimplementedError();
  }

  Future<void> _addNewTaskDialog(BuildContext context, int index) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: false,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (c) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.6,
        maxChildSize: 0.9,
        expand: false,
        builder: (bc, controller) => Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  25.kw,
                  const Expanded(
                      flex: 1,
                      child: Text(
                        AppConst.addNewTicket,
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      )),
                  Expanded(
                      flex: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                      )),
                ],
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  controller: controller,
                  children: [
                    15.kh,
                    _title(context),
                    15.kh,
                    _description(context),
                    15.kh,
                    _comment(context),
                    15.kh,
                    _numOfdaysDrop(context),
                    15.kh,
                  ],
                ),
              ),
              _btn(context, index)
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppConst.title,
          style: TextStyle(
            fontSize: 13,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 4,
        ),
        BlocSelector<TaskBloc, TaskBlocState, String>(
          selector: (state) {
            if (state is TaskBlocInitial) {
              return state.taskModel.title ?? '';
            }
            return '';
          },
          builder: (context, title) {
            return BorderTextField(
              controller: context.read<TaskBloc>().titleTxt,
              hintText: AppConst.title,
              textInputAction: TextInputAction.next,
              onSave: (p0) => title,
              onChanged: (_) async {
                context.read<TaskBloc>().add(TitleEvent(_));
              },
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(65),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _description(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppConst.description,
          style: TextStyle(
            fontSize: 13,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 4,
        ),
        BlocSelector<TaskBloc, TaskBlocState, String>(
          selector: (state) {
            if (state is TaskBlocInitial) {
              return state.taskModel.description ?? '';
            }
            return '';
          },
          builder: (context, description) {
            return BorderTextField(
              controller: context.read<TaskBloc>().descriptionTxt,
              hintText: AppConst.description,
              textInputAction: TextInputAction.next,
              onSave: (p0) => description,
              onChanged: (_) async {
                context.read<TaskBloc>().add(DescriptionEvent(_));
              },
              maxLines: 3,
            );
          },
        ),
      ],
    );
  }

  Widget _comment(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppConst.comments,
          style: TextStyle(
            fontSize: 13,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 4,
        ),
        BlocSelector<TaskBloc, TaskBlocState, String>(
          selector: (state) {
            if (state is TaskBlocInitial) {
              return state.taskModel.comments ?? '';
            }
            return '';
          },
          builder: (context, comments) {
            return BorderTextField(
              controller: context.read<TaskBloc>().commentTxt,
              hintText: AppConst.comments,
              textInputAction: TextInputAction.next,
              onSave: (p0) => comments,
              onChanged: (_) async {
                context.read<TaskBloc>().add(CommentEvent(_));
              },
              maxLines: 3,
            );
          },
        ),
      ],
    );
  }

  Widget _numOfdaysDrop(BuildContext context) {
    final res = context.read<AppBloc>().state as AppInitial;
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
                  border: Border.all(
                      color: res.appModel.isLightTheme
                          ? Colors.black54
                          : AppColors.whiteColour,
                      width: 0),
                  // color: AppColor.grey10,
                ),
                child: BlocSelector<TaskBloc, TaskBlocState, int>(
                  selector: (state) {
                    if (state is TaskBlocInitial) {
                      return state.taskModel.numOfDay ?? 0;
                    }
                    return 0;
                  },
                  builder: (context, numOfDay) {
                    return DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none, // Remove underline
                      ),
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Color(0xff3C3C3E)),
                      hint: const Text(
                        AppConst.selectDay,
                        style: TextStyle(color: Color(0xffD9D9E1)),
                      ),
                      value:
                          numOfDay, //numOfDay==0?AppConst.selectDay:'$numOfDay',
                      items: AppConst.dayList.map((dynamic item) {
                        return DropdownMenuItem<int>(
                          value: item,
                          onTap: () {
                            // sourceofLeadID =dropDownStringItem.sId;
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              item == 0 ? AppConst.selectDay : '$item',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (dynamic d) {
                        FocusScope.of(context).unfocus();
                        context.read<TaskBloc>().add(NumOfDayEvent(d));
                      },
                      isExpanded: true,
                    );
                    // return BorderTextField(
                    //   controller: context.read<TaskBloc>().commentTxt,
                    //   hintText: AppConst.numOfDay,
                    //   textInputAction: TextInputAction.next,
                    //   onSave: (p0) => numOfDay.toString(),
                    //   onChanged: (_) async {
                    //     context.read<TaskBloc>().add(DescriptionEvent(_));
                    //   },
                    //   maxLines: 2,
                    // );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _btn(BuildContext context, int index) {
    return Row(
      children: [
        Expanded(
          child: StreamBuilder<bool>(
              stream: context.read<TaskBloc>().validFormStream,
              initialData: false,
              builder: (context, snapshot) {                
                return GradientPrimaryButton(
                  enableFeedback: snapshot.data,
                  text: AppConst.pSubmit,
                  onPressed: () {
                    final state = context.read<TaskBloc>().state;
                    if (state is TaskBlocInitial) {
                     final length= state.taskModel.totalcards+1; 
                      final tsk = DataList(
                          s:length.toString(),
                          cat: '$index',
                          titile: state.taskModel.title ?? '', //textfield
                          createdDate: DateTime.now().millisecondsSinceEpoch,
                          description:state.taskModel.description ?? '', //textfield
                          images: [],
                          comments: [
                            Comment.fromMap({
                              "text": state.taskModel.comments ?? '',
                              "dt": DateTime.now().millisecondsSinceEpoch
                            })
                          ], //textfield
                          durationOfTask: DurationOfTask.fromMap(
                              {"in_progress": 0, "completed": 0}),
                          lastDate: DateTime.now()
                              .add(
                                  Duration(days: state.taskModel.numOfDay ?? 0))
                              .millisecondsSinceEpoch,
                          totalDays: state.taskModel.numOfDay ?? 0);
                      context.read<TaskBloc>().add(AddnewTaskEvent(tsk, index,length));
                      Navigator.pop(context);
                    }
                  },
                  textColor: AppColors.whiteColourDisabled,
                  buttonColor: snapshot.data!
                      ? ManageTheme.lightTheme.primaryColor
                      : ManageTheme.lightTheme.primaryColor.withOpacity(0.6),
                );//// final res = context.read<AppBloc>().state as AppInitial;
              }),
        ),
      ],
    );
  }


Widget _menu(DataList item,AppFlowyGroupData<dynamic> group,int index,BuildContext context) {
  return SizedBox(
    height: 20,
    width: 28,
    child: PopupMenuButton<String>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: const Color(0XFF353640),
      elevation: 4.0,
      tooltip: 'View options',
      icon: const Icon(CupertinoIcons.ellipsis,size: 18,),
      onSelected: (String value) async {
        if(value =='1')
        {
          // item
        }
        else if(value =='2')
        {
          //remove item
          print('$index------>${group.id}');
          try {
            
          context.read<TaskBloc>().add(DeleteItemFromGroupListEvent(group.id, index,item.id));
          } catch (e) {
            print(e.toString());
          }
          
        }
      },  
      position: PopupMenuPosition.under,
      itemBuilder: (BuildContext context) => _menuItems(),
    ),
  );
}

List<PopupMenuEntry<String>> _menuItems() {
  return [
    _buildMenuItem('1', CupertinoIcons.info, 'View details'),
    _buildMenuItem('2', CupertinoIcons.delete_simple, 'Remove'),
  ];
}

PopupMenuItem<String> _buildMenuItem(String value, IconData icon, String text) {
  return PopupMenuItem<String>(
    height: 25,
    value: value,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}

}
//__________________________end
