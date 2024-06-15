import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../domain/models/models.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  AppBloc() : super(const AppInitial(appModel: AppModel.initial())) {
    on<UpdateAppLightEvent>(updateApptheme);
    on<UpdateAppTabEvent>(updateAppTabEvent);
    // on<AppEvent>((event, emit) {
    // });
  }



  @override
  Map<String, dynamic> toJson(AppState state) {
    if (state is AppInitial) {
      final modelJson = state.appModel.toMap();
      return {'appModel': modelJson}; ////
    }
    return {};
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    try {
      return AppInitial(
          appModel: AppModel.fromMap(json['appModel'] as Map<String, dynamic>));
    } catch (_) {
      return null;
    }
    // throw UnimplementedError();
  }
  FutureOr<void> updateApptheme(UpdateAppLightEvent event, Emitter<AppState> emit) {
    if (state is AppInitial) {
      final cs = state as AppInitial;
      final updated = cs.appModel.copyWith(isLightTheme: event.isLightTheme);
      toJson(AppInitial(appModel: updated));
      emit(AppInitial(appModel: updated));
    }
  }
  FutureOr<void> updateAppTabEvent(UpdateAppTabEvent event, Emitter<AppState> emit) {
        if (state is AppInitial) {
      final cs = state as AppInitial;
      final updated = cs.appModel.copyWith(currentTab: event.currentTab);
      toJson(AppInitial(appModel: updated));
      emit(AppInitial(appModel: updated));
    }
  }
}
