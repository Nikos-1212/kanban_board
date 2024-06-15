import '../../models/models.dart';

abstract class UserRepository {
  const UserRepository();
  Future<UserModel> getUserList(int offset, int limit);
}
