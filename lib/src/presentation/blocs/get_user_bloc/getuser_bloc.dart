import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:task_tracker/src/data/repositories/export_user_repo.dart';

import '../../../domain/models/models.dart';
import '../../../domain/usecases/user_usecases/get_users.dart';
part 'getuser_event.dart';
part 'getuser_state.dart';

class Debouncer {
  final Duration delay;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.delay, required int milliseconds});

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(delay, action);
  }
}

class GetuserBloc extends Bloc<GetuserEvent, GetuserState> {
  final ScrollController scrollController = ScrollController();  
  bool isLoading = false;
  GetuserBloc() : super(GetuserLoding()) {
    on<InitialGetuserEvent>(initialGetuserEvent);
    on<LoadMoreGetuserEvent>(loadMoreGetuserEvent);
    _initScrollListener();
  }

  void _initScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (state is GetuserLodded) {
          final cs = state as GetuserLodded;
          if (cs.userModel.users != [] && !isLoading) {
            add(LoadMoreGetuserEvent(
                cs.userModel.offset! + 1, cs.userModel.limit ?? 20));
          }
        }
      }
    });
  }

  // RefreshController refreshController =RefreshController(initialRefresh: false);

  FutureOr<void> initialGetuserEvent(
      InitialGetuserEvent event, Emitter<GetuserState> emit) async {
    try {
      final apiRepository =  UserRemoteImpl(); // Or use a mock implementation for testing
      final getPostsUseCase = GetUsers(apiRepository);
      final res = await getPostsUseCase.call(event.offset, event.limit);
      if (res.success == true) {
        emit(GetuserLodded(userModel: res));
      } else {
        emit(GetuserError(error: res.toString()));
      }
    } catch (e) {
      emit(GetuserError(error: e.toString()));
    }
  }

  FutureOr<void> loadMoreGetuserEvent(
      LoadMoreGetuserEvent event, Emitter<GetuserState> emit) async {
    try {
      isLoading = true;
      final apiRepository = UserRemoteImpl(); // Or use a mock implementation for testing
      final getPostsUseCase = GetUsers(apiRepository);
      final res = await getPostsUseCase.call(event.offset, event.limit);
      if (res.success == true) {
        isLoading = true;
        if (event.offset >= 1) {
          if (state is GetuserLodded) {
            try {
              final currentState = state as GetuserLodded;
              final updatedUsersList = [
                ...currentState.userModel.users!,
                ...res.users!
              ];
              final updatedUserModel = currentState.userModel.copyWith(
                  users: updatedUsersList,
                  limit: res.limit,
                  offset: res.offset);

              final debouncer = Debouncer(
                  milliseconds: 100, delay: const Duration(milliseconds: 100));

              debouncer.run(() {
                // Use debounce to avoid multiple triggers
                isLoading = false;
              });
              emit(GetuserLodded(userModel: updatedUserModel));
              // refreshController.loadComplete();
              // refreshController.refreshCompleted();
            } catch (e) {
              emit(GetuserError(error: res.toString()));
            }
          }
        }
      } else {
        emit(GetuserError(error: res.toString()));
      }
    } catch (e) {
      emit(GetuserError(error: e.toString()));
    }
  }
}
