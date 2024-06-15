import 'package:task_tracker/src/data/repositories/user_repository_impl.dart';
import 'package:task_tracker/src/domain/models/user_model.dart';

class GetUsers {
  final UserRepository _repository;
  GetUsers(this._repository);

  Future<UserModel> call(int offset, int limit) async {
    return await _repository.getUserList(offset, limit);
  }
}
