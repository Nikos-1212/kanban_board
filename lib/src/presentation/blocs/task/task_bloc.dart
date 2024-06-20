import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:task_tracker/src/customr_resources/kanban_board.dart';
import 'package:task_tracker/src/domain/models/task_model.dart';
import 'package:task_tracker/src/utils/utils.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends HydratedBloc<TaskBlocEvent, TaskBlocState> {
  final TextEditingController titleTxt =TextEditingController();
  final TextEditingController descriptionTxt =TextEditingController();
  final TextEditingController commentTxt =TextEditingController();
  late BehaviorSubject<bool> _validFormSubject;
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 800));
  late AppFlowyBoardController controller;
  

  TaskBloc() : super(TaskBlocInitial(TaskModel.initial())) {    
  controller = AppFlowyBoardController(
    onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move item from $fromIndex to $toIndex');
    },
    onMoveGroupItem: (groupId, fromIndex, toIndex) {
      debugPrint('Move custome $groupId:$fromIndex to $groupId:$toIndex');
      try {
         add(MoveGroupItemEvent(groupId, fromIndex, toIndex));
      } catch (e) {
        print(e.toString());
      }
        
    },
    onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move custome$fromGroupId:$fromIndex to $toGroupId:$toIndex');
      try {
        add(MoveGroupItemToGroupEvent(fromGroupId, fromIndex, toGroupId, toIndex));
      } catch (e) {
       print(e.toString()) ;
      }
    },
  );  
    _validFormSubject = BehaviorSubject<bool>.seeded(false);
    on<AddnewTaskEvent>(addnewTaskEvent,);
    on<TitleEvent>(_titleEvent);
    on<DescriptionEvent>(_descriptionEvent);
    on<CommentEvent>(_commentEvent);
    on<NumOfDayEvent>(_numOfDayEvent);
    on<ResetControllersEvent>(_resetControllersEvent);
    on<MoveGroupItemEvent>(_moveGroupItemEvent);
    on<MoveGroupItemToGroupEvent>(_moveGroupItemToGroupEvent);
    _init();
  }
Stream<bool> get validFormStream => _validFormSubject.stream;  
late AppFlowyBoardScrollController boardController;
 AppFlowyGroupData? group1;
 AppFlowyGroupData? group2;
 AppFlowyGroupData? group3;
Future _init()async
{
  
    boardController = AppFlowyBoardScrollController();    
    if(state is TaskBlocInitial)
    {
      final cs =state as TaskBlocInitial;
      
      if(cs.taskModel.dataList.isNotEmpty ||cs.taskModel.dataList2.isNotEmpty||cs.taskModel.dataList3.isNotEmpty)
      {
            group1 = AppFlowyGroupData(id: "1", name: "To Do", items:<AppFlowyGroupItem>[...cs.taskModel.dataList],);        
            group2 = AppFlowyGroupData(id: "2", name: "In Progress", items:<AppFlowyGroupItem>[...cs.taskModel.dataList2]);    
            group3 = AppFlowyGroupData(id: "3", name: "Completed", items:<AppFlowyGroupItem>[...cs.taskModel.dataList3]);                       
      }
      else
      {
            group1 = AppFlowyGroupData(id: "1", name: "To Do", items: 
         <AppFlowyGroupItem> [    ],);
            group2 = AppFlowyGroupData(
            id: "2",
            name: "In Progress",
            items: [
              
            ],
          );
            group3 = AppFlowyGroupData(
              id: "3",
              name: "Completed",
              items:<AppFlowyGroupItem> [
              ]);
      }
        controller.enableGroupDragging(false);
        controller.addGroup(group1!);
        controller.addGroup(group2!);
        controller.addGroup(group3!);                
    }
}
   @override
  Map<String, dynamic> toJson(TaskBlocState state) {
    if (state is TaskBlocInitial) {
      final modelJson = state.taskModel.toMap();
      return {'taskModel': modelJson}; ////
    }
    return {};
  }

  @override
  TaskBlocState? fromJson(Map<String, dynamic> json) {
    try {
      return TaskBlocInitial(
        TaskModel.fromMap(
            json['taskModel'] as Map<String, dynamic>),
      );
    } catch (_) {
      return null;
    }
    // throw UnimplementedError();
  }
  
FutureOr<void> addnewTaskEvent(AddnewTaskEvent event, Emitter<TaskBlocState> emit) {
  // Add the new task to the group
  controller.addGroupItem(event.groupIndex.toString(), event.addNewTask);

  // Proceed only if the state is TaskBlocInitial
  if (state is TaskBlocInitial) {
    final cs = state as TaskBlocInitial;

    // Retrieve and filter the group items
    final groupItems = _getGroupItems(event.groupIndex.toString());

    // Update the task model and emit the new state
    final updatedModel = _updateTaskModel(cs.taskModel, groupItems, event.groupIndex.toString());
    emit(TaskBlocInitial(updatedModel));

    // Save to JSON
    toJson(TaskBlocInitial(updatedModel));
  }
}
  // FutureOr<void> addnewTaskEvent(AddnewTaskEvent event, Emitter<TaskBlocState> emit) {
  //  controller.addGroupItem(event.groupIndex.toString(), event.addNewTask);
  //      if (state is TaskBlocInitial) {      
  // final cs = state as TaskBlocInitial;      
  // final list = controller.getGroupController('${event.groupIndex}');
  // final List<AppFlowyGroupItem> ll = list?.items ?? [];
  
  // // Ensure all items in ll are of type DataList
  // if (ll.every((item) => item is DataList)) {
  //   final List<DataList> dataList = ll.cast<DataList>();
  //   final updated = event.groupIndex == 1
  //       ? cs.taskModel.copyWith(dataList: dataList)
  //       : event.groupIndex == 2
  //           ? cs.taskModel.copyWith(dataList2: dataList)
  //           : cs.taskModel.copyWith(dataList3: dataList);
  //   toJson(TaskBlocInitial(updated));    
  //   emit(TaskBlocInitial(updated));
  // } else {
  //   // Handle the case where items are not of type DataList
  //   throw Exception("List contains items that are not of type DataList");
  // }      
  //   }  
  // }

  FutureOr<void> _titleEvent(TitleEvent event, Emitter<TaskBlocState> emit) async{
     final completer = Completer<void>();
    _debouncer.run(() {
    if(state is TaskBlocInitial)
    {      
      final cs = state as TaskBlocInitial;
      final updated = cs.taskModel.copyWith(title: event.title);      
       emit(TaskBlocInitial(updated));
      _uf();      
    }
    completer.complete();
    });    
      await completer.future;
  }

  FutureOr<void> _descriptionEvent(DescriptionEvent event, Emitter<TaskBlocState> emit) async{
    final completer = Completer<void>();
    _debouncer.run(() {
    if(state is TaskBlocInitial)
    {      
      final cs = state as TaskBlocInitial;
      final updated = cs.taskModel.copyWith(description: event.description);
      emit(TaskBlocInitial(updated));
      _uf();
    }
    completer.complete();
    });
    await completer.future;
  }

  FutureOr<void> _commentEvent(CommentEvent event, Emitter<TaskBlocState> emit) async{
    final completer = Completer<void>();
    _debouncer.run(() {
        if(state is TaskBlocInitial)
        {      
          final cs = state as TaskBlocInitial;
          final updated = cs.taskModel.copyWith(comments: event.comment);
          emit(TaskBlocInitial(updated));
          _uf();
        }
        completer.complete();
    });
    await completer.future;
  }
  FutureOr<void> _numOfDayEvent(NumOfDayEvent event, Emitter<TaskBlocState> emit) {
      if(state is TaskBlocInitial)
        {      
          final cs = state as TaskBlocInitial;
          final updated = cs.taskModel.copyWith(numOfDay: event.days);
          emit(TaskBlocInitial(updated));
          _uf();
        }
  }
   FutureOr<void> _resetControllersEvent(ResetControllersEvent event, Emitter<TaskBlocState> emit) {
    titleTxt.clear();
    descriptionTxt.clear();
    commentTxt.clear();
     if(state is TaskBlocInitial)
        {      
          final cs = state as TaskBlocInitial;
          final updated = cs.taskModel.copyWith(numOfDay: 0,comments: '',description: '',title: '',);
          emit(TaskBlocInitial(updated));
          _validFormSubject = BehaviorSubject<bool>.seeded(false);
          _uf();
        }
  }
    void _uf() {
  if(state is TaskBlocInitial)
  {
    final cs = state as TaskBlocInitial;
    final updated = cs.taskModel.copyWith(title: cs.taskModel.title??'',description: cs.taskModel.description??'',comments: cs.taskModel.comments??'');          
    final isValid = updated.title!.isNotEmpty &&
        updated.description!.isNotEmpty &&
        updated.comments!.isNotEmpty &&
        updated.numOfDay!=0;
        _validFormSubject.add(isValid);
  }
  else
  {
    _validFormSubject.add(false);
  }
  }

  
  @override
  Future<void> close() {
    _validFormSubject.close();
    titleTxt.clear();
    descriptionTxt.clear();
    commentTxt.clear();
    return super.close();
  }

  

FutureOr<void> _moveGroupItemEvent(MoveGroupItemEvent event, Emitter<TaskBlocState> emit) {
  if (state is TaskBlocInitial) {
    final cs = state as TaskBlocInitial;
    final groupItems = _getGroupItems(event.groupId);

    final updatedModel = _updateTaskModel(cs.taskModel, groupItems, event.groupId);
    emit(TaskBlocInitial(updatedModel));

    // Save to JSON
    toJson(TaskBlocInitial(updatedModel));
  }
} 
FutureOr<void> _moveGroupItemToGroupEvent(MoveGroupItemToGroupEvent event, Emitter<TaskBlocState> emit) {
  if (state is TaskBlocInitial) {
    final cs = state as TaskBlocInitial;

    final fromGroupItems = _getGroupItems(event.fromGroupId);
    final toGroupItems = _getGroupItems(event.toGroupId);

    // Update from group
    final updatedFromGroupModel = _updateTaskModel(cs.taskModel, fromGroupItems, event.fromGroupId);
    emit(TaskBlocInitial(updatedFromGroupModel));

    // Update to group
    final updatedToGroupModel = _updateTaskModel(updatedFromGroupModel, toGroupItems, event.toGroupId);
    emit(TaskBlocInitial(updatedToGroupModel));

    // Save to JSON
    toJson(TaskBlocInitial(updatedToGroupModel));
  }
}

List<DataList> _getGroupItems(String groupId) {
  final groupController = controller.getGroupController(groupId);
  final groupItems = groupController?.items ?? [];
  final filteredItems = groupItems.whereType<DataList>().toList();
  return filteredItems;
}

TaskModel _updateTaskModel(TaskModel taskModel, List<DataList> dataList, String groupId) {
  switch (groupId) {
    case '1':
      return taskModel.copyWith(dataList: dataList);
    case '2':
      return taskModel.copyWith(dataList2: dataList);
    case '3':
      return taskModel.copyWith(dataList3: dataList);
    default:
      throw Exception("Invalid group ID");
  }
}
}
