import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/user.dart';

abstract class IUserRepository {
  Future<void> addUserInfo(User user);

  Future<User> getInfo(User user);

  Future<void> updateInfo(User user);
}
