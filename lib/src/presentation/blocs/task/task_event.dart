part of 'task_bloc.dart';

sealed class TaskBlocEvent extends Equatable {
  const TaskBlocEvent();

  @override
  List<Object> get props => [];
}

class AddnewTaskEvent extends TaskBlocEvent {
  const AddnewTaskEvent(this.addNewTask,this.groupIndex,this.lid);
  final DataList addNewTask;
  final int groupIndex;
  final int lid;
  @override
  List<Object> get props => [addNewTask,groupIndex,lid];
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

class MoveGroupItemEvent extends TaskBlocEvent {
  final String groupId;
  final int fromIndex;
  final int toIndex;

  const MoveGroupItemEvent(this.groupId, this.fromIndex, this.toIndex);
  @override
  List<Object> get props => [groupId,fromIndex,toIndex];
}

class MoveGroupItemToGroupEvent extends TaskBlocEvent {
  final String fromGroupId;
  final int fromIndex;
  final String toGroupId;
  final int toIndex;

  const MoveGroupItemToGroupEvent(this.fromGroupId, this.fromIndex, this.toGroupId, this.toIndex);
  @override
  List<Object> get props => [fromGroupId,fromIndex,toGroupId,toIndex];
}

class DeleteItemFromGroupListEvent extends TaskBlocEvent {
  
  final String groupId;
  final int index;
  final String itemId;

  const DeleteItemFromGroupListEvent(this.groupId, this.index,this.itemId);
  @override
  List<Object> get props => [groupId,index,itemId];
}