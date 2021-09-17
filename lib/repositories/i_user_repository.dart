import 'dart:ffi';

import 'package:foodandbody/models/info.dart';

abstract class IUserRepository {
  Future<void> addUserInfo(Info info);

  Stream<Info> info();

  Future<void> updateInfo(Info info);
}
