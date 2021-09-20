import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/info.dart';

class User extends Equatable {
  const User(
      {required this.uid, this.email, this.name, this.photoUrl, this.info});

  final String? email;
  final String? uid;
  final String? name;
  final String? photoUrl;
  final Info? info;

  static const empty = User(uid: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, uid, name, photoUrl, info];

  User copyWith({
    String? email,
    String? uid,
    String? name,
    String? photoUrl,
    Info? info,
  }) {
    return User(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        name: name ?? this.name,
        photoUrl: photoUrl ?? this.photoUrl,
        info: info ?? this.info);
  }
}
