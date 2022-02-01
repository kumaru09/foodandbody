import 'package:foodandbody/models/info.dart';

abstract class IUserRepository {
  Future<void> addUserInfo(Info info);

  Future<Info> getInfo();

  Future<void> updateInfo(Info info);
}
