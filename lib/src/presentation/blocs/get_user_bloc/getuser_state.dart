part of 'getuser_bloc.dart';

sealed class GetuserState extends Equatable {
  const GetuserState();

  @override
  List<Object> get props => [];
}

final class GetuserLoding extends GetuserState {
  @override
  List<Object> get props => [];
}

final class GetuserLodded extends GetuserState {
  const GetuserLodded({required this.userModel});
  final UserModel userModel;

  @override
  List<Object> get props => [userModel];
}

final class GetuserError extends GetuserState {
  final String error;
  const GetuserError({required this.error});
  @override
  List<Object> get props => [error];
}
