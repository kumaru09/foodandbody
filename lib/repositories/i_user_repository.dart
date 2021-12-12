import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/user.dart';

abstract class IUserRepository {
  Future<void> addUserInfo(Info info);

  Future<Info> getInfo();

  Future<void> updateInfo(User user);
}
