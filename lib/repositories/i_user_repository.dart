import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/user.dart';

abstract class IUserRepository {
  Future<void> addUserInfo(uid, Info info);

  Future<User> getInfo(User user);

  Future<void> updateInfo(User user);
}
