part of 'task_bloc.dart';

sealed class TaskBlocEvent extends Equatable {
  const TaskBlocEvent();

  @override
  List<Object> get props => [];
}

class AddnewTaskEvent extends TaskBlocEvent {
  const AddnewTaskEvent(this.addNewTask,this.groupIndex);
  final DataList addNewTask;
  final int groupIndex;
  @override
  List<Object> get props => [addNewTask,groupIndex];
}

class TitleEvent extends TaskBlocEvent {
  const TitleEvent(this.title);  
  final String title;
  @override
  List<Object> get props => [title];
}
class DescriptionEvent extends TaskBlocEvent {
  const DescriptionEvent(this.description);  
  final String description;
  @override
  List<Object> get props => [description];
}

class CommentEvent extends TaskBlocEvent {
  const CommentEvent(this.comment);  
  final String comment;
  @override
  List<Object> get props => [comment];
}
class NumOfDayEvent extends TaskBlocEvent {
  const NumOfDayEvent(this.days);  
  final int days;
  @override
  List<Object> get props => [days];
}
class ResetControllersEvent extends TaskBlocEvent {    
  @override
  List<Object> get props => [];
}

