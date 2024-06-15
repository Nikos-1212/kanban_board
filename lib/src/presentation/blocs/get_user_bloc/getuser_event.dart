part of 'getuser_bloc.dart';

sealed class GetuserEvent extends Equatable {
  const GetuserEvent();

  @override
  List<Object> get props => [];
}

class InitialGetuserEvent extends GetuserEvent {
  const InitialGetuserEvent(this.offset, this.limit);
  final int offset;
  final int limit;
  @override
  List<Object> get props => [offset, limit];
}

class LoadMoreGetuserEvent extends GetuserEvent {
  const LoadMoreGetuserEvent(this.offset, this.limit);
  final int offset;
  final int limit;
  @override
  List<Object> get props => [offset, limit];
}
