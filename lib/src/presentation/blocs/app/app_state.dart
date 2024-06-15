part of 'app_bloc.dart';

sealed class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
  
}

final class AppInitial extends AppState {
  final AppModel appModel;
  const AppInitial({required this.appModel});

  @override
  List<Object> get props => [appModel];
}
