part of 'task_bloc.dart';

sealed class TaskBlocState extends Equatable {
  const TaskBlocState();
  
  @override
  List<Object> get props => [];
}

final class TaskBlocInitial extends TaskBlocState {
  const TaskBlocInitial(this.taskModel);
  final TaskModel taskModel;

  @override
  List<Object> get props => [taskModel];
}
