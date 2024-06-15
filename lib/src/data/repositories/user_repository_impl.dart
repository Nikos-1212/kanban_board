import 'package:task_tracker/src/data/data_sources/remote/remote.dart';
import 'package:task_tracker/src/domain/models/models.dart';
abstract class UserRepository {  
  Future<UserModel> getUserList(int offset, int limit);
}
class UserRemoteImpl implements UserRepository {
  static final  BaseApiServices _apiServices = NetworkApiService();   
  @override
  Future<UserModel> getUserList(int offset, int limit) async {
    final res = await _apiServices.getGetApiResponse('${ApiURL.getUserPoint}?offset=$offset&limit=$limit');
    return UserModel.fromJson(res);
  }
}
// import 'package:task_tracker/src/data/data_sources/remote/user_remote.dart';
// import 'package:task_tracker/src/domain/repositories/user_repository.dart';
// import '../../domain/models/models.dart';

// class UserRepositoryImpl implements UserRepository {
//   final UserRemote _remoteUserource;
//   const UserRepositoryImpl(this._remoteUserource);
//   @override
//   Future<UserModel> getUserList(int offset, int limit) async {
//     final result = await _remoteUserource.getUserList(offset, limit);
//     return result;
//   }
// }



