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
  final AppFlowyBoardController controller = AppFlowyBoardController(
    onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move item from $fromIndex to $toIndex');
    },
    onMoveGroupItem: (groupId, fromIndex, toIndex) {
      debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');
    },
    onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move $fromGroupId:$fromIndex to $toGroupId:$toIndex');
    },

  );

  TaskBloc() : super(TaskBlocInitial(TaskModel.initial())) {    
    _validFormSubject = BehaviorSubject<bool>.seeded(false);
    on<AddnewTaskEvent>(addnewTaskEvent);
    on<TitleEvent>(_titleEvent);
    on<DescriptionEvent>(_descriptionEvent);
    on<CommentEvent>(_commentEvent);
    on<NumOfDayEvent>(_numOfDayEvent);
    on<ResetControllersEvent>(_resetControllersEvent);
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
      final list= cs.taskModel.appFlowyGroupData??[];
      if(list.isNotEmpty)
      {
        print(list);
      }
      else
      {
            group1 = AppFlowyGroupData(id: "1", name: "To Do", items: 
          [    ],);
            group2 = AppFlowyGroupData(
            id: "2",
            name: "In Progress",
            items: <AppFlowyGroupItem>[
              
            ],
          );
            group3 = AppFlowyGroupData(
              id: "3",
              name: "Completed",
              items: <AppFlowyGroupItem>[
              ]);

      }

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
    if(event.groupIndex==1)
    {      
      controller.addGroupItem(group1?.id??'1', event.addNewTask);
    }
    else if(event.groupIndex==2)
    {
      controller.addGroupItem(group2?.id??'2', event.addNewTask);
      // group2?.items.add(event.addNewTask);
    }
    else if(event.groupIndex==3)
    {
      controller.addGroupItem(group3?.id??'3', event.addNewTask);      
      // group3?.items.add(event.addNewTask); 
    }
     if(state is TaskBlocInitial)
    {      
      final cs = state as TaskBlocInitial;      
      // final updated = cs.taskModel.copyWith(appFlowyGroupData: controller.groupDatas);
      final list = controller.getGroupController('${group1?.id}');
      print(list?.items);
      // toJson(TaskBlocInitial(updated));      
      //  emit(TaskBlocInitial(updated));      
    }
    
  }

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

  

 
}
